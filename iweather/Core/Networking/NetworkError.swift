import Foundation

/// Centralized network errors conforming to LocalizedError.
enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case decodingError(Error)
    case serverError(statusCode: Int)
    case noResultsFound
    case custom(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid API endpoint URL."
        case .invalidResponse:
            return "Invalid server response."
        case .decodingError(let err):
            return "Failed to decode server data: \(err.localizedDescription)"
        case .serverError(let code):
            return "Server error (\(code)). Please try again later."
        case .noResultsFound:
            return "No location results found for search query."
        case .custom(let message):
            return message
        }
    }
}
