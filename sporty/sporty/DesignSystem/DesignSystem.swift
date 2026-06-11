//
//  DesignSystem.swift
//  sporty
//
//  Central design tokens — single source of truth for spacing,
//  typography, corner radii, shadows, and cell dimensions.
//

import UIKit

// MARK: - Design System Tokens

enum DS {

    // MARK: - Spacing

    enum Spacing {
        static let xxs: CGFloat  = 4
        static let xs: CGFloat   = 8
        static let sm: CGFloat   = 12
        static let md: CGFloat   = 16
        static let lg: CGFloat   = 20
        static let xl: CGFloat   = 24
        static let xxl: CGFloat  = 32
    }

    // MARK: - Corner Radius

    enum CornerRadius {
        static let small: CGFloat   = 8
        static let medium: CGFloat  = 12
        static let large: CGFloat   = 16
        static let pill: CGFloat    = 24
        static let circle: CGFloat  = 28
    }

    // MARK: - Typography

    enum Typography {
        static func heading1() -> UIFont {
            .systemFont(ofSize: 28, weight: .bold)
        }
        static func heading2() -> UIFont {
            .systemFont(ofSize: 22, weight: .semibold)
        }
        static func heading3() -> UIFont {
            .systemFont(ofSize: 18, weight: .semibold)
        }
        static func body() -> UIFont {
            .systemFont(ofSize: 16, weight: .regular)
        }
        static func bodyMedium() -> UIFont {
            .systemFont(ofSize: 16, weight: .medium)
        }
        static func caption() -> UIFont {
            .systemFont(ofSize: 13, weight: .regular)
        }
        static func label() -> UIFont {
            .systemFont(ofSize: 14, weight: .medium)
        }
        static func emptyState() -> UIFont {
            .systemFont(ofSize: 18, weight: .regular)
        }
    }

    // MARK: - Shadows

    enum Shadow {
        static let card = ShadowStyle(
            color: .black,
            opacity: 0.08,
            offset: CGSize(width: 0, height: 4),
            radius: 12
        )
        static let subtle = ShadowStyle(
            color: .black,
            opacity: 0.05,
            offset: CGSize(width: 0, height: 2),
            radius: 4
        )
    }

    // MARK: - Cell Sizes

    enum CellSize {
        static let upcomingEventWidth: CGFloat   = 320
        static let upcomingEventHeight: CGFloat  = 212
        static let latestEventHeight: CGFloat    = 190
        static let latestEventSpacing: CGFloat   = 14
        static let teamCellWidth: CGFloat        = 80
        static let teamCellHeight: CGFloat       = 116
        static let playerRowHeight: CGFloat      = 90
        static let favoriteRowHeight: CGFloat    = 92
        static let sportsCardLandscapeHeight: CGFloat = 250
    }

    // MARK: - Layout

    enum Layout {
        static let collectionInsets = UIEdgeInsets(
            top: Spacing.xs,
            left: Spacing.md,
            bottom: Spacing.xs,
            right: Spacing.md
        )
        static let defaultInteritemSpacing: CGFloat = Spacing.xs
        static let defaultLineSpacing: CGFloat = Spacing.md
        static let sportsGridSpacing: CGFloat = 10
        static let sportsGridPadding: CGFloat = 16
        static let sportsGridLineSpacing: CGFloat = 8
    }
}

// MARK: - Shadow Style

struct ShadowStyle {
    let color: UIColor
    let opacity: Float
    let offset: CGSize
    let radius: CGFloat
}
