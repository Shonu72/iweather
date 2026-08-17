import SwiftUI

/// Centralized Design System namespace providing design tokens for Colors, Spacing, CornerRadius, and Typography.
enum AppTheme {
    
    // MARK: - Color Tokens
    enum Colors {
        static let backgroundGradientStart = Color(white: 0.1)
        static let backgroundGradientEnd = Color(white: 0.05)
        static let cardBackground = Color.white.opacity(0.08)
        static let cardBorder = Color.white.opacity(0.12)
        static let textPrimary = Color.white
        static let textSecondary = Color.white.opacity(0.7)
        static let textTertiary = Color.white.opacity(0.4)
        static let accentBlue = Color.blue
        static let warningYellow = Color.yellow
        static let offlineOrange = Color.orange
    }
    
    // MARK: - Spacing Tokens
    enum Spacing {
        static let xxSmall: CGFloat = 4
        static let xSmall: CGFloat = 8
        static let small: CGFloat = 12
        static let medium: CGFloat = 16
        static let large: CGFloat = 20
        static let xLarge: CGFloat = 24
        static let xxLarge: CGFloat = 32
    }
    
    // MARK: - Corner Radius Tokens
    enum CornerRadius {
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let card: CGFloat = 20
        static let pill: CGFloat = 100
    }
    
    // MARK: - Typography Tokens
    enum Typography {
        static let heroTemp = Font.system(size: 72, weight: .thin, design: .rounded)
        static let titleLarge = Font.system(size: 24, weight: .bold, design: .default)
        static let sectionHeader = Font.system(size: 16, weight: .semibold, design: .default)
        static let bodyMedium = Font.system(size: 15, weight: .regular, design: .default)
        static let captionSmall = Font.system(size: 12, weight: .medium, design: .default)
    }
}
