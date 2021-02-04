//struct WineRegionLib {
//    var text = "Hello, World!"
//}

import Combine
import MapKit


public protocol MapKitOverlayable {}

@available(iOS 13.0, *)
extension MKGeoJSONFeature: MapKitOverlayable {}

extension MKPolygon: MapKitOverlayable {}

@available(iOS 13.0, *)
extension MKMultiPolygon: MapKitOverlayable {}

public enum RegionResult<T> {
    case regions([T])
    case loading(Float)
    case error(Error, String?)
    case none
}

@available(iOS 13.0, *)
public class WineRegion: ObservableObject {
    
    private let regionLoader: ModelLoader = ModelLoader<RegionJson>()
    
//    private static let host = "http://tranquil-garden-84812.herokuapp.com"
//    private static let host = "http://localhost:3000"
//    private static let host = "https://thumbworksbot.ngrok.io"
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

    private func fetchFrom(regions: [RegionJson]) {
        var datum = [URL: Data]()
        let dispatchGroup = DispatchGroup()

        let progressIncrement: Float = 1 / (Float(regions.count) * 2.0)
        var currentProgress: Float = 0.0
        self.regionMaps = .loading(currentProgress)
        DispatchQueue.global(qos: .utility).async {
            regions.compactMap { region in
                URL(string: "\(Endpoint.host)/region/\(region.id)/geojson")
            }.map { url in
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

    // Push published events to the main queue
    private func update(result: RegionResult<MapKitOverlayable>) {
        DispatchQueue.main.async {
            self.regionMaps = result
        }
    }

    private func update(tree: RegionResult<RegionJson>) {
        DispatchQueue.main.async {
            self.regionsTree = tree
        }
    }
    
    private func postRegion(osmID: String, completionHandler: @escaping ((RegionJson?, Error?) -> Void))  {
        let urlString = "\(Endpoint.host)/region"
        guard let url = URL(string: urlString) else {
            return
        }
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = [URLQueryItem(name: "osmid", value: osmID)]

        guard let componentURL = components?.url else { return }
        var request = URLRequest(url: componentURL)
        request.httpMethod = "POST"
        print(componentURL)
        print(request)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("we got an error \(error)")
                completionHandler(nil, error)
            } else if let data = data {
                let decoder = JSONDecoder()
                do {
                    let newRegion = try decoder.decode(RegionJson.self, from: data)
                    print(newRegion)
                    completionHandler(newRegion, error)
                } catch {
                    do {
                        let allRegionsForSomeReason = try decoder.decode([RegionJson].self, from: data)
                        print(allRegionsForSomeReason)
                        completionHandler(nil, error)
                    } catch {
                        print(error)
                    }
                }
            }
        }
        task.resume()
    }
    
    var cancellables: [AnyCancellable] = []
    public func createRegion(osmID: String, asChildTo parent: RegionJson) /* -> AnyPublisher<RegionJson, Error> */{
        regionLoader
            // post the region
            .loadModel(.post, url: Endpoint.createRegion(osmID).url)
            .flatMap { region in
                // once we get the region, patch it to the appropriate parent
                return self.regionLoader.loadModel(.patch, url: Endpoint.addChildToParent(region.id, parent.id).url)
            }//.eraseToAnyPublisher()
            .sink { res in
                switch res {
                case .finished:
                    print("finished")
                case .failure(let error):
                    print("error patching or posting \(error)")
                }
            } receiveValue: { [weak self] regionJson in
                print("regionJson \(regionJson)")
                self?.getRegionTree()
            }.store(in: &cancellables)

    }
    
    public func loadMap(for region: RegionJson) {
        fetchFrom(regions: [region])
    }

    public func getRegionTree() {
        let decoder = JSONDecoder()
        DispatchQueue.global(qos: .utility).async {
            self.update(tree: .loading(0.1))

            guard let local = URL(string: "\(Endpoint.host)/region")
            else {
                fatalError()
            }

            do {
                let serverData = try Data(contentsOf: local)
                let children = try decoder.decode([RegionJson].self, from: serverData)
                self.update(tree: .regions(children))
                return
            } catch {
                self.update(tree: .error(error, "server"))
            }
        }
    }
}



