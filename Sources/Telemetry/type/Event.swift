import Foundation

/**
 * `Event` is a struct that represents a telemetry event.
 * It conforms to the `ActionKind` protocol.
 */
public struct Event: ActionKind {
   public let category: String // The category of the event
   public let action: String // The action of the event
   public let label: String // The label of the event
   public let params: [String: String] // A dictionary of additional parameters for the event
   /**
    * Initializes an `Event` instance.
    * - Parameters:
    *   - category: The category of the event (ec)
    *   - action: The action of the event (ea)
    *   - label: The label of the event (el). Default is an empty string.
    *   - params: A dictionary of additional parameters for the event. Default is an empty dictionary.
    */
   public init(category: String, action: String, label: String = "", params: [String: String] = .init()) {
      self.category = category
      self.action = action
      self.label = label
      self.params = params
   }
}
/**
 * `Event` extension that provides additional functionality.
 */
extension Event {
   // A key that represents the event
   public var key: String { "event" }
   /**
    * An output dictionary that includes the event's category, action, label, and additional parameters.
    * - Returns: A dictionary that represents the event.
    */
   public var output: [String: String] {
     var params: [String: String] = self.params  // Copy the existing parameters
      params["ec"] = category  // Set the event category
      params["ea"] = action  // Set the event action
      params["el"] = label  // Set the event label
      return params  // Return the updated parameters
   }
}