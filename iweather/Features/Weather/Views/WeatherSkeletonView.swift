import SwiftUI

/// Animated skeleton loading view displaying pulsing placeholders while weather is fetching.
struct WeatherSkeletonView: View {
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 24) {
            
            // Header Skeleton
            HStack {
                skeletonBox(width: 140, height: 32)
                Spacer()
                skeletonBox(width: 40, height: 40, cornerRadius: 20)
            }
            .padding(.top, 8)
            
            // Hero Weather Summary Skeleton
            VStack(spacing: 12) {
                skeletonBox(width: 72, height: 72, cornerRadius: 36)
                skeletonBox(width: 120, height: 60)
                skeletonBox(width: 100, height: 20)
                skeletonBox(width: 140, height: 16)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            
            // Hourly Section Skeleton
            VStack(alignment: .leading, spacing: 14) {
                skeletonBox(width: 80, height: 16)
                
                HStack(spacing: 20) {
                    ForEach(0..<5, id: \.self) { _ in
                        VStack(spacing: 8) {
                            skeletonBox(width: 40, height: 14)
                            skeletonBox(width: 28, height: 28, cornerRadius: 14)
                            skeletonBox(width: 32, height: 16)
                        }
                    }
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color.white.opacity(0.06))
            )
            
            // 7-Day Section Skeleton
            VStack(alignment: .leading, spacing: 14) {
                skeletonBox(width: 120, height: 16)
                
                VStack(spacing: 12) {
                    ForEach(0..<5, id: \.self) { _ in
                        HStack {
                            skeletonBox(width: 50, height: 16)
                            Spacer()
                            skeletonBox(width: 24, height: 24, cornerRadius: 12)
                            Spacer()
                            skeletonBox(width: 80, height: 16)
                        }
                    }
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color.white.opacity(0.06))
            )
        }
        .opacity(isAnimating ? 0.35 : 0.85)
        .onAppear {
            withAnimation(.easeInOut(duration: 0.9).repeatForever(autoreverses: true)) {
                isAnimating = true
            }
        }
    }
    
    @ViewBuilder
    private func skeletonBox(width: CGFloat, height: CGFloat, cornerRadius: CGFloat = 8) -> some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .fill(Color.white.opacity(0.15))
            .frame(width: width, height: height)
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        WeatherSkeletonView()
            .padding()
    }
}
