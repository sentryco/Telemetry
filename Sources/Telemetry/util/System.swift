import Foundation
#if os(iOS)
import UIKit
#elseif os(macOS)
import Cocoa
#endif
/**
 * System class provides access to various system-level properties.
 * - Fixme: Consider moving this to a Bundle extension for better organization.
 */
internal class System {
   /**
    * Provides the name of the application as defined in the Bundle.
    */
   internal static let appName: String = {
      Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String ?? "(not set)"
   }()
   /**
    * Provides the unique identifier of the application as defined in the Bundle.
    */
   internal static let appIdentifier: String = {
      Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") as? String ?? "(not set)"
   }()
   /**
    * Provides the version of the application as defined in the Bundle.
    */
   internal static let appVersion: String = {
      Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "(not set)"
   }()
   /**
    * Provides the build number of the application as defined in the Bundle.
    */
   internal static let appBuild: String = {
      Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String ?? "(not set)"
   }()
   /**
    * Provides a formatted string containing both the version and build number of the application.
    */
   internal static let formattedVersion: String = {
      "\(appVersion) (\(appBuild))"
   }()
   /**
    * Provides the preferred language of the user as defined in the system settings.
    * TODO: Consider handling different language formats (e.g., en-US, en-GB).
    */
   internal static let userLanguage: String = {
      guard let locale = Locale.preferredLanguages.first, !locale.isEmpty else {
         return "(not set)"
      }
      return locale
   }()
   /**
    * Provides the screen resolution of the user's device.
    */
   internal static let screenResolution: String = {
      // Check if the operating system is iOS
      #if os(iOS)
      // Get the size of the screen in native points
      let size = UIScreen.main.nativeBounds.size
      // If the operating system is macOS
      #elseif os(macOS)
      // Get the size of the main screen, or use zero size if the main screen is not available
      let size = NSScreen.main?.frame.size ?? .zero
      #endif
      // Return the screen resolution as a string in the format "width x height"
      return "\(size.width)x\(size.height)"
   }()
   /**
    * Provides the user agent string for the current device and OS.
    * This is useful for identifying the device and OS in web requests.
    */
   internal static let userAgent: String = {
    // Check if the OS is macOS
    #if os(macOS)
      // Get the OS version
      let osVersion = ProcessInfo.processInfo.operatingSystemVersionString
      // Replace "." with "_" in the version string
      let versionString = osVersion.replacingOccurrences(of: ".", with: "_")
      // Define the user agent for macOS
      let fallbackAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X \(versionString)) AppleWebKit/603.2.4 (KHTML, like Gecko) \(appName)/\(appVersion)" // swiftlint:disable:this line_length
      #else
      // If not macOS, then it's iOS. Get the device details
      let currentDevice = UIDevice.current
      // Get the OS version
      let osVersion = currentDevice.systemVersion.replacingOccurrences(of: ".", with: "_")
      // Define the user agent for iOS
      let fallbackAgent = "Mozilla/5.0 (\(currentDevice.model); CPU iPhone OS \(osVersion) like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Mobile/13T534YI" // swiftlint:disable:this line_length
      #endif

      // Check if the app supports WebKit
      #if SUPPORTS_WEBKIT
      // Create a WKWebView instance
      webViewForUserAgentDetection = WKWebView() /
      // Load a blank HTML string
      webViewForUserAgentDetection?.loadHTMLString("<html></html>", baseURL: nil)
      // Evaluate JavaScript to get the user agent
      webViewForUserAgentDetection?.evaluateJavaScript("navigator.userAgent") { [weak self] result, _ in
         // Ensure self is still available
         guard let self = self else { return }
         // If the result is a string, set it as the user agent
         if let agent = result as? String {
               self.userAgent = agent
         }
         // Clear the WKWebView instance
         self.webViewForUserAgentDetection = nil
      }
      // Return the user agent
      return fallbackAgent
      #else
      // If not supporting WebKit, return the fallback user agent
      return fallbackAgent
      #endif
   }()
}