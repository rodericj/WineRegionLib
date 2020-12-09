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
    let session = URLSession(configuration: .default)

    public init() {}
    private func fetchFrom(urls: [URL], keys: [String]) {
        DispatchQueue.global(qos: .background).async {

            let jsonDecoder = JSONDecoder()
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            let decoder = MKGeoJSONDecoder()

            urls.map { url in
                URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
            }.forEach { request in
                let task = self.session.downloadTask(with: request) { [weak self] (temporaryFileLocation, response, error)  in
                    if let error = error {
                        debugPrint("An error occurred while downloading a geojson file \(error)")
                    }
                    if let response = response as? HTTPURLResponse {
                        switch response.statusCode {
                        case 200...299:
                            break // No problem
                        case 300...399:
                            break // Not much of a problem
                        case 400...499:
                            print(response.statusCode) // My problem
                        case 500...599:
                            print(response.statusCode) // Server problem
                        default:
                            debugPrint("unknown status code \(response.statusCode)")
                        }

                    }
                    guard let temporaryFileLocation = temporaryFileLocation else {
                        return
                    }
                    print(temporaryFileLocation)
                    do {
                        let data = try Data(contentsOf: temporaryFileLocation)
                        let objects = try decoder.decode(data)

                        // split here
                        if let polygons = objects as? [MKPolygon] {
                            self?.regionPolygons = Dictionary(uniqueKeysWithValues: zip(keys, polygons))
                        }
                        if let mkGeoJSONObjects = objects as? [MKGeoJSONFeature] {
                            self?.regionMaps = Dictionary(uniqueKeysWithValues: zip(keys, mkGeoJSONObjects))
                        }
                    }
                    catch {
                        print("error decoding or getting file \(error)")
                    }

                }
                task.resume()
            }
        }
    }
    public func getRegions(regions: [AppelationDescribable]) {
        fetchFrom(urls: regions.map { $0.url }, keys: regions.allKeys)
    }
}
