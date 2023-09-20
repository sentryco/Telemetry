import Foundation
import FileSugar
import JSONSugar

/**
 * Local aggregator
 * - Remark: This can be used to save logs etc.
 * - Remark: For testing, it's better to use Console output. See Logger repo for code etc.
 * - Fixme: ⚠️️ We could also use structured json, and store everything in one array etc?
 * - Fixme: ⚠️️ Add timestamping?
 * - Fixme: ⚠️️ Add more advanced sessions, with uuid and timestamp etc.
 * - Fixme: ⚠️️ Add support for storing meta data etc. Might require sqlite etc. since json file will get big and cluttered etc.
 * - Fixme: ⚠️️ Rename to TMAggregator?
 */
public class Aggregator: Codable {
   // File path where the data will be stored
   public var filePath: String
   // Array of events
   public var events: [Event]
   // Array of sessions
   public var sessions: [Session]
   // Array of exceptions
   public var exceptions: [Exception]
   // Array of screen views
   public var screenViews: [ScreenView]
   // Array of timings
   public var timings: [Timing]
   
   // Initializer for the Aggregator class
   init(filePath: String = tempFilePath, events: [Event] = [], sessions: [Session] = [], exceptions: [Exception] = [], screenViews: [ScreenView] = [], timings: [Timing] = []) {
      self.filePath = filePath
      self.events = events
      self.sessions = sessions
      self.exceptions = exceptions
      self.screenViews = screenViews
      self.timings = timings
   }
}

// Extension for the Aggregator class to add actions
extension Aggregator {
   /**
    * Add action
    * - Fixme: ⚠️️ Rename to send? or noterize or something?
    */
   public func append(action: ActionKind) throws {
      // Depending on the type of action, append it to the corresponding array
      switch action {
      case let event as Event: events.append(event)
      case let session as Session: sessions.append(session)
      case let exception as Exception: exceptions.append(exception)
      case let screenView as ScreenView: screenViews.append(screenView)
      case let timing as Timing: timings.append(timing)
      default: Swift.print("⚠️️ Not supported")
      }
      // Save the current state after each call
      try persist()
   }
}

// Extension for the Aggregator class to handle persistence
extension Aggregator {
   /**
    * - Remark: If the app is sandboxed, this folder is somewhere else. Print the path in your app to get absolute path etc.
    * - Remark: Something like this path should also work: `NSTemporaryDirectory()).appendingPathComponent("store.json").path`
    */
   public static let tempFilePath: String = "\(NSHomeDirectory())/store.json" // or use tempfolder etc
   
   /**
    * Save current state to a file
    * - Fixme: ⚠️️ Add sqlite later, or coredata
    */
   public func persist() throws {
      // Encode the current state to Data
      let data: Data = try self.encode()
      // Convert the data to a string
      guard let content: String = .init(data: data, encoding: .utf8) else { throw NSError(domain: "err str", code: 0) }
      // Write the string to a file
      FileModifier.write(filePath, content: content) // Create new file if non exists
   }
   
   /**
    * Load previously saved aggregator
    * - Parameters:
    *   - filePath: Path to store file
    *   - reset: Reset store file or not
    */
   public static func initiate(filePath: String = tempFilePath, reset: Bool = false) throws -> Aggregator {
      // If reset is true, remove the existing file
      if reset { try FileManager().removeItem(atPath: filePath) }
      // If the file exists, load the content and decode it to an Aggregator
      if FileManager().fileExists(atPath: filePath) {
         let content: String = try .init(contentsOfFile: filePath, encoding: .utf8)
         return try content.decode()
      } else {
         // If the file doesn't exist, return a new Aggregator
         return .init(filePath: filePath)
      }
   }
}

// Extension for the Aggregator class to handle stats
extension Aggregator {
   /**
    * Read Aggregator stats:
    * - Fixme: ⚠️️ Add exceptions-fatal: 4 (only errors) etc?
    */
   public var stats: String {
      // Initialize an empty string for the output
      var output: String = ""
      // If there are any events, add the count to the output
      if !events.isEmpty { output += "💃 Events: \(events.count)\n" }
      // If there are any sessions, add the count to the output
      if !sessions.isEmpty { output += "✍️ Sessions: \(sessions.count)\n" }
      // If there are any exceptions, add the count to the output
      if !exceptions.isEmpty { output += "🐛 Exceptions: \(exceptions.count)\n" } // (warnings and errors)
      // If there are any screen views, add the count to the output
      if !screenViews.isEmpty { output += "📺 ScreenViews: \(screenViews.count)\n" }
      // If there are any timings, add the count to the output
      if !timings.isEmpty { output += "🕑 Timings: \(timings.count)\n" }
      // If the output is not empty, remove the last line break
      if !output.isEmpty { output = String(output.dropLast()) } // remove last linebreak
      // Return the output
      return output
   }
}