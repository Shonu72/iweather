import Foundation
import Observation

/// ViewModel for managing weather UI state.
@Observable
final class WeatherViewModel {
    var weatherData: WeatherData
    
    init(weatherData: WeatherData = WeatherViewModel.mockData) {
        self.weatherData = weatherData
    }
    
    /// Static mock data matching layout requirements.
    static var mockData: WeatherData {
        WeatherData(
            cityName: "Bhopal",
            currentTemperature: 29,
            condition: "Sunny",
            highTemperature: 32,
            lowTemperature: 24,
            hourlyForecasts: [
                HourlyForecast(time: "12 PM", systemIconName: "sun.max.fill", temperature: 29),
                HourlyForecast(time: "1 PM", systemIconName: "sun.max.fill", temperature: 30),
                HourlyForecast(time: "2 PM", systemIconName: "cloud.sun.fill", temperature: 31),
                HourlyForecast(time: "3 PM", systemIconName: "cloud.rain.fill", temperature: 29),
                HourlyForecast(time: "4 PM", systemIconName: "cloud.bolt.rain.fill", temperature: 27),
                HourlyForecast(time: "5 PM", systemIconName: "cloud.sun.fill", temperature: 28)
            ],
            dailyForecasts: [
                DailyForecast(day: "Mon", systemIconName: "sun.max.fill", highTemperature: 30, lowTemperature: 24),
                DailyForecast(day: "Tue", systemIconName: "cloud.sun.fill", highTemperature: 31, lowTemperature: 25),
                DailyForecast(day: "Wed", systemIconName: "cloud.rain.fill", highTemperature: 28, lowTemperature: 23),
                DailyForecast(day: "Thu", systemIconName: "sun.max.fill", highTemperature: 32, lowTemperature: 24),
                DailyForecast(day: "Fri", systemIconName: "cloud.sun.fill", highTemperature: 30, lowTemperature: 22),
                DailyForecast(day: "Sat", systemIconName: "cloud.heavyrain.fill", highTemperature: 27, lowTemperature: 21),
                DailyForecast(day: "Sun", systemIconName: "sun.max.fill", highTemperature: 29, lowTemperature: 22)
            ],
            details: [
                WeatherDetailItem(title: "HUMIDITY", value: "68%", systemIconName: "humidity", description: "The dew point is 21° right now."),
                WeatherDetailItem(title: "WIND", value: "12 km/h", systemIconName: "wind", description: "NW winds with gusts up to 18 km/h."),
                WeatherDetailItem(title: "UV INDEX", value: "6 Mod", systemIconName: "sun.max", description: "Moderate risk of harm from unprotected sun exposure."),
                WeatherDetailItem(title: "AIR QUALITY", value: "42 - Good", systemIconName: "aqi.low", description: "Air quality is satisfactory.")
            ]
        )
    }
}
