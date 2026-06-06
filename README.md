# MatchPulse 🏆

MatchPulse is a native iOS application built with Swift that allows users to explore sports leagues, teams, fixtures, player profiles, and match statistics across multiple sports including Football, Basketball, Tennis, and Cricket.

The application follows the MVP (Model-View-Presenter) architecture pattern and integrates with the AllSportsAPI to provide real-time sports data.

---

## Features

### Sports Categories

* Football
* Basketball
* Tennis
* Cricket

### Leagues

* Browse leagues by sport
* Search leagues instantly
* View league details
* Add and remove favorite leagues

### Fixtures

* Upcoming matches
* Latest results
* Match details
* Team logos and player images

### Teams

* View teams participating in a league
* Team logos and information
* Navigate to squad details

### Players

* Squad listing
* Player information
* Position, age, and jersey number
* Player profile images

### Tennis Support

* Browse tennis tournaments
* View player profiles
* Tennis-specific fixtures and statistics

### Favorites

* Save favorite leagues locally
* Offline persistence using Core Data

### User Experience

* Onboarding experience using UIPageViewController
* Empty State Views
* Network Connectivity Handling
* Responsive layouts for different screen sizes
* Placeholder images for missing assets

---

## Architecture

The project follows the MVP architecture:

```text
View Controller
      ↓
   Presenter
      ↓
 Network Layer
      ↓
   API / CoreData
```

### Components

* Views

  * HomeViewController
  * LeaguesViewController
  * MainLeagueViewController
  * SquadViewController
  * TennisPlayerViewController

* Presenters

  * HomePresenter
  * LeaguePresenter
  * MainLeaguePresenter
  * SquadPresenter

* Services

  * NetworkManager
  * ReachabilityManager
  * CoreDataManager

---

## Technologies Used

* Swift
* UIKit
* MVP Architecture
* Alamofire
* SDWebImage
* Core Data
* Reachability
* Auto Layout
* UIPageViewController

---

## API

This project uses:

AllSportsAPI

https://allsportsapi.com

Endpoints used:

* Leagues
* Teams
* Fixtures
* Tennis Fixtures
* Players

---

## Screenshots

### Onboarding

* Modern onboarding flow
* Page indicators
* Sports highlights

### Home

* Sports selection screen

### Leagues

* Search leagues
* Manage favorites

### League Details

* Upcoming fixtures
* Latest matches
* Teams

### Squad

* Team players
* Player details

---

## Installation

### Requirements

* Xcode 16+
* iOS 16+
* Swift 5+

### Clone Repository

```bash
git clone https://github.com/yourusername/MatchPulse.git
```

### Install Dependencies

Using CocoaPods:

```bash
pod install
```

Open:

```bash
MatchPulse.xcworkspace
```

Run the project on a simulator or physical device.

---

## Project Structure

```text
MatchPulse
│
├── Models
├── Views
├── Presenters
├── Network
├── CoreData
├── Helpers
├── Resources
├── Storyboards
└── Assets
```

---

## Future Improvements

* Live match tracking
* Push notifications
* Dark mode customization
* Advanced statistics
* User accounts
* Match reminders
* Watchlist support

---

## Authors

Developed as an iOS Sports Application project using Swift, UIKit, MVP Architecture, Alamofire, SDWebImage, and Core Data.

---

## License

This project is intended for educational and portfolio purposes.
