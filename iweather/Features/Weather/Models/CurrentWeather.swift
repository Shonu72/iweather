import Foundation

/// Domain model representing current weather conditions and metrics.
struct CurrentWeather: Codable, Equatable {
    let temperature: Int        // Base temperature in Celsius
    let feelsLike: Int          // Perceived temperature in Celsius
    let highTemperature: Int    // High temperature in Celsius
    let lowTemperature: Int     // Low temperature in Celsius
    let condition: WeatherCondition
    let humidity: Int           // Relative humidity percentage (0-100)
    let windSpeed: Double       // Wind speed in km/h
    let pressure: Int           // Atmospheric pressure in hPa
    let uvIndex: Int            // UV Index rating
    let visibility: Double      // Visibility distance in km
}
