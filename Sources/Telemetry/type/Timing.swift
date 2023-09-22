import Foundation
/**
 * Timing
 * This struct represents a timing event that can be tracked in Google Analytics.
 * It includes properties for category, name, label, time, and additional parameters.
 */
public struct Timing: ActionKind {
   public let category: String // The category of the timing event
   public let name: String // The name of the timing event
   public let label: String // The label for the timing event
   public let time: TimeInterval // The time duration of the timing event in seconds
   public let params: [String: String] // Additional parameters for the timing event
   /**
    * Initializer for the Timing struct.
    * - Parameters:
    *   - category: The category of the timing (utc)
    *   - name: The variable name of the timing (utv)
    *   - label: The variable label for the timing (utl)
    *   - time: Length of the timing (utt)
    *   - params: A dictionary of additional parameters for the timing
    */
   public init(category: String, name: String, label: String = "", time: TimeInterval, params: [String: String] = .init()) {
      self.category = category
      self.name = name
      self.label = label
      self.time = time
      self.params = params
   }
}
/**
 * Extension of Timing struct.
 * This extension adds two computed properties: key and output.
 */
extension Timing {
   // A key for the timing event
   public var key: String { "timing" }
   // The output dictionary that includes all properties of the timing event
   public var output: [String: String] {
      // Initialize a new variable `params` with the current instance's `params`
      var params: [String: String] = self.params
      // Set the `utc` key in `params` to the current instance's `category`
      params["utc"] = category
      // Set the `utv` key in `params` to the current instance's `name`
      params["utv"] = name
      // Set the `utl` key in `params` to the current instance's `label`
      params["utl"] = label
      // Set the `utt` key in `params` to the current instance's `time` converted to milliseconds
      params["utt"] = String(Int(time * 1000))
      // Return the updated `params`
      return params
   }
}