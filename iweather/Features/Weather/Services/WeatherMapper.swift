import Foundation

/// Converter mapping API DTO objects into clean Swift domain models.
enum WeatherMapper {
    
    static func map(dto: OpenMeteoForecastDTO, location: WeatherLocation) -> Weather {
        let highTemp = Int(round(dto.daily.temperature_2m_max.first ?? dto.current.temperature_2m))
        let lowTemp = Int(round(dto.daily.temperature_2m_min.first ?? dto.current.temperature_2m))
        
        let current = CurrentWeather(
            temperature: Int(round(dto.current.temperature_2m)),
            feelsLike: Int(round(dto.current.apparent_temperature)),
            highTemperature: highTemp,
            lowTemperature: lowTemp,
            condition: dto.current.weather_code.asWeatherCondition,
            humidity: dto.current.relative_humidity_2m,
            windSpeed: dto.current.wind_speed_10m,
            pressure: Int(round(dto.current.surface_pressure)),
            uvIndex: Int(round(dto.current.uv_index ?? 5.0)),
            visibility: 10.0
        )
        
        var hourlyItems: [HourlyForecastItem] = []
        let hourlyCount = min(dto.hourly.time.count, dto.hourly.temperature_2m.count)
        let maxHourlyIndex = min(hourlyCount, 24)
        
        for i in 0..<maxHourlyIndex {
            let timeString = formatHourString(from: dto.hourly.time[i])
            let temp = Int(round(dto.hourly.temperature_2m[i]))
            let condition = dto.hourly.weather_code[i].asWeatherCondition
            
            hourlyItems.append(HourlyForecastItem(time: timeString, temperature: temp, condition: condition))
        }
        
        var dailyItems: [DailyForecastItem] = []
        let dailyCount = min(dto.daily.time.count, dto.daily.temperature_2m_max.count)
        let maxDailyIndex = min(dailyCount, 7)
        
        for i in 0..<maxDailyIndex {
            let dayString = formatDayString(from: dto.daily.time[i])
            let maxTemp = Int(round(dto.daily.temperature_2m_max[i]))
            let minTemp = Int(round(dto.daily.temperature_2m_min[i]))
            let condition = dto.daily.weather_code[i].asWeatherCondition
            
            dailyItems.append(DailyForecastItem(day: dayString, highTemperature: maxTemp, lowTemperature: minTemp, condition: condition))
        }
        
        return Weather(
            location: location,
            current: current,
            hourly: hourlyItems,
            daily: dailyItems
        )
    }
    
    private static func formatHourString(from isoTime: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        if let date = formatter.date(from: isoTime) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateFormat = "h a"
            return displayFormatter.string(from: date)
        }
        return isoTime
    }
    
    private static func formatDayString(from isoDate: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = formatter.date(from: isoDate) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateFormat = "EEE"
            return displayFormatter.string(from: date)
        }
        return isoDate
    }
}
