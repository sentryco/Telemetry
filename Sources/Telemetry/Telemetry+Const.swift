import Foundation
/**
 * const
 */
extension Telemetry {
   static let baseURL: URL = .init(string: "https://www.google-analytics.com/")!
}
/**
 * variables
 */
extension Telemetry {
   /// Users IP should be anonymized
   // In order to be GDPR compliant, Telemetry will ask Google Analytics to anonymize users IP's by default. If you wish to opt-out of this you will neeed to set anonymizeIP to false.
   static var anonymizeIP = true
   /// a Google Analytics Identifier (Tracker ID).
   // The token can be obtained from the admin page of the tracked Google Analytics entity.
   // A valid Google Analytics tracker ID of form UA-XXXXX-XX.
   // - Note: A valid Google Analytics tracker ID must be set before reporting any events.
   static var trackerId: String?
   /// Dictionary of custom key value pairs to add to every query.
   /// Use it for custom dimensions (cd1, cd2...).
   /// See [Google Analytics Custom Dimensions](https://support.google.com/analytics/answer/2709828?hl=en) for
   /// more information on Custom Dimensions
   static var customDimensionArguments: [String: String]?
   // vendor, userdef, keychain
   static var idType: IDType = .userdefault
   // network, rename to urlSession
   static let session: URLSession = URLSession.shared
}

