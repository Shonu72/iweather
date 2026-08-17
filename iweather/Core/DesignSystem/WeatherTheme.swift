import SwiftUI

/// Dynamic theme palette adapted specifically for a weather condition.
struct WeatherTheme {
    let backgroundGradient: [Color]
    let cardBackground: Color
    let cardBorder: Color
    let textPrimary: Color
    let textSecondary: Color
    let accentColor: Color
}

extension WeatherCondition {
    var theme: WeatherTheme {
        switch self {
        case .sunny:
            return WeatherTheme(
                backgroundGradient: [
                    Color(red: 0.1, green: 0.45, blue: 0.85),
                    Color(red: 0.35, green: 0.7, blue: 0.95)
                ],
                cardBackground: Color.white.opacity(0.18),
                cardBorder: Color.white.opacity(0.25),
                textPrimary: .white,
                textSecondary: Color.white.opacity(0.8),
                accentColor: .yellow
            )
        case .clear:
            return WeatherTheme(
                backgroundGradient: [
                    Color(red: 0.05, green: 0.08, blue: 0.22),
                    Color(red: 0.12, green: 0.18, blue: 0.38)
                ],
                cardBackground: Color.white.opacity(0.1),
                cardBorder: Color.white.opacity(0.15),
                textPrimary: .white,
                textSecondary: Color.white.opacity(0.7),
                accentColor: .cyan
            )
        case .partlyCloudy, .cloudy:
            return WeatherTheme(
                backgroundGradient: [
                    Color(red: 0.18, green: 0.26, blue: 0.36),
                    Color(red: 0.32, green: 0.42, blue: 0.52)
                ],
                cardBackground: Color.white.opacity(0.12),
                cardBorder: Color.white.opacity(0.18),
                textPrimary: .white,
                textSecondary: Color.white.opacity(0.75),
                accentColor: .white
            )
        case .lightRain, .heavyRain, .thunderstorm:
            return WeatherTheme(
                backgroundGradient: [
                    Color(red: 0.08, green: 0.12, blue: 0.22),
                    Color(red: 0.16, green: 0.24, blue: 0.35)
                ],
                cardBackground: Color.white.opacity(0.1),
                cardBorder: Color.white.opacity(0.15),
                textPrimary: .white,
                textSecondary: Color.white.opacity(0.7),
                accentColor: Color.blue.opacity(0.8)
            )
        case .haze:
            return WeatherTheme(
                backgroundGradient: [
                    Color(red: 0.28, green: 0.24, blue: 0.22),
                    Color(red: 0.42, green: 0.36, blue: 0.32)
                ],
                cardBackground: Color.white.opacity(0.12),
                cardBorder: Color.white.opacity(0.18),
                textPrimary: .white,
                textSecondary: Color.white.opacity(0.75),
                accentColor: .orange
            )
        }
    }
}
