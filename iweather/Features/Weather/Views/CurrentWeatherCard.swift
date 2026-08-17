import SwiftUI

/// Hero card container combining TemperatureView and WeatherConditionView consuming CurrentWeather model.
struct CurrentWeatherCard: View {
    let current: CurrentWeather
    var unit: TemperatureUnit = .celsius
    
    var body: some View {
        VStack(spacing: AppTheme.Spacing.xSmall) {
            TemperatureView(
                condition: current.condition,
                temperature: current.temperature,
                unit: unit
            )
            
            WeatherConditionView(
                condition: current.condition,
                highTemperature: current.highTemperature,
                lowTemperature: current.lowTemperature,
                unit: unit
            )
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, AppTheme.Spacing.xSmall)
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        CurrentWeatherCard(
            current: CurrentWeather(
                temperature: 29,
                feelsLike: 31,
                highTemperature: 32,
                lowTemperature: 24,
                condition: .sunny,
                humidity: 68,
                windSpeed: 12.0,
                pressure: 1012,
                uvIndex: 6,
                visibility: 10.0
            ),
            unit: .celsius
        )
    }
}
