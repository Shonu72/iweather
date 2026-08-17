import SwiftUI

/// Component displaying 7-day daily weather forecast in a vertical list.
struct DailyForecastView: View {
    let forecasts: [DailyForecast]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("7 Day Forecast")
                .font(.headline)
                .foregroundStyle(.secondary)
            
            VStack(spacing: 12) {
                ForEach(forecasts) { item in
                    HStack {
                        // Day name
                        Text(item.day)
                            .font(.body)
                            .fontWeight(.medium)
                            .frame(width: 60, alignment: .leading)
                        
                        Spacer()
                        
                        // Condition icon
                        Image(systemName: item.systemIconName)
                            .symbolRenderingMode(.multicolor)
                            .font(.title3)
                            .frame(width: 32)
                        
                        Spacer()
                        
                        // High / Low temperatures matching "30° / 24°" format from wireframe
                        Text("\(item.highTemperature)°  /  \(item.lowTemperature)°")
                            .font(.body)
                            .monospacedDigit()
                            .foregroundStyle(.secondary)
                    }
                    if item.id != forecasts.last?.id {
                        Divider()
                            .opacity(0.3)
                    }
                }
            }
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        DailyForecastView(forecasts: WeatherViewModel.mockData(for: "Bhopal").dailyForecasts)
            .padding()
    }
}
