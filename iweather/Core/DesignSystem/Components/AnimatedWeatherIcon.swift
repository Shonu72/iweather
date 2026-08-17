import SwiftUI

/// Animated weather condition SF Symbol with continuous subtle ambient motion.
struct AnimatedWeatherIcon: View {
    let condition: WeatherCondition
    var size: CGFloat = 64
    
    @State private var isRotating = false
    @State private var isDrifting = false
    @State private var isBouncing = false
    
    var body: some View {
        Image(systemName: condition.systemIconName)
            .symbolRenderingMode(.multicolor)
            .font(.system(size: size))
            .rotationEffect(.degrees(condition == .sunny && isRotating ? 360 : 0))
            .offset(
                x: condition == .partlyCloudy && isDrifting ? 4 : -4,
                y: (condition == .lightRain || condition == .heavyRain) && isBouncing ? 3 : -2
            )
            .onAppear {
                startAnimation()
            }
            .onChange(of: condition) { _, _ in
                startAnimation()
            }
    }
    
    private func startAnimation() {
        switch condition {
        case .sunny:
            withAnimation(.linear(duration: 25).repeatForever(autoreverses: false)) {
                isRotating = true
            }
        case .partlyCloudy, .cloudy:
            withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                isDrifting = true
            }
        case .lightRain, .heavyRain, .thunderstorm:
            withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                isBouncing = true
            }
        default:
            break
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        HStack(spacing: 24) {
            AnimatedWeatherIcon(condition: .sunny, size: 48)
            AnimatedWeatherIcon(condition: .partlyCloudy, size: 48)
            AnimatedWeatherIcon(condition: .lightRain, size: 48)
        }
    }
}
