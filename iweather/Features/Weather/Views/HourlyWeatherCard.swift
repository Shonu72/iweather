import SwiftUI

/// Component representing a single hour forecast item consuming HourlyForecastItem model.
struct HourlyWeatherCard: View {
    let forecast: HourlyForecastItem
    var unit: TemperatureUnit = .celsius
    
    var body: some View {
        VStack(spacing: AppTheme.Spacing.xSmall) {
            Text(forecast.time)
                .font(AppTheme.Typography.captionSmall)
                .foregroundStyle(AppTheme.Colors.textPrimary)
            
            AnimatedWeatherIcon(condition: forecast.condition, size: 28)
                .frame(height: 28)
            
            Text(unit.formatted(forecast.temperature))
                .font(AppTheme.Typography.sectionHeader)
                .foregroundStyle(AppTheme.Colors.textPrimary)
                .contentTransition(.numericText())
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        HourlyWeatherCard(
            forecast: HourlyForecastItem(time: "12 PM", temperature: 29, condition: .sunny),
            unit: .celsius
        )
        .padding()
    }
}
