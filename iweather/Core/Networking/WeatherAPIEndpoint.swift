import Foundation

/// Reference helper for Weather API endpoints (see APIRequest in Core/Networking for generic request pipeline).
enum WeatherAPIEndpoint {
    case geocoding(city: String)
    case forecast(latitude: Double, longitude: Double)
    
    var request: any APIRequest {
        switch self {
        case .geocoding(let city):
            return GeocodingRequest(cityName: city)
        case .forecast(let latitude, let longitude):
            return ForecastRequest(latitude: latitude, longitude: longitude)
        }
    }
}
