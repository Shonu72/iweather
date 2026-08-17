import SwiftUI

/// Ambient canvas component rendering condition-specific weather particle effects using TimelineView and Canvas.
struct WeatherParticleCanvas: View {
    let condition: WeatherCondition
    
    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let time = timeline.date.timeIntervalSince1970
                
                switch condition {
                case .lightRain, .heavyRain, .thunderstorm:
                    drawRaindrops(context: context, size: size, time: time)
                case .clear:
                    drawStars(context: context, size: size, time: time)
                case .sunny:
                    drawSunGlow(context: context, size: size, time: time)
                default:
                    break
                }
            }
        }
        .allowsHitTesting(false)
        .ignoresSafeArea()
    }
    
    private func drawRaindrops(context: GraphicsContext, size: CGSize, time: Double) {
        let count = condition == .heavyRain || condition == .thunderstorm ? 40 : 20
        let screenWidth = max(1, size.width)
        let screenHeight = max(1, size.height)
        
        for i in 0..<count {
            let speed = 260.0 + Double(i * 15)
            let x = (Double(i * 41) + time * 30.0).truncatingRemainder(dividingBy: screenWidth)
            let y = (Double(i * 79) + time * speed).truncatingRemainder(dividingBy: screenHeight)
            
            var path = Path()
            path.move(to: CGPoint(x: x, y: y))
            path.addLine(to: CGPoint(x: x - 2, y: y + 16))
            
            context.stroke(
                path,
                with: .color(Color.white.opacity(0.35)),
                lineWidth: 1.5
            )
        }
    }
    
    private func drawStars(context: GraphicsContext, size: CGSize, time: Double) {
        let screenWidth = max(1, Int(size.width))
        let screenHeight = max(1, Int(size.height * 0.6))
        
        for i in 0..<30 {
            let x = Double((i * 83) % screenWidth)
            let y = Double((i * 47) % screenHeight)
            let opacity = 0.3 + 0.5 * sin(time * 2.0 + Double(i))
            
            let rect = CGRect(x: x, y: y, width: 2, height: 2)
            context.fill(Path(ellipseIn: rect), with: .color(Color.white.opacity(opacity)))
        }
    }
    
    private func drawSunGlow(context: GraphicsContext, size: CGSize, time: Double) {
        let center = CGPoint(x: size.width * 0.8, y: size.height * 0.15)
        let pulse = 1.0 + 0.08 * sin(time * 1.5)
        let radius = 180.0 * pulse
        
        let rect = CGRect(
            x: center.x - radius,
            y: center.y - radius,
            width: radius * 2,
            height: radius * 2
        )
        
        context.fill(
            Path(ellipseIn: rect),
            with: .radialGradient(
                Gradient(colors: [Color.yellow.opacity(0.25), Color.orange.opacity(0.0)]),
                center: center,
                startRadius: 10,
                endRadius: radius
            )
        )
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        WeatherParticleCanvas(condition: .lightRain)
    }
}
