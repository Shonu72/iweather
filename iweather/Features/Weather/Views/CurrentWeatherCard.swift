import SwiftUI

/// Hero card container combining TemperatureView and WeatherConditionView.
struct CurrentWeatherCard: View {
    let systemIconName: String
    let temperature: Int
    let condition: String
    let highTemperature: Int
    let lowTemperature: Int
    
    var body: some View {
        VStack(spacing: 8) {
            TemperatureView(
                systemIconName: systemIconName,
                temperature: temperature
            )
            
            WeatherConditionView(
                condition: condition,
                highTemperature: highTemperature,
                lowTemperature: lowTemperature
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
            lowTemperature: 24
        )
    }
}
