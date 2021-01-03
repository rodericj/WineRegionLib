//
//  RegionJson.swift
//  
//
//  Created by Roderic Campbell on 1/1/21.
//

import Foundation


@propertyWrapper
public struct DecodableUUID {
    public var wrappedValue = UUID()
    public init() {
        wrappedValue = UUID()
    }
}

extension DecodableUUID: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        wrappedValue = try container.decode(UUID.self)
    }
}

extension KeyedDecodingContainer {
    func decode(_ type: DecodableUUID.Type,
                forKey key: Key) throws -> DecodableUUID {
        try decodeIfPresent(type, forKey: key) ?? .init()
    }
}
public struct RegionJson: Decodable, Identifiable {
    @DecodableUUID public var id: UUID
    public let title: String
    public let url: String?
    public let children: [RegionJson]?
    public init(title: String, url: String, children: [RegionJson]?) {
        self.title = title
        self.url = url
        self.children = children
    }

    private enum CodingKeys: String, CodingKey {
        case title
        case url
        case children
    }

    public init(from decoder:Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let theseChildren = try container.decodeIfPresent([RegionJson]?.self, forKey: .children)
            self.children = theseChildren??.sorted { $0.title < $1.title }
            url = try container.decodeIfPresent(String?.self, forKey: .url) ?? nil
            title = try container.decode(String.self, forKey: .title)

        } catch {
            print(error)
            fatalError()
        }
    }
}

public extension RegionJson {
    func filter(searchString: String) -> [RegionJson] {
        guard let children = children else {
            if title.contains(searchString) {
                return [self]
            } else {
                return []
            }
        }
        if children.isEmpty {
            if title.contains(searchString) {
                return [self]
            } else {
                return []
            }
        }
        var ret: [RegionJson] = []
        if title.contains(searchString) {
            ret.append(self)
        }
        children.forEach { region in
            ret.append(contentsOf: region.filter(searchString: searchString))
        }
        return ret
    }
}

extension RegionJson {
    func filter(on searchText: String) -> Bool {
        if title.contains(searchText) { return true }
        if let children = children {
            return children.reduce(false) { (result, childRegion) in
                result || childRegion.filter(on: searchText)
            }
        }
        return false
    }
}

public extension Array where Element == RegionJson {
    func filter(searchString: String) -> [RegionJson] {
        if searchString.isEmpty { return self }
        return flatMap { region in
            region.filter(searchString: searchString)
        }
    }
}
