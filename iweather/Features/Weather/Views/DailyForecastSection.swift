import SwiftUI

/// Section displaying 7-day weather forecast list consuming DailyForecastItem domain models and AppTheme tokens.
struct DailyForecastSection: View {
    let forecasts: [DailyForecastItem]
    var unit: TemperatureUnit = .celsius
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
            Text("7 Day Forecast")
                .font(AppTheme.Typography.sectionHeader)
                .foregroundStyle(AppTheme.Colors.textSecondary)
            
            VStack(spacing: AppTheme.Spacing.small) {
                ForEach(forecasts) { item in
                    DailyWeatherRow(
                        forecast: item,
                        showDivider: item.id != forecasts.last?.id,
                        unit: unit
                    )
                }
            }
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        AppCardView {
            DailyForecastSection(forecasts: WeatherViewModel.mockData(for: "Bhopal").daily, unit: .celsius)
        }
        .padding()
    }
}
