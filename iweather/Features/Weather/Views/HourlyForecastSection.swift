import SwiftUI

/// Section displaying hourly forecasts formatted for active unit.
struct HourlyForecastSection: View {
    let forecasts: [HourlyForecast]
    var unit: TemperatureUnit = .celsius
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Hourly")
                .font(.headline)
                .foregroundStyle(.secondary)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 24) {
                    ForEach(forecasts) { item in
                        HourlyWeatherCard(forecast: item, unit: unit)
                    }
                }
                .padding(.vertical, 4)
            }
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        HourlyForecastSection(forecasts: WeatherViewModel.mockData(for: "Bhopal").hourlyForecasts, unit: .celsius)
            .padding()
    }
}
