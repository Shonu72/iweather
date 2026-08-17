import Foundation

/// Domain model representing a single hourly forecast entry.
struct HourlyForecastItem: Identifiable, Codable, Equatable {
    let id: UUID
    let time: String          // e.g. "12 PM"
    let temperature: Int      // Base temp in Celsius
    let condition: WeatherCondition
    
    init(id: UUID = UUID(), time: String, temperature: Int, condition: WeatherCondition) {
        self.id = id
        self.time = time
        self.temperature = temperature
        self.condition = condition
    }
}

/// Domain model representing a single daily forecast entry.
struct DailyForecastItem: Identifiable, Codable, Equatable {
    let id: UUID
    let day: String           // e.g. "Mon"
    let highTemperature: Int  // Base temp in Celsius
    let lowTemperature: Int   // Base temp in Celsius
    let condition: WeatherCondition
    
    init(id: UUID = UUID(), day: String, highTemperature: Int, lowTemperature: Int, condition: WeatherCondition) {
        self.id = id
        self.day = day
        self.highTemperature = highTemperature
        self.lowTemperature = lowTemperature
        self.condition = condition
    }
}
