import Foundation
/**
 * Commands
 * - Remark: The class support tracking of sessions, screen/page views, events and timings with optional custom dimension parameters.
 * For a full list of all the supported parameters please refer to the [Google Analytics parameter reference](https://developers.google.com/analytics/devguides/collection/protocol/v1/parameters)
 * Fix: rename to params etc
 */
extension Telemetry {
   /**
    * Tracks a screen view event as page view to Google Analytics by setting the required parameters
    * - Remark: - Screen (page) views are reported using `screenView(_:parameters:)` with the name of the screen.
    * - Remark: `dh` - hostname as appIdentifier and `dp` - path as screen name with leading `/`
    * - Remark: and optional `dt` - document title as screen name pageview parameters for valid hit request.
    * - Parameters:
    *   - name: The name of the screen. Make sure it does not have spaces, use .replacingOccurrences(of: " ", with: "") etc
    *   - parameters: A dictionary of additional parameters for the event.
    */
   static func screenView(_ name: String, parameters: [String: String] = [:]) {
      var parameters = parameters
      parameters["dh"] = System.appIdentifier
      parameters["dp"] = "/" + name
      parameters["dt"] = name
      send(type: "pageview", parameters: parameters)
   }
   /**
    * Tracks a session start to Google Analytics by setting the `sc` parameter of the request. The `dp` parameter is set to the name of the application.
    * - Remark: Sessions are reported with `session(_:parameters:)` with the first parameter set to true for session start or false for session end.
    * - Parameter start: true indicate session started, false - session finished.
    */
   static func session(start: Bool, parameters: [String: String] = [:]) {
      var parameters = parameters
      parameters["sc"] = start ? "start" : "end"
      parameters["dp"] = System.appName
      send(type: "session", parameters: parameters)
   }
   /**
    * Tracks an exception event to Google Analytics.
    * - remark: Exceptions are reported using `exception(_:isFatal:parameters:)`
    * - Parameter description: The description of the exception (ec).
    * - Parameter isFatal: Indicates if the exception was fatal to the execution of the program (exf).
    * - Parameter parameters: A dictionary of additional parameters for the event.
    */
   static func exception(_ description: String, isFatal: Bool, parameters: [String: String] = [:]) {
      var parameters = parameters
      parameters["exd"] = description
      parameters["exf"] = String(isFatal)
      send(type: "exception", parameters: parameters)
   }
   /**
    * Tracks a timing to Google Analytics.
    * - Remark: Timings are reported using `timing(_:name:label:time:parameters:)` with time parameter in seconds.
    * - Parameter category: The category of the timing (utc).
    * - Parameter name: The variable name of the timing  (utv).
    * - Parameter label: The variable label for the timing  (utl).
    * - Parameter time: Length of the timing (utt).
    * - Parameter parameters: A dictionary of additional parameters for the timing
    */
   public static func timing(_ category: String, name: String, label: String = "", time: TimeInterval, parameters: [String: String] = [:]) {
      var parameters = parameters
      parameters["utc"] = category
      parameters["utv"] = name
      parameters["utl"] = label
      parameters["utt"] = String(Int(time * 1000))
      send(type: "timing", parameters: parameters)
   }
   /**
    * Tracks an event to Google Analytics.
    * - Remark: Generic events are reported using `event(_:action:label:parameters:)`.
    * - Parameter category: The category of the event (ec).
    * - Parameter action: The action of the event (ea).
    * - Parameter label: The label of the event (el).
    * - Parameter parameters: A dictionary of additional parameters for the event.
    */
   public static func event(_ category: String, action: String, label: String = "", parameters: [String: String] = [:]) {
      var parameters = parameters
      parameters["ec"] = category
      parameters["ea"] = action
      parameters["el"] = label
      send(type: "event", parameters: parameters)
   }
}


