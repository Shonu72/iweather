import SwiftUI

/// Hero card container combining TemperatureView and WeatherConditionView with unit formatting.
struct CurrentWeatherCard: View {
    let systemIconName: String
    let temperature: Int
    let condition: String
    let highTemperature: Int
    let lowTemperature: Int
    var unit: TemperatureUnit = .celsius
    
    var body: some View {
        VStack(spacing: 8) {
            TemperatureView(
                systemIconName: systemIconName,
                temperature: temperature,
                unit: unit
            )
            
            WeatherConditionView(
                condition: condition,
                highTemperature: highTemperature,
                lowTemperature: lowTemperature,
                unit: unit
            )
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        CurrentWeatherCard(
            systemIconName: "sun.max.fill",
            temperature: 29,
            condition: "Sunny",
            highTemperature: 32,
            lowTemperature: 24,
            unit: .celsius
        )
    }
}
