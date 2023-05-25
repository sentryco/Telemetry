import Foundation
/**
 * - Fixme: ⚠️️ Rename to TMSession?
 */
public struct Session: ActionKind {
   public let start: Bool
   public let params: [String: String]
   /**
    * Tracks a session start to Google Analytics by setting the `sc` parameter of the request. The `dp` parameter is set to the name of the application.
    * - Remark: Sessions are reported with `session(_:parameters:)` with the first parameter set to true for session start or false for session end
    * - Fixme: ⚠️️ rename to TM...?
    * - Parameter start: true indicate session started, false - session finished.
    */
   public init(start: Bool, params: [String: String] = .init()) {
      self.start = start
      self.params = params
   }
}
extension Session {
   public var key: String { "session" }
   public var output: [String: String] {
      var params: [String: String] = self.params
      params["sc"] = start ? "start" : "end"
      params["dp"] = System.appName
      return params
   }
}
