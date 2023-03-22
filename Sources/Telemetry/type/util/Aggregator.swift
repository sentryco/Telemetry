import Foundation
import FileSugar
import JSONSugar
/**
 * Local aggregator (for testing, useful for UITests etc and testing beore setting up GA etc)
 * - Fixme: ⚠️️ we could also use structured json, and store everything in one array etc?
 * - Fixme: ⚠️️ add timestamping?
 * - Fixme: ⚠️️ add more advance sessions, with uuid and timestamp etc
 * - Fixme: ⚠️️ add support for storing meta data etc. Might require sqlite etc. since json file will get big and cluttered etc
 */
public class Aggregator: Codable {
   public var filePath: String
   public var events: [Event]
   public var sessions: [Session]
   public var exceptions: [Exception]
   public var screenViews: [ScreenView]
   public var timings: [Timing]
   init(filePath: String = tempFilePath, events: [Event] = [], sessions: [Session] = [], exceptions: [Exception] = [], screenViews: [ScreenView] = [], timings: [Timing] = []) {
      self.filePath = filePath
      self.events = events
      self.sessions = sessions
      self.exceptions = exceptions
      self.screenViews = screenViews
      self.timings = timings
   }
}
extension Aggregator {
   /**
    * Add action
    * - Fixme: ⚠️️ rename to send?
    */
   public func append(action: ActionKind) throws {
//      Swift.print("append: \(action)")
      switch action {
      case let event as Event: events.append(event)
      case let session as Session: sessions.append(session)
      case let exception as Exception: exceptions.append(exception)
      case let screenView as ScreenView: screenViews.append(screenView)
      case let timing as Timing: timings.append(timing)
      default: Swift.print("not supported")
      }
      try persist() // (save on each call)
   }
}
/**
 * Persistence
 */
extension Aggregator {
   public static let tempFilePath: String = "\(NSHomeDirectory())/store.json" // or use tempfolder etc
   /**
    * Save current state to a file
    * - Fixme: ⚠️️ (add sqlite later, or coredata)
    */
   public func persist() throws {
      let data: Data = try self.encode()
      guard let content: String = .init(data: data, encoding: .utf8) else { throw NSError(domain: "err str", code: 0) }
      FileModifier.write(filePath, content: content) // Create new file if non exists
   }
   /**
    * Load previouse saved aggregator
    * - Parameters:
    *   - filePath: path to store file
    *   - reset: reset store file or not
    */
   public static func initiate(filePath: String = tempFilePath, reset: Bool = false) throws -> Aggregator {
      if reset { try FileManager().removeItem(atPath: filePath) }
      if FileManager().fileExists(atPath: filePath) {
         let content: String = try .init(contentsOfFile: filePath, encoding: .utf8)
         return try content.decode()
      } else {
         return .init(filePath: filePath)
      }
   }
}
/**
 * Stats
 */
extension Aggregator {
   /**
    * Read Aggregator stats:
    * - Fixme: ⚠️️ add exceptions-fatal: 4 (only errors) etc?
    */
   public var stats: String {
      var output: String = ""
      if !events.isEmpty { output += "💃 Events: \(events.count)\n" }
      if !sessions.isEmpty { output += "✍️ Sessions: \(sessions.count)\n" }
      if !exceptions.isEmpty { output += "🐛 Exceptions: \(exceptions.count)\n" } // (warnings and errors)
      if !screenViews.isEmpty { output += "📺 ScreenViews: \(screenViews.count)\n" }
      if !timings.isEmpty { output += "🕑 Timings: \(timings.count)\n" }
      if !output.isEmpty { output = String(output.dropLast()) } // remove last linebreak
      return output
   }
}
