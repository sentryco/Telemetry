import Foundation
/**
 * Constants for Telemetry
 */
extension Telemetry {
   /**
    * Typealias for completion handler
    Æ - Parameter success: A boolean value indicating whether the operation was successful or not
    */
   public typealias Complete = (_ success: Bool) -> Void
   /**
    * Base URL for Google Analytics
    */
   internal static let baseURL: URL? = .init(string: "https://www.google-analytics.com/")
}
/**
 * Variables for Telemetry
 */
extension Telemetry {
   /**
    * Flag to anonymize user's IP
    * - Description: To ensure GDPR compliance, Telemetry requests Google Analytics to anonymize user IPs by default. Set this to false to opt-out.
    */
   public static var anonymizeIP: Bool = true
   /**
    * Google Analytics Identifier (Tracker ID)
    * - Remark: This token can be obtained from the Google Analytics entity's admin page.
    * - Remark: A valid Google Analytics tracker ID (format: UA-XXXXX-XX) must be set before reporting any events.
    */
   public static var trackerId: String = "UA-XXXXX-XX"
   /**
    * Custom dimension arguments
    * - Description: A dictionary of custom key-value pairs to be added to every query.
    * - Remark: Useful for custom dimensions (cd1, cd2...).
    * - Note: For more information on Custom Dimensions, visit https://support.google.com/analytics/answer/2709828?hl=en
    */
   public static var customDimArgs: [String: String]?
   /**
    * Identifier type
    * - Remark: Defines the type of persistence. Options are: .vendor, .userdef, .keychain
    * - Fixme: Consider renaming to currentIdentifierType or curIdType
    */
   public static var idType: IDType = .userdefault
   /**
    * Network session
    * - Remark: Consider renaming to urlSession
    */
   public static let session: URLSession = .shared
   /**
    * Telemetry type
    * - Description: Allows switching between ga-endpoint and aggregator-endpoint
    * - Fixme: Consider renaming to endPointType or EPType
    */
   public static var tmType: TMType = .ga // .agg()
}
