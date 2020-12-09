//struct WineRegionLib {
//    var text = "Hello, World!"
//}

import Combine
import MapKit

public protocol AppelationDescribable: CustomStringConvertible {
    var url: URL { get }
}

extension Array where Element == AppelationDescribable {
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

struct OpenStreetMapFormat: Codable {
    let name: String
    let type: String
    let boundary: String
}

@available(iOS 13.0, *)
public class WineRegion: ObservableObject {
    @Published public var regionMaps: [String: MKGeoJSONFeature] = [:]
    @Published public var regionPolygons: [String: MKPolygon] = [:]

    public init() {}
    private func fetchFrom(urls: [URL], keys: [String]) {
        DispatchQueue.global(qos: .background).async {

            let jsonDecoder = JSONDecoder()
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            let decoder = MKGeoJSONDecoder()

            // Some geojson files have MKPolygons (Italy), while others have MKGeoJSONFeatures

            // Extract the MKPolygon from a given geojson file
            let mkPolygonFeatures = urls.map { try? Data(contentsOf: $0) }
                .compactMap { $0 }
                .map { data in
                    try? decoder.decode(data)
                }.compactMap { $0 }
                .map { mkGeoJSONObjects -> [MKPolygon] in
                    mkGeoJSONObjects
                        .map { $0 as? MKPolygon }
                        .compactMap { $0 }
                    // OK so all of itally is just a polygon
                }.reduce([], +)

            self.regionPolygons = Dictionary(uniqueKeysWithValues: zip(keys, mkPolygonFeatures))

            // Extract the given MKGeoJSONFeatures from a geojson file
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
                        // TODO generalize/parameterize this decoding logic
                        do {
                            let davisData = try jsonDecoder.decode(DavisAVAData.self, from: props)
                            return keys.contains(davisData.avaId)
                        } catch {
                            print("This is not a Davis data file. Probably OK", error)
                        }

                        do {
                            let customWineRegionData = try jsonDecoder.decode(CustomWineRegionFormat.self, from: props)
                            return keys.contains(customWineRegionData.name)
                        } catch {
                            print("This is not a Custom Wine region data file. Probably OK", error)
                        }

                        do {
                            let osmData = try jsonDecoder.decode(OpenStreetMapFormat.self, from: props)
                            return keys.contains(osmData.name)
                        } catch {
                            print("This is not a Custom Wine region data file. Probably OK", error)
                        }
                    }
                    return false
                }
            print("the keys are \(keys)")
            self.regionMaps = Dictionary(uniqueKeysWithValues: zip(keys, features))
        }
        print("We will show", regionMaps.keys)
    }
    public func getRegionsStruct(regions: [AppelationDescribable]) {
        fetchFrom(urls: regions.map { $0.url }, keys: regions.allKeys)
    }
    public func getRegions(regions: [WineRegionDescribable]) {
        fetchFrom(urls: regions.map { $0.url }, keys: regions.allKeys)
    }
}
