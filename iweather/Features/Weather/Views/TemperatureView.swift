import SwiftUI

/// Component displaying weather icon and primary temperature number.
struct TemperatureView: View {
    let systemIconName: String
    let temperature: Int
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: systemIconName)
                .symbolRenderingMode(.multicolor)
                .font(.system(size: 68))
                .padding(.vertical, 4)
            
            Text("\(temperature)°")
                .font(.system(size: 72, weight: .thin, design: .rounded))
                .foregroundStyle(.primary)
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        TemperatureView(systemIconName: "sun.max.fill", temperature: 29)
    }
}
