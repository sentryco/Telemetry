import Foundation
#if os(iOS)
import UIKit
#elseif os(macOS)
import Cocoa
#endif
/**
 *  - Fixme: ⚠️️ rename to sys?
 */
class System {
   /**
    * app name
    */
   internal static let appName: String = {
      Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String ?? "(not set)"
   }()
   /**
    * app id
    */
   internal static let appIdentifier: String = {
      Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") as? String ?? "(not set)"
   }()
   /**
    * app ver
    */
   internal static let appVersion: String = {
      Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "(not set)"
   }()
   /**
    * app build
    */
   internal static let appBuild: String = {
      Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String ?? "(not set)"
   }()
   /**
    * ver and build
    */
   internal static let formattedVersion: String = {
      "\(appVersion) (\(appBuild))"
   }()
   /**
    * lang
    * - Fixme: ⚠️️ En-us etc?
    */
   internal static let userLanguage: String = {
      guard let locale = Locale.preferredLanguages.first, locale.count > 0 else {
         return "(not set)"
      }
      return locale
   }()
   /**
    * user screen resolution
    */
   internal static let screenResolution: String = {
      #if os(iOS)
      let size = UIScreen.main.nativeBounds.size
      #elseif os(macOS)
      let size = NSScreen.main?.frame.size ?? .zero
      #endif
      return "\(size.width)x\(size.height)"
   }()
   /**
    * userAgent
    */
   internal static let userAgent: String = {
      #if os(macOS)
      let osVersion = ProcessInfo.processInfo.operatingSystemVersionString
      let versionString = osVersion.replacingOccurrences(of: ".", with: "_")
      let fallbackAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X \(versionString)) AppleWebKit/603.2.4 (KHTML, like Gecko) \(appName)/\(appVersion)" // swiftlint:disable:this line_length
      #else
      let currentDevice = UIDevice.current
      let osVersion = currentDevice.systemVersion.replacingOccurrences(of: ".", with: "_")
      let fallbackAgent = "Mozilla/5.0 (\(currentDevice.model); CPU iPhone OS \(osVersion) like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Mobile/13T534YI" // swiftlint:disable:this line_length
      #endif

      #if SUPPORTS_WEBKIT
      // must be captured in instance variable to avoid invalidation
      webViewForUserAgentDetection = WKWebView() /
      webViewForUserAgentDetection?.loadHTMLString("<html></html>", baseURL: nil)
      webViewForUserAgentDetection?.evaluateJavaScript("navigator.userAgent") { [weak self] result, _ in
         guard let self = self else { return }
         if let agent = result as? String {
            self.userAgent = agent
         }
         self.webViewForUserAgentDetection = nil
      }
      return fallbackAgent
      #else
      return fallbackAgent
      #endif
   }()
}
