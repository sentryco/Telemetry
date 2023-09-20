import Foundation

/**
 * `Exception` is a struct that represents an exception event in the system.
 * It conforms to the `ActionKind` protocol.
 */
public struct Exception: ActionKind {
   // A string that describes the exception.
   public let description: String
   
   // A boolean that indicates if the exception was fatal to the execution of the program.
   public let isFatal: Bool
   
   // A dictionary of additional parameters for the event.
   public let params: [String: String]
   
   /**
    * Initializes an instance of `Exception`.
    * - Parameters:
    *   - description: The description of the exception.
    *   - isFatal: Indicates if the exception was fatal to the execution of the program.
    *   - params: A dictionary of additional parameters for the event.
    */
   public init(description: String, isFatal: Bool, params: [String: String] = .init()) {
      self.description = description
      self.isFatal = isFatal
      self.params = params
   }
}

extension Exception {
   // A string that represents the key of the exception.
   public var key: String { "exception" }
   
   /**
    * A dictionary that represents the output of the exception.
    * It includes the description and the fatality of the exception, along with any additional parameters.
    */
   public var output: [String: String] {
      var params: [String: String] = self.params
      params["exd"] = description
      params["exf"] = String(isFatal)
      return params
   }
}