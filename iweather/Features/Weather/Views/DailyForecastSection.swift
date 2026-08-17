import SwiftUI

/// Section displaying 7-day weather forecast list formatted for active unit.
struct DailyForecastSection: View {
    let forecasts: [DailyForecast]
    var unit: TemperatureUnit = .celsius
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("7 Day Forecast")
                .font(.headline)
                .foregroundStyle(.secondary)
            
            VStack(spacing: 12) {
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
        DailyForecastSection(forecasts: WeatherViewModel.mockData(for: "Bhopal").dailyForecasts, unit: .celsius)
            .padding()
    }
}
