import XCTest
@testable import Telemetry

final class TelemetryTests: XCTestCase {
   func testExample() throws {
      Self.testIdentity()
//      Self.basicTest(testCase: self) // only works if real tracker id is used
   }
}
extension TelemetryTests {
   /**
    * sys test
    */
   fileprivate static func systemTest() {
      Swift.print("System.appBuild: \(System.appBuild)")
      Swift.print("System.appIdentifier: \(System.appIdentifier)")
      Swift.print("System.appName: \(System.appName)")
      Swift.print("System.screenResolution: \(System.screenResolution)")
      Swift.print("System.userAgent: \(System.userAgent)")
      Swift.print("System.userLanguage: \(System.userLanguage)")
   }
   /**
    * ID test
    */
   fileprivate static func testIdentity() {
      let id = Identity.uniqueUserIdentifier(type: .userdefault)
      Swift.print("id: \(id)")
      let id2 = Identity.uniqueUserIdentifier(type: .userdefault)
      let isTheSame = id == id2
      Swift.print("isTheSame: \(isTheSame ? "✅" : "🚫")")
      XCTAssertTrue(isTheSame)
   }
   /**
    * Test calling Google analytics
    * - Fixme: ⚠️️ only waits for event, fix the others later
    */
   fileprivate static func basicTest(testCase: XCTestCase) {
      Telemetry.idType = .userdefault // vendor doesn't work on mac or command-line-unit-test, and keychain doesnt work in comandline-unit-tests in an easy way
      Telemetry.trackerId = "UA-XXXXX-XX" // - Fixme: ⚠️️ use real ga-tracker-id here or?
      // In many cases you'll want to track what "screens" that the user navigates to. A natural place to do that is in your ViewControllers viewDidAppear. You can use the screenView() method of the Telemetry which works the same as event().
      Telemetry.screenView("Cheers")
      // You can track individual sessions for a user by calling session(start: true) when the user opens the app and session(start: false) when they close the app. Here's an example of how to do that in your apps UIApplicationDelegate:
      Telemetry.session(start: true) // applicationDidBecomeActive
      Telemetry.session(start: false) // applicationDidEnterBackground
      // You can track any event you wish to using the event() method. Example:
      let asyncDone = testCase.expectation(description: "Async function") // expectation is in the XCTestCase
      Telemetry.event("Authorize", action: "Access granted") {
         asyncDone.fulfill() // call this to indicate the test was successful
      }
      testCase.wait(for: [asyncDone], timeout: 10) // Add after work has been called
   }
}
