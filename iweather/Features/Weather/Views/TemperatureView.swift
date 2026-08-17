import SwiftUI

/// Component displaying weather icon and primary temperature number formatted for active TemperatureUnit with smooth numeric transitions.
struct TemperatureView: View {
    let condition: WeatherCondition
    let temperature: Int
    var unit: TemperatureUnit = .celsius
    
    var body: some View {
        VStack(spacing: AppTheme.Spacing.xxSmall) {
            AnimatedWeatherIcon(condition: condition, size: 68)
                .padding(.vertical, AppTheme.Spacing.xxSmall)
            
            Text(unit.formatted(temperature))
                .font(AppTheme.Typography.heroTemp)
                .foregroundStyle(AppTheme.Colors.textPrimary)
                .contentTransition(.numericText())
                .animation(.snappy(duration: 0.4), value: unit.formatted(temperature))
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        TemperatureView(condition: .sunny, temperature: 29, unit: .celsius)
    }
}
