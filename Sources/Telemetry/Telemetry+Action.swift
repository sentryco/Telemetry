import Foundation

extension Telemetry {
   /**
    * Action call that can take type
    * - Remark: This class supports tracking of sessions, screen/page views, events, and timings with optional custom dimension parameters.
    * - Remark: For a comprehensive list of all the supported parameters, please refer to the [Google Analytics parameter reference](https://developers.google.com/analytics/devguides/collection/protocol/v1/parameters)
    * - Fixme: ⚠️️ Add an example here
    * - Parameters:
    *   - action: The action to be performed - Fixme: ⚠️️ Add more documentation here
    *   - complete: Use complete only for the GA type
    */
   public static func action(_ action: ActionKind, complete: Complete? = nil) {
      // Check if the telemetry type is Google Analytics
      if case TMType.ga = tmType {
         // Send the action to Google Analytics
         send(type: action.key, parameters: action.output, complete: complete)
      } else if case TMType.agg(let agg) = tmType {
         // If the telemetry type is not Google Analytics, append the action to the aggregator
         do { 
               try agg.append(action: action) 
         }
         // Catch and print any errors that occur when appending the action
         catch { Swift.print("Error: \(error.localizedDescription)") }
      }
   }
}
/**
 * Helper
 */
extension Telemetry {
    /**
    * - Remark: If you encounter: swift a server with the specified hostname could not be found. Ensure to enable outgoing network in sandbox: https://stackoverflow.com/a/57292829/5389500
    * - Parameters:
    *   - parameters: Custom parameters for the type
    *   - type: The type of telemetry data (timing, exception, pageview, session, exception etc)
    *   - complete: Callback with success or failure. Useful for Unit-testing when dealing with asynchronous code etc
    */
   internal static func send(type: String?, parameters: [String: String], complete: Complete? = nil) {
      // Initialize query arguments with metadata
      var queryArgs = Self.queryArgs 
      // If type is not nil and not empty, add it to the query arguments
      if let type: String = type, !type.isEmpty {
         queryArgs.updateValue(type, forKey: "t")
      }
      // If custom dimensions are not nil, merge them into the query arguments
      if let customDim: [String: String] = self.customDimArgs {
         queryArgs.merge(customDim) { _, new in new }
      }
      // Update the "aip" key in the query arguments based on the anonymizeIP flag
      queryArgs["aip"] = anonymizeIP ? "1" : nil
      // Combine the query arguments with the parameters
      let arguments: [String: String] = queryArgs.combinedWith(parameters)
      // Generate a URL with the arguments, return if URL generation fails
      guard let url: URL = Self.getURL(with: arguments) else { return }
      // Create a data task with the URL
      let task = session.dataTask(with: url) { _, _, error in
         // If there is an error, print it and call the completion handler with false
         if let errorResponse = error?.localizedDescription {
            Swift.print("⚠️️ Failed to deliver GA Request. ", errorResponse)
            complete?(false)
         }
         // If there is no error, call the completion handler with true
         complete?(true)
      }
      // Start the data task
      task.resume()
   }
}
/**
 * Private helpers
 */
extension Telemetry {
   /**
    * URL query (Meta data)
    * - Remark: This dictionary contains the metadata for the URL query
    */
   fileprivate static var queryArgs: [String: String] {
      [
         "tid": trackerId, // GA tracker id
         "aid": System.appIdentifier, // App id
         "cid": Identity.uniqueUserIdentifier(type: idType), // User id
         "an": System.appName, // App name
         "av": System.formattedVersion, // App version and build
         "ua": System.userAgent, // Website meta data
         "ul": System.userLanguage, // Device language
         "sr": System.screenResolution, // Size of device screen
         "v": "1" // - Fixme: ⚠️️ What is this?
      ]
   }
   /**
    * URL
    * - Parameter parameters: Parameters to convert into a URL request
    * - Remark: This function generates a URL from the given parameters
    */
   fileprivate static func getURL(with parameters: [String: String]) -> URL? {
       // Define the character set for URL path
      let characterSet = CharacterSet.urlPathAllowed
      // Join the parameters into a string, encoding the values for URL
      let joined: String = parameters.reduce("collect?") { path, query in
         // Encode the value of each parameter
         let value = query.value.addingPercentEncoding(withAllowedCharacters: characterSet)
         // Return the path with the key-value pair appended
         return .init(format: "%@%@=%@&", path, query.key, value ?? "")
      }
      // Trim the trailing '&' from the joined string
      let path: String = .init(joined[..<joined.index(before: joined.endIndex)])
      // Check if the base URL is valid
      guard let baseURL: URL = baseURL else { Swift.print("baseURL error"); return nil }
      // Generate the final URL relative to the base URL
      guard let url: URL = .init(string: path, relativeTo: baseURL) else {
         Swift.print("Failed to generate a valid GA url for path ", path, " relative to ", baseURL.absoluteString)
         return nil
      }
      // Return the final URL
      return url
   }
}
