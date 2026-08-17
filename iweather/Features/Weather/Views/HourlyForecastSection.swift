import SwiftUI

/// Section displaying hourly forecasts with header and horizontal scroll list.
struct HourlyForecastSection: View {
    let forecasts: [HourlyForecast]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Hourly")
                .font(.headline)
                .foregroundStyle(.secondary)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 24) {
                    ForEach(forecasts) { item in
                        HourlyWeatherCard(forecast: item)
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
        HourlyForecastSection(forecasts: WeatherViewModel.mockData.hourlyForecasts)
            .padding()
    }
}
