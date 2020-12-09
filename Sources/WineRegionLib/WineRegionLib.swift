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
    // TODO I believe these can be concolidated into [String: MKGeoJsonObject]
    @Published public var regionMaps: [String: MKGeoJSONFeature] = [:]
    @Published public var regionPolygons: [String: MKPolygon] = [:]
    @Published private(set) var networkOutputStream: (keys: [String], temporaryFileLocation: URL?, response: URLResponse?, error: Error?)  = ([], nil, nil, nil)

    let session = URLSession(configuration: .default)

    var networkCancellable: AnyCancellable? = nil

    // TODO determine if this is threadsafe
    let decoder = MKGeoJSONDecoder()

    public init() {}

    public func start() {

        networkCancellable = $networkOutputStream.sink { _ in } receiveValue: { (keys, tempURL, response, error) in
            if let error = error {
                debugPrint("An error occurred while downloading a geojson file \(error)")
            }
            if let response = response as? HTTPURLResponse {
                self.handleResponseObject(response: response)
            }
            guard let temporaryFileLocation = tempURL else {
                return
            }
            print(temporaryFileLocation)
            self.processDownloadedContent(temporaryFileLocation, keys: keys, with: self.decoder)
        }
    }

    private func handleResponseObject(response: HTTPURLResponse) {
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

    fileprivate func processDownloadedContent(_ temporaryFileLocation: URL, keys: [String], with decoder: MKGeoJSONDecoder) {
        do {
            let data = try Data(contentsOf: temporaryFileLocation)
            let objects = try decoder.decode(data)

            // split here
            if let polygons = objects as? [MKPolygon] {
                let newPolygons = Dictionary(uniqueKeysWithValues: zip(keys, polygons)).merging(regionPolygons) { (current, new) -> MKPolygon in
                    new
                }
                self.regionPolygons = newPolygons

            }
            if let mkGeoJSONObjects = objects as? [MKGeoJSONFeature] {
                let newRegions = Dictionary(uniqueKeysWithValues: zip(keys, mkGeoJSONObjects)).merging(regionMaps) { (current, new) -> MKGeoJSONFeature in
                    new
                }
                self.regionMaps = newRegions
            }
        }
        catch {
            print("error decoding or getting file \(error)")
        }
    }

    private func fetchFrom(urls: [URL], keys: [String]) {
        DispatchQueue.global(qos: .background).async {
            urls.map { url in
                URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
            }.forEach { request in
                let task = self.session.downloadTask(with: request) { [weak self] (temporaryFileLocation, response, error)  in
                    self?.networkOutputStream = (keys: keys, temporaryFileLocation: temporaryFileLocation, response: response, error: error)
                }
                task.resume()
            }
        }
    }
    public func getRegions(regions: [AppelationDescribable]) {
        fetchFrom(urls: regions.map { $0.url }, keys: regions.allKeys)
    }
}
