import XCTest
@testable import Telemetry

final class TelemetryTests: XCTestCase {
   func testExample() throws {
      Self.systemTest()
      Self.testIdentity()
//      Self.basicTest(testCase: self) // only works if real tracker id is used
   }
}
extension TelemetryTests {
   /**
    * Sys test
    */
   fileprivate static func systemTest() {
      Swift.print("System.appBuild: \(System.appBuild)") // 20501
      Swift.print("System.appIdentifier: \(System.appIdentifier)") // com.apple.dt.xctest.tool
      Swift.print("System.appName: \(System.appName)") // xctest
      Swift.print("System.screenResolution: \(System.screenResolution)") // 1440.0x900.0
      Swift.print("System.userLanguage: \(System.userLanguage)") // en-US etc
      Swift.print("System.userAgent: \(System.userAgent)") // Mozilla/5.0...
   }
   /**
    * ID test
    */
   fileprivate static func testIdentity() {
      let test: (_ type: IDType) -> Void = { type in
         let id = Identity.uniqueUserIdentifier(type: type)
         Swift.print("id: \(id)")
         let id2 = Identity.uniqueUserIdentifier(type: type)
         let isTheSame = id == id2
         Swift.print("\(String(describing: type)) isTheSame: \(isTheSame ? "✅" : "🚫")")
         XCTAssertTrue(isTheSame)
      }
      test(.userdefault) // test userdefault
      test(.keychain) // test keychain
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
