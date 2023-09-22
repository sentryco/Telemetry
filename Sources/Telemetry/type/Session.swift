import Foundation

// This file defines a Session struct and its extension in Swift.

/**
 * Session
 * This struct represents a session in the context of Google Analytics.
 * It has two properties: start and params.
 * The start property is a boolean indicating whether the session has started or ended.
 * The params property is a dictionary of parameters associated with the session.
 */
public struct Session: ActionKind {
   public let start: Bool
   public let params: [String: String]

   /**
    * This initializer sets up a new Session instance.
    * It tracks a session start to Google Analytics by setting the `sc` parameter of the request. 
    * The `dp` parameter is set to the name of the application.
    * - Remark: Sessions are reported with `session(_:parameters:)` with the first parameter set to true for session start or false for session end
    * - Parameter start: true indicate session started, false - session finished.
    * - Parameter params: A dictionary of parameters associated with the session. Default is an empty dictionary.
    */
   public init(start: Bool, params: [String: String] = .init()) {
      self.start = start
      self.params = params
   }
}

/**
 * Extension of Session
 * This extension adds two computed properties to the Session struct: key and output.
 * The key property is a string that represents the key for the session.
 * The output property is a dictionary that represents the output of the session.
 */
extension Session {
   // The key for the session.
   public var key: String { "session" }
   // The output of the session. It includes the original parameters and adds two more: "sc" and "dp".
   public var output: [String: String] {
      var params: [String: String] = self.params
      params["sc"] = start ? "start" : "end" // "sc" indicates whether the session has started or ended.
      params["dp"] = System.appName // "dp" is set to the name of the application.
      return params
   }
}