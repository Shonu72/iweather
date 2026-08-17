import SwiftUI

/// Component representing a single hour forecast item (Time, Icon, Temp).
struct HourlyWeatherCard: View {
    let forecast: HourlyForecast
    
    var body: some View {
        VStack(spacing: 8) {
            Text(forecast.time)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(.primary)
            
            Image(systemName: forecast.systemIconName)
                .symbolRenderingMode(.multicolor)
                .font(.title2)
                .frame(height: 28)
            
            Text("\(forecast.temperature)°")
                .font(.headline)
                .foregroundStyle(.primary)
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        HourlyWeatherCard(
            forecast: HourlyForecast(time: "12 PM", systemIconName: "sun.max.fill", temperature: 29)
        )
        .padding()
    }
}
