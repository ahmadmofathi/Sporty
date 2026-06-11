//
//  UIView+DesignSystem.swift
//  sporty
//
//  Shared UIView extensions that replace duplicated code patterns
//  across view controllers (shadow application, card styling,
//  empty-state setup).
//

import UIKit

// MARK: - Shadow Helpers

extension UIView {

    /// Apply a `ShadowStyle` to the receiver's layer.
    func applyShadow(_ style: ShadowStyle) {
        layer.shadowColor   = style.color.cgColor
        layer.shadowOpacity = style.opacity
        layer.shadowOffset  = style.offset
        layer.shadowRadius  = style.radius
        layer.masksToBounds = false
    }

    /// Convenience: card appearance = corner radius + shadow.
    func applyCardStyle(
        cornerRadius: CGFloat = DS.CornerRadius.medium,
        shadow: ShadowStyle = DS.Shadow.subtle
    ) {
        layer.cornerRadius = cornerRadius
        clipsToBounds = false
        applyShadow(shadow)
    }
}

// MARK: - Empty State Helpers

extension UIViewController {

    /// Creates, adds, and returns a centred empty-state label.
    ///
    /// This replaces the identical `setupEmptyState()` that was
    /// copy-pasted across four view controllers.
    @discardableResult
    func addEmptyStateLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment  = .center
        label.numberOfLines  = 0
        label.font           = DS.Typography.emptyState()
        label.textColor      = ThemeManager.textSecondary
        label.isHidden       = true

        view.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: DS.Spacing.lg
            ),
            label.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -DS.Spacing.lg
            )
        ])

        return label
    }
}

// MARK: - Image View Helpers

extension UIImageView {

    /// Apply circular clipping (used for favourite league logos, etc.)
    func applyCircularMask() {
        layer.cornerRadius = DS.CornerRadius.circle
        clipsToBounds = true
    }
}
