import XCTest
@testable import Telemetry
// fix: rename to Telemetry tests
final class TelemetryTests: XCTestCase {
   func testExample() throws {
      // This is an example of a functional test case.
      // Use XCTAssert and related functions to verify your tests produce the correct
      // results.
      // XCTAssertEqual(GA().text, "Hello, World!")
      // _ = {}()
      Self.basicTest()
      // fix: add telemetry to logger tests. And test for errors and warnings etc
   }
}
extension TelemetryTests {
   // fix: we have to use async unit testing here. see Remote-Timing code etc for how to set it up
   fileprivate static func basicTest() {
      Telemetry.trackerId = "UA-XXXXX-XX" // fix: use real ga-tracker-id here or?
      // You can track any event you wish to using the event() method on the GoogleReporter. Example:
      Telemetry.event("Authentication", action: "Sign Up Completed")
      // In many cases you'll want to track what "screens" that the user navigates to. A natural place to do that is in your ViewControllers viewDidAppear. You can use the screenView() method of the Telemetry which works the same as event().
      Telemetry.screenView("Beer")
      // You can track individual sessions for a user by calling session(start: true) when the user opens the app and session(start: false) when they close the app. Here's an example of how to do that in your apps UIApplicationDelegate:
      Telemetry.session(start: true) // applicationDidBecomeActive
      Telemetry.session(start: false) // applicationDidEnterBackground
      // fix: add exception and timing call
   }
}
