import Foundation
#if os(iOS)
import UIKit
#elseif os(macOS)
import Cocoa
#endif
/**
 * - Remark: IFA/IDFA -> Identifier for Advertisers
 * - Remark: IFV/IDFV -> (Identifier for Vendor)
 * - Remark: IDFA is shared between all apps of the system, but can only be used by ad-enabled apps that are really showing the ads to the end user. Also, the user can opt-out and choose to reset it or disable the “across system” UID, causing a new UID to be generated for each install.
 * - Remark: IDFV is shared between apps from the same publisher, but is lost when the last app of the publisher is uninstalled.
 * - Note: complete solution in objc: https://gist.github.com/miguelcma/e8f291e54b025815ca46
 * - Note: objc: https://github.com/guojunliu/XYUUID and https://github.com/mushank/ZKUDID
 * - Note: Objc: https://stackoverflow.com/a/20339893/5389500 and https://developer.apple.com/forums/thread/127567
 * - Fixme: ⚠️️ Rename to id?
 */
class Identity {}

extension Identity {
   /**
    * - Parameter type: - Fixme: ⚠️️ doc
    */
   internal static func uniqueUserIdentifier(type: IDType) -> String {
      let id: String? = {
         switch type {
         case .vendor: return vendorID // persistent between runs (in most cases)
         case .userdefault: return userDefaultID // persistent between runs
         case .keychain: return keychainID // persistent between installs
         }
      }()
      return id ?? UUID().uuidString
   }
}
/**
 * UIDevice id
 */
extension Identity {
   /**
    * - Remark: Changes on every simulator run etc (allegedly)
    * - Remark: Should persist between release app runs, but beta apps might genereate new uuid
    * - Remark: The MAC doesn't have anything equivalent to iOS's identifierForVendor or advertising Id alas.
    */
   fileprivate static var vendorID: String? {
      #if os(iOS)
      return UIDevice.current.identifierForVendor?.uuidString // UIDevice.current.identifierForVendor
      #elseif os(macOS)
      let dev = IOServiceMatching("IOPlatformExpertDevice")
      let platformExpert: io_service_t = IOServiceGetMatchingService(kIOMainPortDefault/* ⚠️️ was kIOMasterPortDefault*/, dev)
      let serialNumberAsCFString = IORegistryEntryCreateCFProperty(platformExpert, kIOPlatformUUIDKey as CFString, kCFAllocatorDefault, 0)
      IOObjectRelease(platformExpert)
      let ser: CFTypeRef = serialNumberAsCFString?.takeUnretainedValue() as CFTypeRef
      if let result = ser as? String { return result }
      return nil
      #else
      Swift.print("OS not supported")
      return nil
      #endif
   }
}
/**
 * UserDefault - (Semi peristentID)
 */
extension Identity {
   /**
    * Stores a random UUID that uniquely identifies the user/install using the native UserDefaults . standard.
    * - Remark: The user identifier may be lost if the UserDefaults are cleared or altered in any other way, a new  unique identifier will be created in it's place
    * - Remark: This way, a UUID will be generated once when the app is launched for the first time, and then stored in NSUserDefaults to be retrieved on each subsequent app launch.
    * - Remark: Unlike advertising or vendor identifiers, these identifiers would not be shared across other apps, but for most intents and purposes, this is works just fine.
    * - Remark: Does not persist app reinstalls
    * - Remark: Persist between consol-unit-test runs
    */
   fileprivate static var userDefaultID: String? {
      let userDefaults = UserDefaults.standard
      if userDefaults.object(forKey: "AppID") == nil {
         let id = Self.vendorID ?? UUID().uuidString
         userDefaults.set(id, forKey: "AppID")
         userDefaults.synchronize()
      }
      return userDefaults.value(forKey: "AppID") as? String
   }
}
/**
 * Keychain - (Persisten id)
 */
extension Identity {
   /**
    * Creates a new unique user identifier or retrieves the last one created
    * - Description: The `PersistentID` class generates and stores a persistent ID that can be used to identify a device.
    * - Remark: Does not persist OS reset/reinstal. But will persist os updates and os transfers to new phone,
    * - Remark: As long as the bundle identifier remains the same this will persist
    * - Remark: And no, the key will not be synchronized to iCloud by default
    * - Remark: keychain works with consol-unit-tests
    * - Note: Back story on keychain not persisting between app installs for ios beta 10.3: https://stackoverflow.com/questions/41016762/how-to-generate-unique-id-of-device-for-iphone-ipad-using-objective-c/41017285#41017285
    * - Note: https://github.com/fabiocaccamo/FCUUID
    * - Note: gd article: https://medium.com/@miguelcma/persistent-cross-install-device-identifier-on-ios-using-keychain-ac9e4f84870f
    * - Note: Keychain example (uses 3rd party) https://stackoverflow.com/a/38745743/5389500
    * - Note: Allegedly keychain can be lost if the provisioning profile is changed: https://developer.apple.com/library/ios/documentation/IDEs/Conceptual/AppDistributionGuide/MaintainingCertificates/MaintainingCertificates.html
    */
   fileprivate static var keychainID: String? {
      let uuidKey = "persistentAppID" // This is the key we'll use to store the uuid in the keychain
      if let id = try? Keychain.get(key: uuidKey) { // Check if we already have a uuid stored, if so return it
         return id
      }
      let id = Self.vendorID ?? UUID().uuidString // Generate a new id // UIDevice.current.identifierForVendor?.uuidString else { return nil }
      try? Keychain.set(key: uuidKey, value: id) // Store new identifier in keychain
      return id  // Return new id
   }
}
/**
 * Peristence level
 */
public enum IDType { //
   case vendor // Does not work on macOS
   case userdefault
   case keychain
}
