//struct WineRegionLib {
//    var text = "Hello, World!"
//}

import Combine
import MapKit

public protocol AppelationDescribable: CustomStringConvertible {
    var url: URL { get }
}

public protocol MapKitOverlayable {}

@available(iOS 13.0, *)
extension MKGeoJSONFeature: MapKitOverlayable {}

extension MKPolygon: MapKitOverlayable {}
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

public enum RegionResult {
    case regions([MapKitOverlayable])
    case loading(Float)
    case none
}

@available(iOS 13.0, *)
public class WineRegion: ObservableObject {
    @Published public var regionMaps: RegionResult = .none

    let session = URLSession(configuration: .default)

    var networkCancellable: AnyCancellable? = nil
    let decoder = MKGeoJSONDecoder()

    public init() {}

    private func handleResponseObject(response: HTTPURLResponse) {
        switch response.statusCode {
        case 200...299:
            break // No problem
        case 300...399:
            break // Not much of a problem
        case 400...499:
            debugPrint(response.statusCode) // My problem
        case 500...599:
            debugPrint(response.statusCode) // Server problem
        default:
            debugPrint("unknown status code \(response.statusCode)")
        }
    }

    private func fetchFrom(urls: [URL]) {
        DispatchQueue.global(qos: .background).async {
            var datum = [Data]()
            let dispatchGroup = DispatchGroup()

            let increment: Float = 100.0 / (Float(urls.count) * 2.0)
            var currentLoadAmount: Float = 0.0
            self.regionMaps = .loading(currentLoadAmount)
            urls.map { url in
                URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
            }.forEach { request in
                dispatchGroup.enter()
                debugPrint("fetching \(request.url!)")
                let task = self.session.downloadTask(with: request) { [weak self] (temporaryFileLocation, response, error)  in
                    debugPrint("got \(request.url!)")

                    if let error = error {
                        debugPrint("An error occurred while downloading a geojson file \(error)")
                    }
                    if let response = response as? HTTPURLResponse {
                        self?.handleResponseObject(response: response)
                    }
                    guard let temporaryFileLocation = temporaryFileLocation else {
                        dispatchGroup.leave()
                        return
                    }
                    do {
                        currentLoadAmount += increment
                        self?.regionMaps = .loading(currentLoadAmount)
                        debugPrint(currentLoadAmount)
                        debugPrint("reading temp file")
                        let data = try Data(contentsOf: temporaryFileLocation)
                        debugPrint("✅ successfully read temp file")
                        guard let url = response?.url else {
                            debugPrint("🔴 failed to read temp file")
                            dispatchGroup.leave()
                            return
                        }
                        debugPrint("✅ set it \(url.absoluteString)")
                        datum.append(data)
                        currentLoadAmount += increment
                        self?.regionMaps = .loading(currentLoadAmount)
                        debugPrint(currentLoadAmount)
                        dispatchGroup.leave()
                    } catch {
                        debugPrint("🔴 to read temp file")
                        dispatchGroup.leave()
                    }
                }
                task.resume()
            }
            dispatchGroup.notify(queue: DispatchQueue.global()) {
                self.consolidate(datum: datum)
            }
        }
    }

    private func consolidate(datum: [Data]) {
        debugPrint("we got \(datum.count) urls worth of data")
        let decoder = MKGeoJSONDecoder()
        let newRegions = datum
            .map { theData -> [MKGeoJSONObject]? in
                do {
                    debugPrint("🕕 parsing")
                    let decoded = try decoder.decode(theData)
                    return decoded
                } catch {
                    debugPrint("🔴error decoding \(error)")
                    return nil
                }
            }
            .compactMap { $0 }
            .reduce([], +)
            .map { $0 as? MapKitOverlayable }
            .compactMap { $0 }
        debugPrint("new regions \(newRegions.count)")
        self.regionMaps = .regions(newRegions)

    }
    public func getRegions(regions: [AppelationDescribable]) {
        fetchFrom(urls: regions.map { $0.url })
    }
}
