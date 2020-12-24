//struct WineRegionLib {
//    var text = "Hello, World!"
//}

import Combine
import MapKit

public protocol AppelationDescribable: CustomStringConvertible {
    var url: URL { get }
    var description: String { get }
}

public protocol MapKitOverlayable {}

@available(iOS 13.0, *)
extension MKGeoJSONFeature: MapKitOverlayable {}

extension MKPolygon: MapKitOverlayable {}

@available(iOS 13.0, *)
extension MKMultiPolygon: MapKitOverlayable {}

public enum RegionResult<T> {
    case regions([T])
    case loading(Float)
    case none
}

@available(iOS 13.0, *)
public class WineRegion: ObservableObject {
    @Published public var regionMaps: RegionResult<MapKitOverlayable> = .none
    @Published public var regionsTree: RegionResult<RegionJson> = .none

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
            debugPrint("\(response.statusCode) on \(response.url?.debugDescription ?? "no url")") // My problem
        case 500...599:
            debugPrint(response.statusCode) // Server problem
        default:
            debugPrint("unknown status code \(response.statusCode)")
        }
    }

    private func fetchFrom(urls: [URL]) {
        var datum = [URL: Data]()
        let dispatchGroup = DispatchGroup()

        let progressIncrement: Float = 1 / (Float(urls.count) * 2.0)
        var currentProgress: Float = 0.0
        self.regionMaps = .loading(currentProgress)
        DispatchQueue.global(qos: .utility).async {
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
                        self?.update(result: RegionResult<MapKitOverlayable>.loading(currentProgress))
                        let data = try Data(contentsOf: temporaryFileLocation)
                        guard let _ = response?.url else {
                            debugPrint("🔴 failed to read temp file")
                            dispatchGroup.leave()
                            return
                        }
                        datum[response!.url!] = data
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

    private func consolidate(datum: [URL: Data]) {
        debugPrint("we got \(datum.count) urls worth of data")

        // At this point we are done with the fetch, the other half is the parse
        // So we set the load progress amount to 50% and increment every time we get new content
        var currentLoadAmount: Float = 0.5
        let increment: Float = 1 / (Float(datum.count) * 2.0)

        let decoder = MKGeoJSONDecoder()
        let newRegions = datum
            .map { theData -> [MKGeoJSONObject]? in
                do {
                    let decoded = try decoder.decode(theData.value)
                    currentLoadAmount += increment
                    self.update(result: RegionResult<MapKitOverlayable>.loading(currentLoadAmount))
                    return decoded
                } catch {
                    debugPrint("🔴error decoding \(error) on \(theData.key)")
                    return nil
                }
            }
            .compactMap { $0 }
            .reduce([], +)
            .map { $0 as? MapKitOverlayable }
            .compactMap { $0 }
        debugPrint("new regions \(newRegions.count)")
        update(result: RegionResult<MapKitOverlayable>.regions(newRegions))
    }

    private func update(result: RegionResult<MapKitOverlayable>) {
        DispatchQueue.main.async {
            self.regionMaps = result
        }
    }

    public func loadMap(for region: RegionJson) {
        guard let urlString = region.url, let url = URL(string: urlString) else {
            print("not a valid url \(region.url)")
            return
        }
        fetchFrom(urls: [url])
    }

    public func getRegions(regions: [AppelationDescribable]) {
        fetchFrom(urls: regions.map { $0.url })
    }

    public func getRegionTree() throws {
        let decoder = JSONDecoder()

        regionsTree = .loading(0)
        // find file named "newCalifornia"
        print("california")
        let californiaURL = URL(fileURLWithPath: "/Users/roderic/dev/rodericj/WineRegionLib/Scripts/newCalifornia.json")
        let californiaData = try Data(contentsOf: californiaURL)
        let californiaRegion = try decoder.decode(RegionJson.self, from: californiaData)
        regionsTree = .loading(0.5)

        print("Italy")
        // find file named "newItaly"
        let italyURL = URL(fileURLWithPath: "/Users/roderic/dev/rodericj/WineRegionLib/Scripts/newItaly.json")
        let italyData = try Data(contentsOf: italyURL)
        let italyRegion = try decoder.decode(RegionJson.self, from: italyData)
        regionsTree = .regions([italyRegion, californiaRegion])
    }
}

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

}
