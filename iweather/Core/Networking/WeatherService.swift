import Foundation

/// Custom network errors for weather API calls.
enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case decodingError(Error)
    case serverError(statusCode: Int)
    case noResultsFound
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid API endpoint URL."
        case .invalidResponse:
            return "Invalid server response."
        case .decodingError(let err):
            return "Failed to decode data: \(err.localizedDescription)"
        case .serverError(let code):
            return "Server error (\(code)). Please try again later."
        case .noResultsFound:
            return "No location results found for search query."
        }
    }
}

/// Protocol defining weather network service capabilities.
protocol WeatherServiceProtocol {
    func searchLocations(query: String) async throws -> [WeatherLocation]
    func fetchWeather(for location: WeatherLocation) async throws -> Weather
}

/// Live implementation of WeatherServiceProtocol using URLSession and async/await.
final class URLSessionWeatherService: WeatherServiceProtocol {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    // MARK: - Search Locations (Geocoding API)
    func searchLocations(query: String) async throws -> [WeatherLocation] {
        guard let url = WeatherAPIEndpoint.geocoding(city: query).url else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await session.data(from: url)
        try validateResponse(response)
        
        do {
            let dto = try JSONDecoder().decode(GeocodingResponseDTO.self, from: data)
            guard let results = dto.results, !results.isEmpty else {
                return []
            }
            
            return results.map { item in
                WeatherLocation(
                    city: item.name,
                    country: item.country ?? "",
                    latitude: item.latitude,
                    longitude: item.longitude
                )
            }
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
    
    // MARK: - Fetch Forecast (Forecast API)
    func fetchWeather(for location: WeatherLocation) async throws -> Weather {
        guard let url = WeatherAPIEndpoint.forecast(latitude: location.latitude, longitude: location.longitude).url else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await session.data(from: url)
        try validateResponse(response)
        
        do {
            let dto = try JSONDecoder().decode(OpenMeteoForecastDTO.self, from: data)
            return WeatherMapper.map(dto: dto, location: location)
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
    
    // MARK: - Helper Response Validator
    private func validateResponse(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
        }
    }
}
