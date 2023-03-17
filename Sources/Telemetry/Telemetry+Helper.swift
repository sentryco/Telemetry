import Foundation
/**
 * Helper
 */
extension Telemetry {
   /**
    * - Parameters:
    *   - send: timing, exception, pageview, session, exception etc
    *   - parameters: custom params for the type
    */
   internal static func send(type: String?, parameters: [String: String], complete: @escaping Complete = defaultComplete) {
      guard let _ = trackerId else { Swift.print("No tracker ID"); return }
      var queryArgs = Self.queryArguments
      if let type = type, !type.isEmpty {
         queryArgs.updateValue(type, forKey: "t")
      }
      if let customDimensions = self.customDimensionArguments {
         queryArgs.merge(customDimensions, uniquingKeysWith: { _, new in new })
      }
      queryArgs["aip"] = anonymizeIP ? "1" : nil
      let arguments = queryArgs.combinedWith(parameters)
      guard let url = Self.getURL(with: arguments) else { return }
      let task = session.dataTask(with: url) { data, response, error in
         if let errorResponse = error?.localizedDescription {
            Swift.print("Failed to deliver GA Request. ", errorResponse)
         }
         complete()
      }
      task.resume()
   }
}
/**
 * Private helpers
 */
extension Telemetry {
   /**
    * URL query
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
   /**
    * URL
    * - Parameter parameters: - Fixme: ⚠️️ add doc
    */
   fileprivate static func getURL(with parameters: [String: String]) -> URL? {
      let characterSet = CharacterSet.urlPathAllowed
      let joined = parameters.reduce("collect?") { path, query in
         let value = query.value.addingPercentEncoding(withAllowedCharacters: characterSet)
         return String(format: "%@%@=%@&", path, query.key, value ?? "")
      }
      // Trim the trailing &
      let path = String(joined[..<joined.index(before: joined.endIndex)])
      // Make sure we generated a valid URL
      guard let baseURL: URL = baseURL else { Swift.print("baseURL error"); return nil }
      guard let url: URL = .init(string: path, relativeTo: baseURL) else {
         print("Failed to generate a valid GA url for path ", path, " relative to ", baseURL.absoluteString)
         return nil
      }
      return url
   }
}
