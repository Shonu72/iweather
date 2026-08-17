import SwiftUI

/// Section displaying hourly forecasts consuming HourlyForecastItem domain models and AppTheme tokens.
struct HourlyForecastSection: View {
    let forecasts: [HourlyForecastItem]
    var unit: TemperatureUnit = .celsius
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
            Text("Hourly")
                .font(AppTheme.Typography.sectionHeader)
                .foregroundStyle(AppTheme.Colors.textSecondary)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: AppTheme.Spacing.large) {
                    ForEach(forecasts) { item in
                        HourlyWeatherCard(forecast: item, unit: unit)
                    }
                }
                .padding(.vertical, AppTheme.Spacing.xxSmall)
            }
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        AppCardView {
            HourlyForecastSection(forecasts: WeatherViewModel.mockData(for: "Bhopal").hourly, unit: .celsius)
        }
        .padding()
    }
}
