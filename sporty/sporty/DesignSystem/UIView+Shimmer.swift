//
//  UIView+Shimmer.swift
//  sporty
//
//  Premium shimmer/skeleton loading effect.
//  Adds a glossy, animated gradient overlay to any UIView,
//  replicating the native iOS skeleton-loading feel.
//

import UIKit

// MARK: - Shimmer Animation

extension UIView {

    private static let shimmerLayerName = "sporty.shimmer.gradient"
    private static let shimmerAnimationKey = "sporty.shimmer.slide"

    /// Start a premium shimmer animation on this view.
    ///
    /// The shimmer is a semi-transparent gradient that slides
    /// across the view continuously, giving a "loading" feel.
    func startShimmering() {
        // Prevent duplicates
        guard layer.sublayers?.first(where: { $0.name == UIView.shimmerLayerName }) == nil else { return }

        let gradient = CAGradientLayer()
        gradient.name = UIView.shimmerLayerName
        gradient.frame = bounds
        gradient.cornerRadius = layer.cornerRadius

        // Use theme-aware colors for the shimmer
        let baseColor = ThemeManager.backgroundSecondary.resolvedColor(
            with: UITraitCollection.current
        )
        let shimmerColor = ThemeManager.backgroundCard.resolvedColor(
            with: UITraitCollection.current
        )

        gradient.colors = [
            baseColor.cgColor,
            shimmerColor.cgColor,
            baseColor.cgColor
        ]

        gradient.locations = [0.0, 0.5, 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint   = CGPoint(x: 1.0, y: 0.5)

        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-1.0, -0.5, 0.0]
        animation.toValue   = [1.0, 1.5, 2.0]
        animation.duration  = 1.4
        animation.repeatCount = .infinity
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        gradient.add(animation, forKey: UIView.shimmerAnimationKey)
        layer.addSublayer(gradient)
    }

    /// Stop the shimmer animation and remove the gradient layer.
    func stopShimmering() {
        layer.sublayers?
            .filter { $0.name == UIView.shimmerLayerName }
            .forEach { $0.removeFromSuperlayer() }
    }
}

// MARK: - Skeleton Loader Overlay

/// A reusable overlay that displays skeleton placeholder rows
/// with a shimmer animation, designed to sit on top of a
/// `UITableView` or `UICollectionView` while data is loading.
final class SkeletonLoaderOverlay: UIView {

    /// Layout style for the skeleton placeholders.
    enum Style {
        /// Vertical rows (for table views / list-based layouts).
        case rows(count: Int)
        /// Horizontal cards (for collection view carousels).
        case cards(count: Int)
        /// Grid (2-column, for home sports grid).
        case grid(count: Int)
    }

    private var skeletonViews: [UIView] = []

    init(style: Style) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = ThemeManager.backgroundPrimary
        clipsToBounds = true
        buildSkeleton(style: style)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Build Skeletons

    private func buildSkeleton(style: Style) {
        switch style {
        case .rows(let count):
            buildRows(count: count)
        case .cards(let count):
            buildCards(count: count)
        case .grid(let count):
            buildGrid(count: count)
        }
    }

