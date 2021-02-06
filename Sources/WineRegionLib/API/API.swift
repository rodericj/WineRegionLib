import Combine
import Foundation

enum Endpoint {
    public static let host: String = {
        guard let host = ProcessInfo.processInfo.environment["REGION_SERVICE_HOST"] else {
            fatalError("Please set REGION_SERVICE_HOST environment variable")
        }
        return host
    }()

    case createRegion(String)
    case region
    case regionJson(UUID)
    case specificRegion(UUID)
    case addChildToParent(UUID, UUID)
    
    var url: URL {
        switch self {
        case .region:
            return URL(string: "\(Endpoint.host)/region")!
        case .regionJson(let regionUUID):
            return URL(string: "\(Endpoint.host)/region/\(regionUUID.uuidString)/geojson")! // TODO I should change this to UUID.geojson
        case .specificRegion(let regionUUID):
            return URL(string: "\(Endpoint.host)/region/\(regionUUID.uuidString)")!
        case .addChildToParent(let childUUD, let parentUUID):
            return URL(string: "\(Endpoint.host)/region/\(childUUD.uuidString)?parent_id=\(parentUUID.uuidString)")!
        case .createRegion(let osmID):
            var components = URLComponents(url: URL(string: "\(Endpoint.host)/region")!, resolvingAgainstBaseURL: false)
            components?.queryItems = [URLQueryItem(name: "osmid", value: osmID)]
            return components!.url!

        }
    }
}

extension URLSession {
    func publisher<T: Decodable>(
        with method: ModelLoader<T>.Method,
        for url: URL,
        responseType: T.Type = T.self,
        decoder: JSONDecoder = .init()
    ) -> AnyPublisher<T, Error> {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        return dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: NetworkResponse<T>.self, decoder: decoder)
            .map(\.result)
            .eraseToAnyPublisher()
    }
}

struct NetworkResponse<Wrapped: Decodable>: Decodable {
    var result: Wrapped
}

enum LoaderError: Error {
    case invalidURL
}


struct ModelLoader<Model: Identifiable & Decodable> {
    enum Method: String {
        case post = "POST"
        case get = "GET"
        case patch = "PATCH"
    }
    var urlSession = URLSession.shared

    func loadModel(_ method: Method, url: URL) -> AnyPublisher<Model, Error> {
        urlSession.publisher(with: method, for: url)
    }
}
