import Foundation

/// URL builder for Open-Meteo REST API endpoints.
enum WeatherAPIEndpoint {
    case geocoding(city: String)
    case forecast(latitude: Double, longitude: Double)
    
    var url: URL? {
        var components = URLComponents()
        
        switch self {
        case .geocoding(let city):
            components.scheme = "https"
            components.host = "geocoding-api.open-meteo.com"
            components.path = "/v1/search"
            components.queryItems = [
                URLQueryItem(name: "name", value: city),
                URLQueryItem(name: "count", value: "10"),
                URLQueryItem(name: "language", value: "en"),
                URLQueryItem(name: "format", value: "json")
            ]
            
        case .forecast(let latitude, let longitude):
            components.scheme = "https"
            components.host = "api.open-meteo.com"
            components.path = "/v1/forecast"
            components.queryItems = [
                URLQueryItem(name: "latitude", value: "\(latitude)"),
                URLQueryItem(name: "longitude", value: "\(longitude)"),
                URLQueryItem(name: "current", value: "temperature_2m,relative_humidity_2m,apparent_temperature,weather_code,surface_pressure,wind_speed_10m,uv_index"),
                URLQueryItem(name: "hourly", value: "temperature_2m,weather_code"),
                URLQueryItem(name: "daily", value: "weather_code,temperature_2m_max,temperature_2m_min"),
                URLQueryItem(name: "timezone", value: "auto")
            ]
        }
        
        return components.url
    }
}
