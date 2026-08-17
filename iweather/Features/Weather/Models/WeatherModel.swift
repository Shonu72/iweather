import Foundation

/// Model representing a single hour's forecast item.
struct HourlyForecast: Identifiable {
    let id = UUID()
    let time: String          // e.g. "12 PM"
    let systemIconName: String // SF Symbol name e.g. "sun.max.fill"
    let temperature: Int      // e.g. 29
}

/// Model representing a single day's forecast item.
struct DailyForecast: Identifiable {
    let id = UUID()
    let day: String           // e.g. "Mon"
    let systemIconName: String // SF Symbol name e.g. "sun.max.fill"
    let highTemperature: Int  // e.g. 30
    let lowTemperature: Int   // e.g. 24
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
    let currentTemperature: Int
    let condition: String
    let highTemperature: Int
    let lowTemperature: Int
    let hourlyForecasts: [HourlyForecast]
    let dailyForecasts: [DailyForecast]
    let details: [WeatherDetailItem]
}
