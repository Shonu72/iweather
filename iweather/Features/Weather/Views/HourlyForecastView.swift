import SwiftUI

/// Component displaying hourly weather forecasts in a horizontal scrollable view.
struct HourlyForecastView: View {
    let forecasts: [HourlyForecast]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Hourly")
                .font(.headline)
                .foregroundStyle(.secondary)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 24) {
                    ForEach(forecasts) { item in
                        VStack(spacing: 8) {
                            Text(item.time)
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundStyle(.primary)
                            
                            Image(systemName: item.systemIconName)
                                .symbolRenderingMode(.multicolor)
                                .font(.title2)
                                .frame(height: 28)
                            
                            Text("\(item.temperature)°")
                                .font(.headline)
                                .foregroundStyle(.primary)
                        }
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
        HourlyForecastView(forecasts: WeatherViewModel.mockData(for: "Bhopal").hourlyForecasts)
            .padding()
    }
}
