//
//  L10n.swift
//  sporty
//
//  Type-safe localization helper that wraps NSLocalizedString.
//  Provides namespaced convenience accessors so view controllers
//  never reference raw key strings directly.
//

import Foundation

// MARK: - L10n

enum L10n {

    /// Generic lookup with optional format arguments.
    static func localized(_ key: String, _ args: CVarArg...) -> String {
        let format = NSLocalizedString(key, comment: "")
        return args.isEmpty ? format : String(format: format, arguments: args)
    }

    // MARK: - General

    enum General {
        static var unknownLeague: String  { localized("general.unknown_league") }
        static var unknownCountry: String { localized("general.unknown_country") }
        static var unknown: String        { localized("general.unknown") }
        static var cancel: String         { localized("general.cancel") }
        static var remove: String         { localized("general.remove") }
        static var ok: String             { localized("general.ok") }
        static var error: String          { localized("general.error") }
        static var na: String             { localized("general.na") }
        static var dash: String           { localized("general.dash") }
    }

    // MARK: - Navigation Titles

    enum Nav {
        static var leagues: String   { localized("nav.leagues") }
        static var favorites: String { localized("nav.favorites") }
    }

    // MARK: - Home (Sport Names)

    enum Home {
        static var football: String   { localized("home.football") }
        static var basketball: String { localized("home.basketball") }
        static var tennis: String     { localized("home.tennis") }
        static var cricket: String    { localized("home.cricket") }
    }

    // MARK: - Onboarding

    enum Onboarding {
        static var title1: String { localized("onboarding.title1") }
        static var desc1: String  { localized("onboarding.desc1") }
        static var title2: String { localized("onboarding.title2") }
        static var desc2: String  { localized("onboarding.desc2") }
        static var title3: String { localized("onboarding.title3") }
        static var desc3: String  { localized("onboarding.desc3") }
    }

    // MARK: - Empty States

    enum Empty {
        static var noLeagues: String        { localized("empty.no_leagues") }
        static var noPlayers: String        { localized("empty.no_players") }
        static var noLeagueData: String     { localized("empty.no_league_data") }
        static var failedLeagues: String    { localized("empty.failed_leagues") }
        static var failedTeams: String      { localized("empty.failed_teams") }
        static var failedLeagueData: String { localized("empty.failed_league_data") }
        static var noPlayerData: String     { localized("empty.no_player_data") }
    }

    // MARK: - Network

    enum Network {
        static var noInternetTitle: String { localized("network.no_internet_title") }
        static var noInternetBody: String  { localized("network.no_internet_body") }

        /// Formatted full message: title + body
        static var noInternetFull: String {
            "\(noInternetTitle)\n\n\(noInternetBody)"
        }
    }

    // MARK: - Favorites

    enum Favorites {
        static var removeTitle: String { localized("favorites.remove_title") }
        static func removeMessage(leagueName: String) -> String {
            localized("favorites.remove_message", leagueName)
        }
    }

    // MARK: - Tennis Player

    enum Tennis {
        static func season(year: String, type: String) -> String {
            localized("tennis.season_format", year, type)
        }
        static func rank(number: String) -> String {
            localized("tennis.rank_format", number)
        }
        static func record(won: Int, lost: Int, titles: String) -> String {
            localized("tennis.record_format", won, lost, titles)
        }
        static func vs(player1: String, player2: String) -> String {
            localized("tennis.vs_format", player1, player2)
        }
        static func date(value: String) -> String {
            localized("tennis.date_format", value)
        }
        static func result(value: String) -> String {
            localized("tennis.result_format", value)
        }
        static var singles: String { localized("tennis.singles") }
        static var doubles: String { localized("tennis.doubles") }
    }

    // MARK: - Player Info

    enum Player {
        static func info(type: String, age: String) -> String {
            localized("player.info_format", type, age)
        }
    }
}
