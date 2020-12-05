//struct WineRegionLib {
//    var text = "Hello, World!"
//}

import Combine
import MapKit

public protocol WineRegionDescribable: CustomStringConvertible {
    var url: URL { get }
}

public protocol AppelationDescribable: CustomStringConvertible {
    var url: URL { get }
}

public enum CaliforniaSubRegion: String, WineRegionDescribable, Hashable, Equatable, CaseIterable {
    public var url: URL {
        return URL(string: "https://github.com/rodericj/ava/raw/master/avas_by_state/CA_avas.geojson")!
    }

    public var description: String {
        switch self {

        case .napa:
            return "napa_valley"
        case .santaCruz:
            return "santa_cruz_mountains"
        case .centralCoast:
            return "central_coast"
        case .saintHelena:
            return "saint__helena"
        }
    }

    case napa
    case santaCruz
    case centralCoast
    case saintHelena

    public static func == (lhs: CaliforniaSubRegion, rhs: CaliforniaSubRegion) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}

public enum USState: WineRegionDescribable, Hashable, Equatable {
    case california(CaliforniaSubRegion)
    case oregon
    case washington

    public var url: URL {
        switch self {
        case .california(let region):
            return region.url
        case .oregon:
            return URL(string: "https://github.com/rodericj/ava/raw/master/avas_by_state/OR_avas.geojson")!
        case .washington:
            return URL(string: "https://github.com/rodericj/ava/raw/master/avas_by_state/WA_avas.geojson")!
        }
    }
    public var description: String {
        switch self {
        case .california(let sub):
            return sub.description
        case .oregon:
            return "oregon"
        case .washington:
            return "washington"
        }
    }
    public static func == (lhs: USState, rhs: USState) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}

public struct WineCountry {
    public struct USA {
        public static let title = "USA"
        public struct California {
            public static let title = "California"
            public enum Appelation: String, AppelationDescribable {
                public var description: String {
                    switch self {
                    case .napa:
                        return "napa_valley"
//                    case .santaCruz:
//                        return "santa_cruz_mountains"
                    case .centralCoast:
                        return "central_coast"
//                    case .saintHelena:
//                        return "saint__helena"
                    case .mendocinoCounty:
                        return "mendocino"
                    }
                }


                public var url: URL {
                    return URL(string: "https://github.com/rodericj/ava/raw/master/avas_by_state/CA_avas.geojson")!
                }
                case mendocinoCounty = "Mendocino County"
                case napa
                case centralCoast
            }
        }
    }
}

public enum FrenchRegion: WineRegionDescribable, Hashable, Equatable {
    public var description: String {
        switch self {

        case .bordeaux(let subRegion):
            return subRegion.description
        }
    }

    case bordeaux(BordeauxSubRegion)

    public var url: URL {
        switch self {
        case .bordeaux(let subRegion):
            return subRegion.url
        }
    }

    public static func == (lhs: FrenchRegion, rhs: FrenchRegion) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}

public enum DOGC: String, WineRegionDescribable, Hashable, Equatable, CustomStringConvertible {
    public var url: URL {
        URL(string: "Not quite defined yet")!
    }

    public var description: String {
        switch self {

        case .chianti:
            return "chianti"
        case .monticello:
            return "monticello"
        case .sicily:
            return "sicily"
        }
    }

    public static func == (lhs: DOGC, rhs: DOGC) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    case chianti
    case monticello
    case sicily
}

public enum WineLocale: Hashable, Equatable, WineRegionDescribable {
    case unitedStates(USState)
    case france(FrenchRegion)
//    case italy(DOGC)

    public var url: URL {
        switch self {

        case .unitedStates(let state):
            return state.url
        case .france(let region):
            return region.url
        }
    }
    public var description: String {
        switch self {
        case .unitedStates(let state):
            return state.description
        case .france(let aoc):
            return aoc.description
        }
    }
}

extension Array where Element == AppelationDescribable {
    var allKeys: [String] {
        map { locale in
            locale.description
        }
    }
}

extension Array where Element == WineRegionDescribable {
    var allKeys: [String] {
        map { locale in
            locale.description
        }
    }
}

struct DavisAVAData: Codable {
    let state: String
    let avaId: String
    let contains: String
    let cfrIndex: String
    let cfrRevisionHistory: String
    let approvedMaps: String
    let boundaryDescription: String
    let usedMaps: String
}

struct CustomWineRegionFormat: Codable {
    let name: String
    let department: String
    let appellation: String
}

@available(iOS 13.0, *)
public class WineRegion: ObservableObject {
    @Published public var regionMaps: [String: MKGeoJSONFeature] = [:]

    public init() {}
    private func fetchFrom(urls: [URL], keys: [String]) {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        let decoder = MKGeoJSONDecoder()
        let features = urls.map { try? Data(contentsOf: $0) }
        .compactMap { $0 }
        .map { data in
            try? decoder.decode(data)
        }.compactMap { $0 }
        .map { mkGeoJSONObjects in
            mkGeoJSONObjects
                .map { $0 as? MKGeoJSONFeature }
                .compactMap { $0 }
        }.reduce([], +)
        .filter { feature in
            if let props = feature.properties {
                do {
                    let davisData = try jsonDecoder.decode(DavisAVAData.self, from: props)
                    return keys.contains(davisData.avaId)
                } catch {
                    print("This is not a Davis data file. Probably OK", error)
                }

                do {
                    let rodericData = try jsonDecoder.decode(CustomWineRegionFormat.self, from: props)
                    return keys.contains(rodericData.name)
                } catch {
                    print("This is not a Custom Wine region data file. Probably OK", error)
                }
            }
            return false
        }
        regionMaps = Dictionary(uniqueKeysWithValues: zip(keys, features))
        print("We will show", regionMaps.keys)
    }
    public func getRegionsStruct(regions: [AppelationDescribable]) {
        fetchFrom(urls: regions.map { $0.url }, keys: regions.allKeys)
    }
    public func getRegions(regions: [WineRegionDescribable]) {
        fetchFrom(urls: regions.map { $0.url }, keys: regions.allKeys)
    }
}
