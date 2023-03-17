import Foundation
/**
 * const
 */
extension Telemetry {
   public typealias Complete = () -> Void
   public static let defaultComplete: Complete = {}
   static let baseURL: URL? = .init(string: "https://www.google-analytics.com/")
}
/**
 * variables
 */
extension Telemetry {
   /**
    * Users IP should be anonymized
    * - Description: In order to be GDPR compliant, Telemetry will ask Google Analytics to anonymize users IP's by default. If you wish to opt-out of this you will neeed to set anonymizeIP to false.
    */
   public static var anonymizeIP = true
   /**
    * Google Analytics Identifier (Tracker ID)
    * - Remark: The token can be obtained from the admin page of the tracked Google Analytics entity.
    * - Remark: A valid Google Analytics tracker ID of form UA-XXXXX-XX must be set before reporting any events.
    */
   public static var trackerId: String?
   /**
    * Dictionary of custom key value pairs to add to every query.
    * - Remark: Use it for custom dimensions (cd1, cd2...).
    * - Note: More information on Custom Dimensions https://support.google.com/analytics/answer/2709828?hl=en
    */
   public static var customDimensionArguments: [String: String]?
   /**
    * vendor, userdef, keychain
    */
   public static var idType: IDType = .userdefault
   /**
    * network, rename to urlSession
    */
   public static let session: URLSession = URLSession.shared
}

