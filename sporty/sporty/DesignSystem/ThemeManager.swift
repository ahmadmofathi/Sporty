//
//  ThemeManager.swift
//  sporty
//
//  Central theme manager that provides semantic color accessors
//  backed by named Color Assets. Each color set includes both
//  light and dark appearance values.
//

import UIKit

// MARK: - ThemeManager

enum ThemeManager {

    // MARK: - Backgrounds

    static var backgroundPrimary: UIColor {
        UIColor(named: "backgroundPrimary") ?? .systemBackground
    }
    static var backgroundSecondary: UIColor {
        UIColor(named: "backgroundSecondary") ?? .secondarySystemBackground
    }
    static var backgroundCard: UIColor {
        UIColor(named: "backgroundCard") ?? .tertiarySystemBackground
    }

    // MARK: - Text

    static var textPrimary: UIColor {
        UIColor(named: "textPrimary") ?? .label
    }
    static var textSecondary: UIColor {
        UIColor(named: "textSecondary") ?? .secondaryLabel
    }
    static var textTertiary: UIColor {
        UIColor(named: "textTertiary") ?? .tertiaryLabel
    }

    // MARK: - Accents

    static var accentPrimary: UIColor {
        UIColor(named: "accentPrimary") ?? .systemBlue
    }
    static var accentSuccess: UIColor {
        UIColor(named: "accentSuccess") ?? .systemGreen
    }
    static var accentDestructive: UIColor {
        UIColor(named: "accentDestructive") ?? .systemRed
    }

    // MARK: - Utility

    static var separatorColor: UIColor {
        UIColor(named: "separatorColor") ?? .separator
    }
    static var shadowColor: UIColor {
        UIColor(named: "shadowColor") ?? .black
    }
    static var navBarBackground: UIColor {
        UIColor(named: "navBarBackground") ?? .systemBackground
    }
    static var tabBarBackground: UIColor {
        UIColor(named: "tabBarBackground") ?? .systemBackground
    }

    // MARK: - Global Appearance

    /// Call once in `AppDelegate.didFinishLaunchingWithOptions`.
    static func applyGlobalAppearance() {

        // Navigation Bar
        let navAppearance = UINavigationBarAppearance()
        navAppearance.configureWithOpaqueBackground()
        navAppearance.backgroundColor = navBarBackground
        navAppearance.titleTextAttributes = [.foregroundColor: textPrimary]
        navAppearance.largeTitleTextAttributes = [.foregroundColor: textPrimary]

        UINavigationBar.appearance().standardAppearance   = navAppearance
        UINavigationBar.appearance().scrollEdgeAppearance  = navAppearance
        UINavigationBar.appearance().compactAppearance     = navAppearance
        UINavigationBar.appearance().tintColor             = accentPrimary

        // Tab Bar
        let tabAppearance = UITabBarAppearance()
        tabAppearance.configureWithOpaqueBackground()
        tabAppearance.backgroundColor = tabBarBackground

        UITabBar.appearance().standardAppearance   = tabAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabAppearance
        UITabBar.appearance().tintColor            = accentPrimary

        // Table View
        UITableView.appearance().backgroundColor = backgroundPrimary
        UITableViewCell.appearance().backgroundColor = backgroundPrimary

        // Search Bar
        UISearchBar.appearance().tintColor = accentPrimary

        // Page Control
        UIPageControl.appearance().currentPageIndicatorTintColor = accentPrimary
        UIPageControl.appearance().pageIndicatorTintColor = textTertiary
    }
}
