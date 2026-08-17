import Foundation

/// Strongly-typed weather condition categories with associated SF Symbols.
enum WeatherCondition: String, Codable, CaseIterable {
    case sunny = "Sunny"
    case clear = "Clear"
    case partlyCloudy = "Partly Cloudy"
    case cloudy = "Cloudy"
    case lightRain = "Light Rain"
    case heavyRain = "Heavy Rain"
    case thunderstorm = "Thunderstorm"
    case haze = "Haze"
    
    /// SF Symbol icon name corresponding to the condition.
    var systemIconName: String {
        switch self {
        case .sunny:
            return "sun.max.fill"
        case .clear:
            return "moon.stars.fill"
        case .partlyCloudy:
            return "cloud.sun.fill"
        case .cloudy:
            return "cloud.fill"
        case .lightRain:
            return "cloud.rain.fill"
        case .heavyRain:
            return "cloud.heavyrain.fill"
        case .thunderstorm:
            return "cloud.bolt.rain.fill"
        case .haze:
            return "sun.haze.fill"
        }
    }
}
