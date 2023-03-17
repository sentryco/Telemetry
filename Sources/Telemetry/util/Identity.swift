import Foundation
#if os(iOS)
import UIKit
#elseif os(macOS)
import Cocoa
#endif
/**
 * - Note: IFA/IDFA -> Identifier for Advertisers
 * - Note: IFV/IDFV -> (Identifier for Vendor)
 * - Note: IDFA is shared between all apps of the system, but can only be used by ad-enabled apps that are really showing the ads to the end user. Also, the user can opt-out and choose to reset it or disable the “across system” UID, causing a new UID to be generated for each install.
 * - Note: IDFV is shared between apps from the same publisher, but is lost when the last app of the publisher is uninstalled.
 * - Note: complete solution in objc: https://gist.github.com/miguelcma/e8f291e54b025815ca46
 * - Note: objc: https://github.com/guojunliu/XYUUID and https://github.com/mushank/ZKUDID
 * - Note: Objc: https://stackoverflow.com/a/20339893/5389500 and https://developer.apple.com/forums/thread/127567
 */
class Identity {} // rename to id
/**
 * Vendor uuid
 */
extension Identity {
   /**
    * - Parameter type: - Fixme: ⚠️️
    */
   static func uniqueUserIdentifier(type: IDType) -> String {
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
 * Helper
 */
extension Identity {
   /**
    * - Remark: Changes on every simulator run etc
    * - Remark: Should persist between release app runs, but beta apps might genereate new uuid
    * - Remark: The MAC doesn't have anything equivalent to iOS's identifierForVendor or advertising Id alas.
    */
   fileprivate static var vendorID: String? {
      #if os(iOS)
      return UIDevice.current.identifierForVendor?.uuidString // UIDevice.current.identifierForVendor
      #elseif os(macOS)
      return nil
      #endif
   }
}
/**
 * Semi peristentID
 */
extension Identity {
   /**
    * - Description: This way, a UUID will be generated once when the app is launched for the first time, and then stored in NSUserDefaults to be retrieved on each subsequent app launch. Unlike advertising or vendor identifiers, these identifiers would not be shared across other apps, but for most intents and purposes, this is works just fine.
    * - Remark: Does not persist app reinstalls
    */
   fileprivate static var userDefaultID: String? {
      let userDefaults = UserDefaults.standard
      if userDefaults.object(forKey: "ApplicationIdentifier") == nil {
          let UUID = UUID().uuidString
         userDefaults.set(UUID, forKey: "ApplicationIdentifier")
          userDefaults.synchronize()
      }
      return userDefaults.value(forKey: "ApplicationIdentifier") as? String
   }
}
/**
 * Persisten id
 */
 extension Identity {
    /**
    * Creates a new unique user identifier or retrieves the last one created
    * - Description: The `PersistentID` class generates and stores a persistent ID that can be used to identify a device.
    * - Remark: Does not persist OS reset/reinstal. But will persist os updates and os transfers to new phone,
    * - Remark: as long as the bundle identifier remains the same this will persist
    * - Note: Back story on keychain not persisting between app installs for ios beta 10.3: https://stackoverflow.com/questions/41016762/how-to-generate-unique-id-of-device-for-iphone-ipad-using-objective-c/41017285#41017285
    * https://github.com/fabiocaccamo/FCUUID
    - Note: gd article: https://medium.com/@miguelcma/persistent-cross-install-device-identifier-on-ios-using-keychain-ac9e4f84870f
    - Note: Keychain example (uses 3rd party) https://stackoverflow.com/a/38745743/5389500
    - Note: And no, the key will not be synchronized to iCloud by default
    - Note: Allegedly keychain can be lost if the provisioning profile is changed: https://developer.apple.com/library/ios/documentation/IDEs/Conceptual/AppDistributionGuide/MaintainingCertificates/MaintainingCertificates.html
    - Note:
    // Fix: implement this later. keychain doesn't work with unit tests very well so userdefault is fine for now etc
    */
    fileprivate static var keychainID: String? {
       // create a keychain helper instance
       let keychain = KeychainAccess()
       // this is the key we'll use to store the uuid in the keychain
       let uuidKey = "UID" // "persistentID"
       // check if we already have a uuid stored, if so return it
       if let uuid = try? keychain.queryKeychainData(itemKey: uuidKey) {
           return uuid
       }
       // generate a new id
       /*guard */let newId = UUID().uuidString // UIDevice.current.identifierForVendor?.uuidString else { return nil }
       // store new identifier in keychain
       try? keychain.addKeychainData(itemKey: uuidKey, itemValue: newId)
       // return new id
       return newId
   }
 }
/**
 * peristence level
 */
enum IDType { //
   case vendor // Does not work on macOS at the moment
   case userdefault
   case keychain
}
