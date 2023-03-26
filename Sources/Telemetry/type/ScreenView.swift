import Foundation

public struct ScreenView: ActionKind {
   public let name: String
   public let params: [String: String]
   /**
    * Tracks a screen view event as page view to Google Analytics by setting the required parameters
    * - Remark: - Screen (page) views are reported using `screenView(_:parameters:)` with the name of the screen.
    * - Remark: `dh` - hostname as appIdentifier and `dp` - path as screen name with leading `/`
    * - Remark: and optional `dt` - document title as screen name pageview parameters for valid hit request.
    * - Parameters:
    *   - name: The name of the screen. Make sure it does not have spaces, use .replacingOccurrences(of: " ", with: "") etc
    *   - params: A dictionary of additional parameters for the event.
    */
   public init(name: String, params: [String: String] = .init()) {
      self.name = name
      self.params = params
   }
}
extension ScreenView {
   public var key: String { "pageview" }
   public var output: [String: String] {
      var params: [String: String] = self.params
      params["dh"] = System.appIdentifier
      params["dp"] = "/" + name
      params["dt"] = name
      return params
   }
}
