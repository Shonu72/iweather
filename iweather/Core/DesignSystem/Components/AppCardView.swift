import SwiftUI

/// Reusable Design System card container applying frosted glass background and card corner radius.
struct AppCardView<Content: View>: View {
    let padding: CGFloat
    let content: Content
    
    init(padding: CGFloat = AppTheme.Spacing.medium, @ViewBuilder content: () -> Content) {
        self.padding = padding
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(padding)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.card, style: .continuous)
                    .fill(AppTheme.Colors.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: AppTheme.CornerRadius.card, style: .continuous)
                            .stroke(AppTheme.Colors.cardBorder, lineWidth: 1)
                    )
            )
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        AppCardView {
            Text("Design System Card View")
                .foregroundStyle(.white)
        }
        .padding()
    }
}
