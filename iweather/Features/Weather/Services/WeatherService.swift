import Foundation

// MARK: - Open-Meteo API Requests

struct GeocodingRequest: APIRequest {
    typealias Response = GeocodingResponseDTO
    
    let host = AppConfig.geocodingAPIBaseURL
    let path = "/v1/search"
    let queryItems: [URLQueryItem]?
    
    init(cityName: String) {
        self.queryItems = [
            URLQueryItem(name: "name", value: cityName),
            URLQueryItem(name: "count", value: "10"),
            URLQueryItem(name: "language", value: "en"),
            URLQueryItem(name: "format", value: "json")
        ]
    }
}

struct ForecastRequest: APIRequest {
    typealias Response = OpenMeteoForecastDTO
    
    let host = AppConfig.weatherAPIBaseURL
    let path = "/v1/forecast"
    let queryItems: [URLQueryItem]?
    
    init(latitude: Double, longitude: Double) {
        self.queryItems = [
            URLQueryItem(name: "latitude", value: "\(latitude)"),
            URLQueryItem(name: "longitude", value: "\(longitude)"),
            URLQueryItem(name: "current", value: "temperature_2m,relative_humidity_2m,apparent_temperature,weather_code,surface_pressure,wind_speed_10m,uv_index"),
            URLQueryItem(name: "hourly", value: "temperature_2m,weather_code"),
            URLQueryItem(name: "daily", value: "weather_code,temperature_2m_max,temperature_2m_min"),
            URLQueryItem(name: "timezone", value: "auto")
        ]
    }
}

// MARK: - Weather Service Interface & Offline-First Implementation

protocol WeatherServiceProtocol {
    func searchLocations(query: String) async throws -> [WeatherLocation]
    func fetchWeather(for location: WeatherLocation) async throws -> Weather
}

final class WeatherService: WeatherServiceProtocol {
    private let client: NetworkClientProtocol
    private let cacheManager: WeatherCacheManagerProtocol
    
    init(
        client: NetworkClientProtocol = URLSessionNetworkClient(),
        cacheManager: WeatherCacheManagerProtocol = WeatherCacheManager()
    ) {
        self.client = client
        self.cacheManager = cacheManager
    }
    
    func searchLocations(query: String) async throws -> [WeatherLocation] {
        let request = GeocodingRequest(cityName: query)
        let dto = try await client.execute(request)
        
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
    }
    
    func fetchWeather(for location: WeatherLocation) async throws -> Weather {
        let locationKey = "\(location.city.lowercased())_\(location.country.lowercased())"
        let request = ForecastRequest(latitude: location.latitude, longitude: location.longitude)
        
        do {
            let dto = try await client.execute(request)
            var liveWeather = WeatherMapper.map(dto: dto, location: location)
            liveWeather.isFromCache = false
            
            // Persist live payload to disk cache
            cacheManager.saveWeatherToCache(liveWeather, for: locationKey)
            
            return liveWeather
        } catch {
            // API call failed (offline / network error) -> fall back to disk cache!
            if let cachedWeather = cacheManager.getCachedWeather(for: locationKey) {
                return cachedWeather
            }
            throw error
        }
    }
}
