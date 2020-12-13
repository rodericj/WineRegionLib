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

            let progressIncrement: Float = 1 / (Float(urls.count) * 2.0)
            var currentProgress: Float = 0.0
            self.regionMaps = .loading(currentProgress)
            urls.map { url in
                URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
            }.forEach { request in
                dispatchGroup.enter()
                let task = self.session.downloadTask(with: request) { [weak self] (temporaryFileLocation, response, error)  in
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
                        currentProgress += progressIncrement
                        self?.update(result: .loading(currentProgress))
                        let data = try Data(contentsOf: temporaryFileLocation)
                        guard let _ = response?.url else {
                            debugPrint("🔴 failed to read temp file")
                            dispatchGroup.leave()
                            return
                        }
                        datum.append(data)
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

        // At this point we are done with the fetch, the other half is the parse
        // So we set the load progress amount to 50% and increment every time we get new content
        var currentLoadAmount: Float = 0.5
        let increment: Float = 1 / (Float(datum.count) * 2.0)

        let decoder = MKGeoJSONDecoder()
        let newRegions = datum
            .map { theData -> [MKGeoJSONObject]? in
                do {
                    debugPrint("🕕 parsing")
                    let decoded = try decoder.decode(theData)
                    currentLoadAmount += increment
                    self.update(result: .loading(currentLoadAmount))
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
        update(result: .regions(newRegions))
    }

    private func update(result: RegionResult) {
        DispatchQueue.main.async {
            self.regionMaps = result
        }
    }
    public func getRegions(regions: [AppelationDescribable]) {
        fetchFrom(urls: regions.map { $0.url })
    }
}
