//
//  RegionJson.swift
//  
//
//  Created by Roderic Campbell on 1/1/21.
//

import Foundation

public struct RegionJson: Decodable, Identifiable, Equatable {
    public let id: UUID
    public let title: String
    public let osmID: Int
    public let children: [RegionJson]?

    private enum CodingKeys: String, CodingKey {
        case title
        case url
        case children
        case id
        case osmID
    }

    public init(from decoder:Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let theseChildren = try container.decodeIfPresent([RegionJson]?.self, forKey: .children)
            self.children = theseChildren??.sorted { $0.title < $1.title }
            
            title = try container.decode(String.self, forKey: .title)
            id = try container.decode(UUID.self, forKey: .id)
            osmID = try container.decode(Int.self, forKey: .osmID)
        } catch {
            print(error)
            throw error
        }
    }
}

public extension RegionJson {
    func filter(searchString: String) -> [RegionJson] {
        guard let children = children else {
            if title.uppercased().contains(searchString.uppercased()) {
                return [self]
            } else {
                return []
            }
        }
        if children.isEmpty {
            if title.uppercased().contains(searchString.uppercased()) {
                return [self]
            } else {
                return []
            }
        }
        var ret: [RegionJson] = []
        if title.uppercased().contains(searchString.uppercased()) {
            ret.append(self)
        }
        children.forEach { region in
            ret.append(contentsOf: region.filter(searchString: searchString))
        }
        return ret
    }
}
