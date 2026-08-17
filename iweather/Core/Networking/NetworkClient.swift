import Foundation

/// Protocol defining generic network execution capability.
protocol NetworkClientProtocol {
    func execute<R: APIRequest>(_ request: R) async throws -> R.Response
}

/// Generic URLSession network client executing APIRequests and decoding JSON responses.
final class URLSessionNetworkClient: NetworkClientProtocol {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func execute<R: APIRequest>(_ request: R) async throws -> R.Response {
        guard let url = request.url else {
            throw NetworkError.invalidURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        request.headers?.forEach { key, value in
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }
        
        let (data, response) = try await session.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
        }
        
        do {
            return try JSONDecoder().decode(R.Response.self, from: data)
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
}
