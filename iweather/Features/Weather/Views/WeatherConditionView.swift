import SwiftUI

/// Component displaying condition text ("Sunny") and High/Low temperature range.
struct WeatherConditionView: View {
    let condition: String
    let highTemperature: Int
    let lowTemperature: Int
    
    var body: some View {
        VStack(spacing: 4) {
            Text(condition)
                .font(.title2)
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
            
            Text("H: \(highTemperature)°   L: \(lowTemperature)°")
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        WeatherConditionView(condition: "Sunny", highTemperature: 32, lowTemperature: 24)
    }
}
