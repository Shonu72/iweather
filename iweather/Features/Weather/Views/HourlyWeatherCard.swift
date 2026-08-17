import SwiftUI

/// Component representing a single hour forecast item consuming HourlyForecastItem model.
struct HourlyWeatherCard: View {
    let forecast: HourlyForecastItem
    var unit: TemperatureUnit = .celsius
    
    var body: some View {
        VStack(spacing: 8) {
            Text(forecast.time)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(.primary)
            
            Image(systemName: forecast.condition.systemIconName)
                .symbolRenderingMode(.multicolor)
                .font(.title2)
                .frame(height: 28)
            
            Text(unit.formatted(forecast.temperature))
                .font(.headline)
                .foregroundStyle(.primary)
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
