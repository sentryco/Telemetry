import Foundation

public struct Exception: ActionKind {
   public let description: String
   public let isFatal: Bool
   public let params: [String: String]
   /**
    * Tracks an exception event to Google Analytics.
    * - remark: Exceptions are reported using `exception(_:isFatal:parameters:)`
    * - Fixme: ⚠️️ rename to TM...
    * - Parameters:
    *   - description: The description of the exception (ec).
    *   - isFatal: Indicates if the exception was fatal to the execution of the program (exf).
    *   - params: A dictionary of additional parameters for the event.
    */
   public init(description: String, isFatal: Bool, params: [String: String] = .init()) {
      self.description = description
      self.isFatal = isFatal
      self.params = params
   }
}
extension Exception {
   public var key: String { "exception" }
   public var output: [String: String] {
      var params: [String: String] = self.params
      params["exd"] = description
      params["exf"] = String(isFatal)
      return params
   }
}
