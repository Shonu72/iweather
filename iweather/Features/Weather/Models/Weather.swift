import Foundation

/// Root aggregate domain model for a city's complete weather snapshot.
struct Weather: Codable, Equatable {
    let location: WeatherLocation
    let current: CurrentWeather
    let hourly: [HourlyForecastItem]
    let daily: [DailyForecastItem]
}
