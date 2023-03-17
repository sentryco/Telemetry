import Foundation
/**
 * Getter
 */
extension Telemetry {
   /**
    * url
    */
   internal static func generateUrl(with parameters: [String: String]) -> URL? {
      let characterSet = CharacterSet.urlPathAllowed
      let joined = parameters.reduce("collect?") { path, query in
         let value = query.value.addingPercentEncoding(withAllowedCharacters: characterSet)
         return String(format: "%@%@=%@&", path, query.key, value ?? "")
      }
      // Trim the trailing &
      let path = String(joined[..<joined.index(before: joined.endIndex)])
      // Make sure we generated a valid URL
      guard let url = URL(string: path, relativeTo: baseURL) else {
         print("GoogleReporter failed to generate a valid GA url for path ",
               path, " relative to ", baseURL.absoluteString)
         return nil
      }
      return url
   }
}


