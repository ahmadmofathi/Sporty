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

    /// Creates, adds, and returns a premium `EmptyStateView`.
    ///
    /// The view is added edge-to-edge and centred automatically.
    @discardableResult
    func addEmptyStateView() -> EmptyStateView {
        let emptyView = EmptyStateView()
        view.addSubview(emptyView)

        NSLayoutConstraint.activate([
            emptyView.topAnchor.constraint(equalTo: view.topAnchor),
            emptyView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            emptyView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        return emptyView
    }

    // MARK: - Skeleton Overlay Helpers

    private static var skeletonOverlayKey: UInt8 = 0

    /// The currently active skeleton overlay, if any.
    var skeletonOverlay: SkeletonLoaderOverlay? {
        get { objc_getAssociatedObject(self, &UIViewController.skeletonOverlayKey) as? SkeletonLoaderOverlay }
        set { objc_setAssociatedObject(self, &UIViewController.skeletonOverlayKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    /// Show a skeleton loading overlay on top of the specified `targetView`.
    ///
    /// - Parameters:
    ///   - style: The skeleton layout style (rows, cards, or grid).
    ///   - targetView: The view to overlay. Defaults to `self.view`.
    func showSkeletonOverlay(style: SkeletonLoaderOverlay.Style, over targetView: UIView? = nil) {
        // Remove any existing overlay first
        skeletonOverlay?.removeFromSuperview()

        let overlay = SkeletonLoaderOverlay(style: style)
        let container = targetView ?? view

        container.addSubview(overlay)
        NSLayoutConstraint.activate([
            overlay.topAnchor.constraint(equalTo: container.topAnchor),
            overlay.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            overlay.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            overlay.trailingAnchor.constraint(equalTo: container.trailingAnchor)
        ])

        skeletonOverlay = overlay

        // Ensure layout pass before animating
        container.layoutIfNeeded()
        overlay.startAnimating()
    }

    /// Remove the skeleton overlay with a smooth fade-out.
    func hideSkeletonOverlay() {
        skeletonOverlay?.stopAnimating { [weak self] in
            self?.skeletonOverlay = nil
        }
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
