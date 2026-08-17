import SwiftUI

/// Component displaying condition text ("Sunny") and High/Low temperature range.
struct WeatherConditionView: View {
    let condition: WeatherCondition
    let highTemperature: Int
    let lowTemperature: Int
    var unit: TemperatureUnit = .celsius
    
    var body: some View {
        VStack(spacing: 4) {
            Text(condition.rawValue)
                .font(.title2)
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
            
            Text("H: \(unit.formatted(highTemperature))   L: \(unit.formatted(lowTemperature))")
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        WeatherConditionView(condition: .sunny, highTemperature: 32, lowTemperature: 24, unit: .celsius)
    }
}
