import XCTest
@testable import sporty

final class HomePresenterTests: XCTestCase {

    var presenter: HomePresenter!
    var mockView: MockSportsView!

    override func setUp() {
        super.setUp()

        mockView = MockSportsView()
        presenter = HomePresenter(view: mockView)
    }

    override func tearDown() {
        presenter = nil
        mockView = nil

        super.tearDown()
    }

    func testViewDidLoad_ShouldDisplaySports() {

        presenter.viewDidLoad()

        XCTAssertTrue(mockView.displaySportsCalled)

        XCTAssertEqual(
            mockView.receivedNames,
            ["football", "BasketBall", "Tennis", "cricket"]
        )

        XCTAssertEqual(
            mockView.receivedImages,
            ["football", "basketball", "tennis", "baseball"]
        )
    }

    func testDidSelectSport_ShouldNavigateToFootball() {

        presenter.didSelectSport(at: 0)

        XCTAssertTrue(mockView.navigateCalled)

        XCTAssertEqual(
            mockView.receivedSport,
            "football"
        )
    }

    func testDidSelectSport_ShouldNavigateToBasketball() {

        presenter.didSelectSport(at: 1)

        XCTAssertEqual(
            mockView.receivedSport,
            "BasketBall"
        )
    }

    func testDidSelectSport_ShouldNavigateToTennis() {

        presenter.didSelectSport(at: 2)

        XCTAssertEqual(
            mockView.receivedSport,
            "Tennis"
        )
    }
}


final class MockSportsView: SportsViewProtocol {

    var displaySportsCalled = false
    var navigateCalled = false

    var receivedNames: [String] = []
    var receivedImages: [String] = []

    var receivedSport: String?

    func displaySports(
        _ names: [String],
        images: [String]
    ) {

        displaySportsCalled = true

        receivedNames = names
        receivedImages = images
    }

    func navigateToLeague(
        with sportName: String
    ) {

        navigateCalled = true

        receivedSport = sportName
    }
}