    private func buildRows(count: Int) {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = DS.Spacing.sm
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor, constant: DS.Spacing.md),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: DS.Spacing.md),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -DS.Spacing.md)
        ])

        for _ in 0..<count {
            let row = makeSkeletonRow()
            stack.addArrangedSubview(row)
            skeletonViews.append(row)
        }
    }

    private func buildCards(count: Int) {
        let scroll = UIScrollView()
        scroll.showsHorizontalScrollIndicator = false
        scroll.isUserInteractionEnabled = false
        scroll.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scroll)

        NSLayoutConstraint.activate([
            scroll.topAnchor.constraint(equalTo: topAnchor),
            scroll.leadingAnchor.constraint(equalTo: leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: trailingAnchor),
            scroll.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = DS.Spacing.sm
        stack.translatesAutoresizingMaskIntoConstraints = false
        scroll.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: scroll.topAnchor, constant: DS.Spacing.md),
            stack.leadingAnchor.constraint(equalTo: scroll.leadingAnchor, constant: DS.Spacing.md),
            stack.trailingAnchor.constraint(equalTo: scroll.trailingAnchor, constant: -DS.Spacing.md),
            stack.heightAnchor.constraint(equalToConstant: DS.CellSize.teamCellHeight)
        ])

        for _ in 0..<count {
            let card = makeSkeletonCard()
            stack.addArrangedSubview(card)
            skeletonViews.append(card)
        }
    }

    private func buildGrid(count: Int) {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = DS.Spacing.sm
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor, constant: DS.Spacing.md),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: DS.Spacing.md),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -DS.Spacing.md)
        ])

        var remaining = count
        while remaining > 0 {
            let row = UIStackView()
            row.axis = .horizontal
            row.distribution = .fillEqually
            row.spacing = DS.Spacing.sm

            let cellsInRow = min(remaining, 2)
            for _ in 0..<cellsInRow {
                let card = UIView()
                card.backgroundColor = ThemeManager.backgroundSecondary
                card.layer.cornerRadius = DS.CornerRadius.medium
                card.heightAnchor.constraint(equalToConstant: 180).isActive = true
                row.addArrangedSubview(card)
                skeletonViews.append(card)
            }

            // If odd, add a spacer to keep layout balanced
            if cellsInRow == 1 {
                let spacer = UIView()
                spacer.isHidden = true
                row.addArrangedSubview(spacer)
            }

            stack.addArrangedSubview(row)
            remaining -= cellsInRow
        }
    }

    // MARK: - Factory Helpers

    private func makeSkeletonRow() -> UIView {
        let container = UIView()
        container.backgroundColor = ThemeManager.backgroundSecondary
        container.layer.cornerRadius = DS.CornerRadius.small
        container.translatesAutoresizingMaskIntoConstraints = false
        container.heightAnchor.constraint(equalToConstant: 72).isActive = true

        // Small circle placeholder (image)
        let circle = UIView()
        circle.backgroundColor = ThemeManager.backgroundCard
        circle.layer.cornerRadius = 22
        circle.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(circle)

        NSLayoutConstraint.activate([
            circle.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: DS.Spacing.sm),
            circle.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            circle.widthAnchor.constraint(equalToConstant: 44),
            circle.heightAnchor.constraint(equalToConstant: 44)
        ])

        // Title line
        let titleLine = UIView()
        titleLine.backgroundColor = ThemeManager.backgroundCard
        titleLine.layer.cornerRadius = 4
        titleLine.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(titleLine)

        NSLayoutConstraint.activate([
            titleLine.leadingAnchor.constraint(equalTo: circle.trailingAnchor, constant: DS.Spacing.sm),
            titleLine.topAnchor.constraint(equalTo: container.topAnchor, constant: DS.Spacing.md),
            titleLine.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 0.45),
            titleLine.heightAnchor.constraint(equalToConstant: 14)
        ])

        // Subtitle line
        let subtitleLine = UIView()
        subtitleLine.backgroundColor = ThemeManager.backgroundCard
        subtitleLine.layer.cornerRadius = 4
        subtitleLine.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(subtitleLine)

        NSLayoutConstraint.activate([
            subtitleLine.leadingAnchor.constraint(equalTo: circle.trailingAnchor, constant: DS.Spacing.sm),
            subtitleLine.topAnchor.constraint(equalTo: titleLine.bottomAnchor, constant: DS.Spacing.xs),
            subtitleLine.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 0.30),
            subtitleLine.heightAnchor.constraint(equalToConstant: 10)
        ])

        return container
    }

    private func makeSkeletonCard() -> UIView {
        let card = UIView()
        card.backgroundColor = ThemeManager.backgroundSecondary
        card.layer.cornerRadius = DS.CornerRadius.medium
        card.translatesAutoresizingMaskIntoConstraints = false
        card.widthAnchor.constraint(equalToConstant: DS.CellSize.teamCellWidth).isActive = true

        let circle = UIView()
        circle.backgroundColor = ThemeManager.backgroundCard
        circle.layer.cornerRadius = 20
        circle.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(circle)

        NSLayoutConstraint.activate([
            circle.centerXAnchor.constraint(equalTo: card.centerXAnchor),
            circle.topAnchor.constraint(equalTo: card.topAnchor, constant: DS.Spacing.md),
            circle.widthAnchor.constraint(equalToConstant: 40),
            circle.heightAnchor.constraint(equalToConstant: 40)
        ])

        let line = UIView()
        line.backgroundColor = ThemeManager.backgroundCard
        line.layer.cornerRadius = 4
        line.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(line)

        NSLayoutConstraint.activate([
            line.centerXAnchor.constraint(equalTo: card.centerXAnchor),
            line.topAnchor.constraint(equalTo: circle.bottomAnchor, constant: DS.Spacing.xs),
            line.widthAnchor.constraint(equalToConstant: 50),
            line.heightAnchor.constraint(equalToConstant: 10)
        ])

        return card
    }

    // MARK: - Animation Control

    /// Begin shimmer animations on all skeleton placeholder views.
    func startAnimating() {
        // Ensure layout is complete before applying shimmer
        layoutIfNeeded()
        skeletonViews.forEach { $0.startShimmering() }
    }

    /// Stop shimmer and fade out the entire overlay, then remove from view hierarchy.
    func stopAnimating(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.35, delay: 0, options: .curveEaseOut, animations: {
            self.alpha = 0
        }) { _ in
            self.skeletonViews.forEach { $0.stopShimmering() }
            self.removeFromSuperview()
            completion?()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        // Re-sync shimmer gradient frames after layout changes
        skeletonViews.forEach { view in
            view.layer.sublayers?
                .filter { $0.name == UIView.shimmerLayerName }
                .forEach { $0.frame = view.bounds }
        }
    }
}
