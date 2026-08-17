import Foundation

/// Temperature scale units (°C vs °F).
enum TemperatureUnit: String, CaseIterable, Identifiable {
    case celsius = "°C"
    case fahrenheit = "°F"
    
    var id: String { rawValue }
    
    /// Converts a base Celsius temperature value into a display string for this unit.
    func formatted(_ celsiusTemp: Int) -> String {
        switch self {
        case .celsius:
            return "\(celsiusTemp)°"
        case .fahrenheit:
            let f = Int(Double(celsiusTemp) * 9.0 / 5.0 + 32.0)
            return "\(f)°"
        }
    }
}

/// Model representing a single hour's forecast item.
struct HourlyForecast: Identifiable {
    let id = UUID()
    let time: String          // e.g. "12 PM"
    let systemIconName: String // SF Symbol name e.g. "sun.max.fill"
    let temperature: Int      // Base temperature in Celsius
}

/// Model representing a single day's forecast item.
struct DailyForecast: Identifiable {
    let id = UUID()
    let day: String           // e.g. "Mon"
    let systemIconName: String // SF Symbol name e.g. "sun.max.fill"
    let highTemperature: Int  // Base temp in Celsius
    let lowTemperature: Int   // Base temp in Celsius
}

/// Model representing detailed weather metrics (Humidity, Wind, UV, etc.).
struct WeatherDetailItem: Identifiable {
    let id = UUID()
    let title: String
    let value: String
    let systemIconName: String
    let description: String
}

/// Aggregate model for the current location's weather display.
struct WeatherData {
    let cityName: String
    let currentTemperature: Int // Base temp in Celsius
    let condition: String
    let highTemperature: Int
    let lowTemperature: Int
    let hourlyForecasts: [HourlyForecast]
    let dailyForecasts: [DailyForecast]
    let details: [WeatherDetailItem]
}
