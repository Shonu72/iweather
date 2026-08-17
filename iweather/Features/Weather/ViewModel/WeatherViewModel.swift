import Foundation
import Observation

/// ViewModel for managing weather UI state and city selection.
@Observable
final class WeatherViewModel {
    var weatherData: WeatherData
    var availableCities: [String] = ["Bhopal", "Mumbai", "Delhi", "Bengaluru", "London", "Tokyo"]
    
    init(weatherData: WeatherData = WeatherViewModel.mockData) {
        self.weatherData = weatherData
    }
    
    /// Action method to switch active city weather data dynamically.
    func selectCity(_ cityName: String) {
        self.weatherData = WeatherViewModel.mockData(for: cityName)
    }
    
    /// Convenience static mock data for default city ("Bhopal").
    static var mockData: WeatherData {
        mockData(for: "Bhopal")
    }
    
    /// Generates mock data customized for a given city.
    static func mockData(for city: String) -> WeatherData {
        let cityTemps: [String: (current: Int, condition: String, icon: String, high: Int, low: Int)] = [
            "Bhopal": (29, "Sunny", "sun.max.fill", 32, 24),
            "Mumbai": (33, "Humid & Sunny", "sun.max.fill", 35, 27),
            "Delhi": (36, "Hazy Sunshine", "sun.haze.fill", 39, 29),
            "Bengaluru": (24, "Partly Cloudy", "cloud.sun.fill", 27, 19),
            "London": (18, "Light Rain", "cloud.rain.fill", 20, 14),
            "Tokyo": (26, "Clear Skies", "sun.max.fill", 28, 20)
        ]
        
        let info = cityTemps[city] ?? (25, "Partly Cloudy", "cloud.sun.fill", 28, 20)
        
        return WeatherData(
            cityName: city,
            currentTemperature: info.current,
            condition: info.condition,
            highTemperature: info.high,
            lowTemperature: info.low,
            hourlyForecasts: [
                HourlyForecast(time: "12 PM", systemIconName: info.icon, temperature: info.current),
                HourlyForecast(time: "1 PM", systemIconName: info.icon, temperature: info.current + 1),
                HourlyForecast(time: "2 PM", systemIconName: "cloud.sun.fill", temperature: info.current + 2),
                HourlyForecast(time: "3 PM", systemIconName: "cloud.rain.fill", temperature: info.current),
                HourlyForecast(time: "4 PM", systemIconName: "cloud.bolt.rain.fill", temperature: info.current - 2),
                HourlyForecast(time: "5 PM", systemIconName: "cloud.sun.fill", temperature: info.current - 1)
            ],
            dailyForecasts: [
                DailyForecast(day: "Mon", systemIconName: info.icon, highTemperature: info.high, lowTemperature: info.low),
                DailyForecast(day: "Tue", systemIconName: "cloud.sun.fill", highTemperature: info.high + 1, lowTemperature: info.low + 1),
                DailyForecast(day: "Wed", systemIconName: "cloud.rain.fill", highTemperature: info.high - 2, lowTemperature: info.low - 1),
                DailyForecast(day: "Thu", systemIconName: "sun.max.fill", highTemperature: info.high + 2, lowTemperature: info.low),
                DailyForecast(day: "Fri", systemIconName: "cloud.sun.fill", highTemperature: info.high, lowTemperature: info.low - 2),
                DailyForecast(day: "Sat", systemIconName: "cloud.heavyrain.fill", highTemperature: info.high - 3, lowTemperature: info.low - 3),
                DailyForecast(day: "Sun", systemIconName: "sun.max.fill", highTemperature: info.high - 1, lowTemperature: info.low - 2)
            ],
            details: [
                WeatherDetailItem(title: "HUMIDITY", value: "68%", systemIconName: "humidity", description: "Dew point is 21° right now."),
                WeatherDetailItem(title: "WIND", value: "12 km/h", systemIconName: "wind", description: "NW winds with gusts up to 18 km/h."),
                WeatherDetailItem(title: "UV INDEX", value: "6 Mod", systemIconName: "sun.max", description: "Moderate risk of harm from sun exposure."),
                WeatherDetailItem(title: "AIR QUALITY", value: "42 - Good", systemIconName: "aqi.low", description: "Air quality is satisfactory.")
            ]
        )
    }
}
