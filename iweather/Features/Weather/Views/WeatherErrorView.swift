import SwiftUI

/// Dedicated Error view displaying error icon, error message, and a Retry action button.
struct WeatherErrorView: View {
    let message: String
    let onRetry: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 56))
                .foregroundStyle(.yellow)
                .padding(20)
                .background(Color.yellow.opacity(0.15), in: Circle())
            
            Text("Unable to Load Weather")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.primary)
            
            Text(message)
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            Button {
                onRetry()
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "arrow.clockwise")
                        .fontWeight(.semibold)
                    Text("Try Again")
                        .fontWeight(.semibold)
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(Color.blue, in: Capsule())
                .foregroundStyle(.white)
            }
            .padding(.top, 8)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        WeatherErrorView(message: "The network connection was lost. Please check your connection and try again.", onRetry: {})
    }
}
