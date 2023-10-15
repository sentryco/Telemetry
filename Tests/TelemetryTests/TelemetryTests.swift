import XCTest
@testable import Telemetry

// This class contains unit tests for the Telemetry module
final class TelemetryTests: XCTestCase {
   // This function tests the system and identity functionalities
   func testExample() throws {
       // Test system functionalities
       Self.systemTest()
       // Test identity functionalities
       Self.testIdentity()
       // Uncomment the following lines to test other functionalities
       // Self.basicTest(testCase: self) // only works if real tracker id is used
       // Self.aggTest()
       // Self.readAggStatsTest() // used to debug telemetry aggregator log in terminal
   }
}

// Extension to add more methods to the TelemetryTests class
extension TelemetryTests {
    /**
    * This function tests the system functionalities by printing various system properties
    */
   fileprivate static func systemTest() {
      // Print the build number of the application
      Swift.print("System.appBuild: \(System.appBuild)") // Example output: 20501
      // Print the unique identifier of the application
      Swift.print("System.appIdentifier: \(System.appIdentifier)") // Example output: com.apple.dt.xctest.tool
      // Print the name of the application
      Swift.print("System.appName: \(System.appName)") // Example output: xctest
      // Print the screen resolution of the device
      Swift.print("System.screenResolution: \(System.screenResolution)") // Example output: 1440.0x900.0
      // Print the language setting of the user's device
      Swift.print("System.userLanguage: \(System.userLanguage)") // Example output: en-US etc
      // Print the user agent string of the device
      Swift.print("System.userAgent: \(System.userAgent)") // Example output: Mozilla/5.0...
   }
   /**
    * This function tests the identity functionalities by generating and comparing unique user identifiers
    */
   fileprivate static func testIdentity() {
      // Define a test function that generates and compares unique user identifiers
      // Define a test function that takes an IDType as input
      let test: (_ type: IDType) -> Void = { type in
         // Generate a new unique user identifier based on the given IDType
         let id = Identity.uniqueUserIdentifier(type: type)
         // Print the generated identifier
         Swift.print("id: \(id)")
         // Retrieve the identifier from the persistent layer
         let id2 = Identity.uniqueUserIdentifier(type: type)
         // Check if the generated identifier and the retrieved identifier are the same
         let isTheSame = id == id2
         // Print the result of the comparison
         Swift.print("\(String(describing: type)) isTheSame: \(isTheSame ? "✅" : "🚫")")
         // Assert that the identifiers are the same for the test to pass
         XCTAssertTrue(isTheSame)
      }
      // Run the test function with userdefault as the IDType
      test(.userdefault)
      // Run the test function with keychain as the IDType
      test(.keychain)
   }
    /**
    * This function tests the basic functionalities of Google analytics
    * - Note: Currently, it only waits for event. Other functionalities will be fixed later
    */
   fileprivate static func basicTest(testCase: XCTestCase) {
      Swift.print("basicTest")
      // Set the identifier type for the Telemetry
      Telemetry.idType = .userdefault // vendor doesn't work on mac or command-line-unit-test, and keychain doesnt work in comandline-unit-tests in an easy way
      // Set the tracker ID for the Telemetry
      Telemetry.trackerId = "UA-XXXXX-XX" //"" // Use real ga-tracker-id here, to test properly etc
      // Create an expectation for a screen view function
      let screenView = testCase.expectation(description: "screen view function")
      // Call the screen view function and print whether it was successful
      Telemetry.action(ScreenView(name: "Cheers")) { success in
         Swift.print("screenView complete:  \(success)")
         screenView.fulfill() // Fulfill the expectation
      }
      // Create an expectation for a session start function
      let sessionStart = testCase.expectation(description: "session start function")
      // Call the session start function and print whether it was successful
      Telemetry.action(Session(start: true)) { success in// applicationDidBecomeActive
         Swift.print("session start complete: \(success)")
         sessionStart.fulfill() // Fulfill the expectation
      }
      // Create an expectation for a session end function
      let sessionEnd = testCase.expectation(description: "session end function")
      // Call the session end function and print whether it was successful
      Telemetry.action(Session(start: false)) { success in // applicationDidEnterBackground
         Swift.print("session end complete: \(success)")
         sessionEnd.fulfill() // Fulfill the expectation
      }
      // Create an expectation for an auth function
      let authDone = testCase.expectation(description: "auth function") // expectation is in the XCTestCase
      // Call the auth function and print whether it was successful
      Telemetry.action(Event(category: "Authorize", action: "Access granted")) { success in
         Swift.print("event complete: \(success)")
         authDone.fulfill() // Fulfill the expectation
      }
      // Create an expectation for an exception function
      let exceptionCalled = testCase.expectation(description: "exception function")
      // Call the exception function and print whether it was successful
      Telemetry.action(Exception(description: "🐛 MainView - cell error", isFatal: false)) { success in
         Swift.print("Exception complete: \(success)")
         exceptionCalled.fulfill() // Fulfill the expectation
      }
      // Wait for all the expectations to be fulfilled with a timeout of 10 seconds
      testCase.wait(for: [screenView, sessionStart, sessionEnd, authDone, exceptionCalled], timeout: 10) // Add after work has been called
   }

   /**
    * This function tests the local aggregator by generating and comparing stats
    */
   fileprivate static func aggTest() {
      // Try to initiate the Telemetry type as an aggregator, resetting any previous data
      do {
         Telemetry.tmType = .agg(try .initiate(reset: true))
      } catch {
         // Print any error that occurs during initiation
         Swift.print("error: \(error.localizedDescription)")
      }
      // Send a screen view action named "Cheers" to the Telemetry
      Telemetry.action(ScreenView(name: "Cheers"))
      // Send another screen view action named "Howdy" to the Telemetry
      Telemetry.action(ScreenView(name: "Howdy"))
      // Start a session in the Telemetry
      Telemetry.action(Session(start: true))
      // End the session in the Telemetry
      Telemetry.action(Session(start: false))
      // Send an event action with category "Authorize" and action "Access granted" to the Telemetry
      Telemetry.action(Event(category: "Authorize", action: "Access granted"))
      // If there are any stats available from the aggregator, print them
      if let stats: String = Telemetry.tmType.aggregator?.stats {
         Swift.print(stats)
      }
      // Check if the stats are correct: 2 screen views, 1 event, and 2 sessions
      let statsAreCorrect = {
         Telemetry.tmType.aggregator?.screenViews.count == 2 &&
         Telemetry.tmType.aggregator?.events.count == 1 &&
         Telemetry.tmType.aggregator?.sessions.count == 2
      }()
      // Print whether the stats are correct or not
      Swift.print("statsAreCorrect: \(statsAreCorrect ? "✅" : "🚫")")
      // Assert that the stats are correct for the unit test to pass
      XCTAssertTrue(statsAreCorrect)
   }
   /**
    * This function reads and prints the aggregator stats
    */
   fileprivate static func readAggStatsTest() {
      do {
         // Sets the telemetry type to an aggregated type with a non-resetting aggregator
         Telemetry.tmType = .agg(try .initiate(reset: false))
      } catch {
         // Prints an error message if the telemetry type cannot be set
         Swift.print("error: \(error.localizedDescription)")
      }
      // If the telemetry type has an aggregator, prints its stats
      if let stats: String = Telemetry.tmType.aggregator?.stats {
         Swift.print(stats)
      }
   }
}
