import Foundation
/**
 * Commands
 * - Remark: The class support tracking of sessions, screen/page views, events and timings with optional custom dimension parameters.
 * - Remark: For a full list of all the supported parameters please refer to the [Google Analytics parameter reference](https://developers.google.com/analytics/devguides/collection/protocol/v1/parameters)
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
   public static func screenView(_ name: String, params: [String: String] = .init(), complete: @escaping Complete = defaultComplete) {
      var params = params
      params["dh"] = System.appIdentifier
      params["dp"] = "/" + name
      params["dt"] = name
      send(type: "pageview", parameters: params, complete: complete)
   }
   /**
    * Tracks a session start to Google Analytics by setting the `sc` parameter of the request. The `dp` parameter is set to the name of the application.
    * - Remark: Sessions are reported with `session(_:parameters:)` with the first parameter set to true for session start or false for session end.
    * - Parameter start: true indicate session started, false - session finished.
    */
   public static func session(start: Bool, params: [String: String] = .init(), complete: @escaping Complete = defaultComplete) {
      var params = params
      params["sc"] = start ? "start" : "end"
      params["dp"] = System.appName
      send(type: "session", parameters: params, complete: complete)
   }
   /**
    * Tracks an exception event to Google Analytics.
    * - remark: Exceptions are reported using `exception(_:isFatal:parameters:)`
    * - Parameters:
    *   - description: The description of the exception (ec).
    *   - isFatal: Indicates if the exception was fatal to the execution of the program (exf).
    *   - parameters: A dictionary of additional parameters for the event.
    */
   public static func exception(_ description: String, isFatal: Bool, params: [String: String] = .init(), complete: @escaping Complete = defaultComplete) {
      var params = params
      params["exd"] = description
      params["exf"] = String(isFatal)
      send(type: "exception", parameters: params, complete: complete)
   }
   /**
    * Tracks a timing to Google Analytics.
    * - Remark: Timings are reported using `timing(_:name:label:time:parameters:)` with time parameter in seconds.
    * - Parameters:
    *   - category: The category of the timing (utc).
    *   - name: The variable name of the timing  (utv).
    *   - label: The variable label for the timing  (utl).
    *   - time: Length of the timing (utt).
    *   - parameters: A dictionary of additional parameters for the timing
    */
   public static func timing(_ category: String, name: String, label: String = "", time: TimeInterval, params: [String: String] = .init(), complete: @escaping Complete = defaultComplete) {
      var params = params
      params["utc"] = category
      params["utv"] = name
      params["utl"] = label
      params["utt"] = String(Int(time * 1000))
      send(type: "timing", parameters: params, complete: complete)
   }
   /**
    * Tracks an event to Google Analytics.
    * - Remark: Generic events are reported using `event(_:action:label:parameters:)`.
    * - Parameters:
    *   - category: The category of the event (ec).
    *   - action: The action of the event (ea).
    *   - label: The label of the event (el).
    *   - parameters: A dictionary of additional parameters for the event.
    */
   public static func event(_ category: String, action: String, label: String = "", params: [String: String] = .init(), complete: @escaping Complete = defaultComplete) {
      var params = params
      params["ec"] = category
      params["ea"] = action
      params["el"] = label
      send(type: "event", parameters: params, complete: complete)
   }
}


