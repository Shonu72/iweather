import Foundation

/// HTTP methods supported by network requests.
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

/// Generic protocol defining an API request and its expected Decodable response type.
protocol APIRequest {
    associatedtype Response: Decodable
    
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var queryItems: [URLQueryItem]? { get }
    var headers: [String: String]? { get }
}

extension APIRequest {
    var scheme: String { "https" }
    var method: HTTPMethod { .get }
    var headers: [String: String]? { nil }
    
    /// Constructs target URL from request components.
    var url: URL? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        components.queryItems = queryItems
        return components.url
    }
}
