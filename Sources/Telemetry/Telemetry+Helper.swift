import Foundation
/**
 * Helper
 */
extension Telemetry {
   /**
    * - Parameter send: timing, exception, pageview, session, exception etc
    * - Parameter parameters: custom params for the type
    */
   internal static func send(type: String?, parameters: [String: String]) {
      guard let _ = trackerId else { Swift.print("No tracker ID"); return }
      var queryArguments = Self.queryArguments
      if let type = type, !type.isEmpty {
         queryArguments.updateValue(type, forKey: "t")
      }
      if let customDimensions = self.customDimensionArguments {
         queryArguments.merge(customDimensions, uniquingKeysWith: { _, new in new })
      }
      queryArguments["aip"] = anonymizeIP ? "1" : nil
      let arguments = queryArguments.combinedWith(parameters)
      guard let url = Self.generateUrl(with: arguments) else { return }
      let task = session.dataTask(with: url) { _, _, error in
         if let errorResponse = error?.localizedDescription {
            Swift.print("Failed to deliver GA Request. ", errorResponse)
         }
      }
      task.resume()
   }
   /**
    * url query
    */
   fileprivate static var queryArguments: [String: String] {
      guard let trackerId = Self.trackerId else { return [:] }
      return [
         "tid": trackerId,
         "aid": System.appIdentifier,
         "cid": Identity.uniqueUserIdentifier(type: idType),
         "an": System.appName,
         "av": System.formattedVersion,
         "ua": System.userAgent,
         "ul": System.userLanguage,
         "sr": System.screenResolution,
         "v": "1", // Fix: what is this?
      ]
   }
}

