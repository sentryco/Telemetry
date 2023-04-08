import Foundation
/**
 * - Fixme: ⚠️️ Rename to TMTiming
 */
public struct Timing: ActionKind {
   public let category: String
   public let name: String
   public let label: String
   public let time: TimeInterval
   public let params: [String: String]
   /**
    * Tracks a timing to Google Analytics.
    * - Remark: Timings are reported using `timing(_:name:label:time:parameters:)` with time parameter in seconds
    * - Fixme: ⚠️️ rename to TM...
    * - Parameters:
    *   - category: The category of the timing (utc).
    *   - name: The variable name of the timing  (utv).
    *   - label: The variable label for the timing  (utl).
    *   - time: Length of the timing (utt).
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
extension Timing {
   public var key: String { "timing" }
   public var output: [String: String] {
      var params: [String: String] = self.params
      params["utc"] = category
      params["utv"] = name
      params["utl"] = label
      params["utt"] = String(Int(time * 1000))
      return params
   }
}
