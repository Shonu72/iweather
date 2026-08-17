import SwiftUI

/// Component representing a single row in the daily forecast list formatted for active unit.
struct DailyWeatherRow: View {
    let forecast: DailyForecast
    let showDivider: Bool
    var unit: TemperatureUnit = .celsius
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text(forecast.day)
                    .font(.body)
                    .fontWeight(.medium)
                    .frame(width: 60, alignment: .leading)
                
                Spacer()
                
                Image(systemName: forecast.systemIconName)
                    .symbolRenderingMode(.multicolor)
                    .font(.title3)
                    .frame(width: 32)
                
                Spacer()
                
                Text("\(unit.formatted(forecast.highTemperature))  /  \(unit.formatted(forecast.lowTemperature))")
                    .font(.body)
                    .monospacedDigit()
                    .foregroundStyle(.secondary)
            }
            
            if showDivider {
                Divider()
                    .opacity(0.3)
            }
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        DailyWeatherRow(
            forecast: DailyForecast(day: "Mon", systemIconName: "sun.max.fill", highTemperature: 30, lowTemperature: 24),
            showDivider: true,
            unit: .celsius
        )
        .padding()
    }
}
