import Foundation

/**
 * `ScreenView` is a structure that represents a screen view event in the application.
 * It conforms to the `ActionKind` protocol.
 *
 * It contains the name of the screen and a dictionary of parameters associated with the screen view event.
 */
public struct ScreenView: ActionKind {
   // The name of the screen.
   public let name: String
   
   // A dictionary of parameters associated with the screen view event.
   public let params: [String: String]
   
   /**
    * This method tracks a screen view event as a page view to Google Analytics by setting the required parameters.
    * - Remark: Screen (page) views are reported using `screenView(_:parameters:)` with the name of the screen.
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

/**
 * `ScreenView` extension that provides additional functionality.
 */
extension ScreenView {
   // The key used to identify a page view event.
   public var key: String { "pageview" }
   
   /**
    * This computed property generates the output dictionary for the screen view event.
    * It includes the app identifier, screen name, and document title.
    */
   public var output: [String: String] {
      var params: [String: String] = self.params
      params["dh"] = System.appIdentifier  // Set the app identifier.
      params["dp"] = "/" + name  // Set the screen name with a leading '/'.
      params["dt"] = name  // Set the document title.
      return params
   }
}