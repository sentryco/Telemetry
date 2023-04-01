import Foundation

public struct Event: ActionKind {
   public let category: String
   public let action: String
   public let label: String
   public let params: [String: String]
   /**
    * Tracks an event to Google Analytics.
    * - Remark: Generic events are reported using `event(_:action:label:parameters:)`.
    * - Fixme: ⚠️️ rename to TMEvent
    * - Parameters:
    *   - category: The category of the event (ec).
    *   - action: The action of the event (ea).
    *   - label: The label of the event (el).
    *   - params: A dictionary of additional parameters for the event.
    */
   public init(category: String, action: String, label: String = "", params: [String: String] = .init()) {
      self.category = category
      self.action = action
      self.label = label
      self.params = params
   }
}
extension Event {
   public var key: String { "event" }
   public var output: [String: String] {
      var params: [String: String] = self.params
      params["ec"] = category
      params["ea"] = action
      params["el"] = label
      return params
   }
}
