import Foundation

/**
 * `Exception` is a struct that represents an exception event in the system.
 * It conforms to the `ActionKind` protocol.
 */
public struct Exception: ActionKind {
   public let description: String // A string that describes the exception.
   public let isFatal: Bool // A boolean that indicates if the exception was fatal to the execution of the program.
   public let params: [String: String] // A dictionary of additional parameters for the event.
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
      var params: [String: String] = self.params // Initializes a new dictionary of parameters with the existing parameters
      params["exd"] = description // Adds the exception description to the parameters dictionary
      params["exf"] = String(isFatal) // Adds a boolean indicating if the exception was fatal to the parameters dictionary
      return params // Returns the updated parameters dictionary
   }
}