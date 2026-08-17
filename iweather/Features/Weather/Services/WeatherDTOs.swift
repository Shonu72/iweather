import Foundation

// MARK: - Geocoding DTOs
struct GeocodingResponseDTO: Codable {
    let results: [GeocodingItemDTO]?
}

struct GeocodingItemDTO: Codable, Identifiable {
    let id: Int
    let name: String
    let country: String?
    let latitude: Double
    let longitude: Double
}

// MARK: - Forecast DTOs
struct OpenMeteoForecastDTO: Codable {
    let latitude: Double
    let longitude: Double
    let current: CurrentWeatherDTO
    let hourly: HourlyForecastDTO
    let daily: DailyForecastDTO
}

struct CurrentWeatherDTO: Codable {
    let temperature_2m: Double
    let relative_humidity_2m: Int
    let apparent_temperature: Double
    let weather_code: Int
    let surface_pressure: Double
    let wind_speed_10m: Double
    let uv_index: Double?
}

struct HourlyForecastDTO: Codable {
    let time: [String]
    let temperature_2m: [Double]
    let weather_code: [Int]
}

struct DailyForecastDTO: Codable {
    let time: [String]
    let weather_code: [Int]
    let temperature_2m_max: [Double]
    let temperature_2m_min: [Double]
}

// MARK: - WMO Weather Code Converter
extension Int {
    /// Converts World Meteorological Organization (WMO) code to WeatherCondition enum.
    var asWeatherCondition: WeatherCondition {
        switch self {
        case 0:
            return .sunny
        case 1, 2:
            return .partlyCloudy
        case 3:
            return .cloudy
        case 45, 48:
            return .haze
        case 51, 53, 55, 61, 63, 80:
            return .lightRain
        case 65, 81, 82:
            return .heavyRain
        case 95, 96, 99:
            return .thunderstorm
        default:
            return .partlyCloudy
        }
    }
}
