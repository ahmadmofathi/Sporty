//
//  EmptyStateView.swift
//  sporty
//
//  A premium, reusable empty-state component that replaces
//  the plain UILabel approach. Features an SF Symbol icon,
//  bold title, subtle subtitle, and a smooth fade-in animation.
//

import UIKit

// MARK: - EmptyStateView

final class EmptyStateView: UIView {

    // MARK: - Preset Configurations

    /// Quick presets for common empty state scenarios.
    enum Preset {
        case noData
        case noInternet
        case error
        case noFavorites
        case noPlayers

        var icon: String {
            switch self {
            case .noData:      return "tray"
            case .noInternet:  return "wifi.slash"
            case .error:       return "exclamationmark.triangle"
            case .noFavorites: return "heart.slash"
            case .noPlayers:   return "person.3"
            }
        }

        var defaultTitle: String {
            switch self {
            case .noData:      return "No Data Available"
            case .noInternet:  return "No Connection"
            case .error:       return "Something Went Wrong"
            case .noFavorites: return "No Favorites Yet"
            case .noPlayers:   return "No Players Found"
            }
        }

        var iconColor: UIColor {
            switch self {
            case .noData:      return ThemeManager.textTertiary
            case .noInternet:  return ThemeManager.accentDestructive
            case .error:       return ThemeManager.accentDestructive
            case .noFavorites: return ThemeManager.accentPrimary
            case .noPlayers:   return ThemeManager.textTertiary
            }
        }
    }

    // MARK: - Subviews

    private let containerStack: UIStackView = {
        let s = UIStackView()
        s.axis = .vertical
        s.alignment = .center
        s.spacing = 12
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
    }()

    private let iconContainer: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = 32
        v.clipsToBounds = true
        return v
    }()

    private let iconView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.tintColor = ThemeManager.textTertiary
        return iv
    }()

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.font = DS.Typography.heading3()
        l.textColor = ThemeManager.textPrimary
        l.textAlignment = .center
        l.numberOfLines = 0
        return l
    }()

    private let subtitleLabel: UILabel = {
        let l = UILabel()
        l.font = DS.Typography.body()
        l.textColor = ThemeManager.textTertiary
        l.textAlignment = .center
        l.numberOfLines = 0
        return l
    }()

    // MARK: - Init

    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        isHidden = true
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setupLayout() {
        addSubview(containerStack)

        // Icon container background
        iconContainer.addSubview(iconView)

        NSLayoutConstraint.activate([
            iconContainer.widthAnchor.constraint(equalToConstant: 64),
            iconContainer.heightAnchor.constraint(equalToConstant: 64),
            iconView.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 32),
            iconView.heightAnchor.constraint(equalToConstant: 32)
        ])

        containerStack.addArrangedSubview(iconContainer)
        containerStack.addArrangedSubview(titleLabel)
        containerStack.addArrangedSubview(subtitleLabel)

        // Add custom spacing after icon
        containerStack.setCustomSpacing(16, after: iconContainer)
        containerStack.setCustomSpacing(8, after: titleLabel)

        NSLayoutConstraint.activate([
            containerStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerStack.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -20),
            containerStack.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: DS.Spacing.xxl),
            containerStack.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -DS.Spacing.xxl)
        ])
    }

    // MARK: - Public API

    /// Configure with a preset and an optional custom subtitle.
    func configure(preset: Preset, subtitle: String? = nil) {
        let config = UIImage.SymbolConfiguration(pointSize: 28, weight: .medium)
        iconView.image = UIImage(systemName: preset.icon, withConfiguration: config)
        iconView.tintColor = preset.iconColor

        // Icon container gets a soft tinted background
        iconContainer.backgroundColor = preset.iconColor.withAlphaComponent(0.12)

        titleLabel.text = preset.defaultTitle
        subtitleLabel.text = subtitle
        subtitleLabel.isHidden = (subtitle == nil || subtitle?.isEmpty == true)
    }

    /// Configure with a fully custom icon, title, and subtitle.
    func configure(systemIcon: String, tintColor: UIColor = ThemeManager.textTertiary, title: String, subtitle: String? = nil) {
        let config = UIImage.SymbolConfiguration(pointSize: 28, weight: .medium)
        iconView.image = UIImage(systemName: systemIcon, withConfiguration: config)
        iconView.tintColor = tintColor
        iconContainer.backgroundColor = tintColor.withAlphaComponent(0.12)

        titleLabel.text = title
        subtitleLabel.text = subtitle
        subtitleLabel.isHidden = (subtitle == nil || subtitle?.isEmpty == true)
    }

    /// Show with a smooth fade-in + scale-up animation.
    func showAnimated() {
        guard isHidden else { return }
        alpha = 0
        transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
        isHidden = false

        UIView.animate(
            withDuration: 0.45,
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0.5,
            options: .curveEaseOut
        ) {
            self.alpha = 1
            self.transform = .identity
        }
    }

    /// Hide with a smooth fade-out animation.
    func hideAnimated(completion: (() -> Void)? = nil) {
        guard !isHidden else {
            completion?()
            return
        }
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.alpha = 0
        }) { _ in
            self.isHidden = true
            self.transform = .identity
            completion?()
        }
    }
}
