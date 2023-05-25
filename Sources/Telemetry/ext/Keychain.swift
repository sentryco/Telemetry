import Foundation
/**
 * A simple getter and setter wrapper for keychain
 * - Note: From here: https://stackoverflow.com/a/51642962/5389500
 * - Fixme: ⚠️️ Add examples
 */
internal class Keychain {
   /**
    * Set value for key in keychain
    * - Parameters:
    *   - key: - Fixme: ⚠️️ add doc
    *   - value: - Fixme: ⚠️️ add doc
    */
   internal static func set(key: String, value: String) throws {
      guard let valueData = value.data(using: .utf8) else {
         Swift.print("Keychain: Unable to store data, invalid input - key: \(key), value: \(value)")
         return
      }
      do { // Delete old value if stored first
         try delete(itemKey: key)
      } catch {
         Swift.print("Keychain: nothing to delete...")
      }
      let queryAdd: [String: AnyObject] = [
         kSecClass as String: kSecClassGenericPassword,
         kSecAttrAccount as String: key as AnyObject,
         kSecValueData as String: valueData as AnyObject,
         kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
      ]
      let resultCode: OSStatus = SecItemAdd(queryAdd as CFDictionary, nil)
      if resultCode != 0 {
         print("Keychain: value not added - Error: \(resultCode)")
      } else {
         print("Keychain: value added successfully")
      }
   }
   /**
    * Get value from keychain
    */
   internal static func get(key: String) throws -> String? {
      let queryLoad: [String: AnyObject] = [
         kSecClass as String: kSecClassGenericPassword,
         kSecAttrAccount as String: key as AnyObject,
         kSecReturnData as String: kCFBooleanTrue,
         kSecMatchLimit as String: kSecMatchLimitOne
      ]
      var result: AnyObject?
      let resultCodeLoad = withUnsafeMutablePointer(to: &result) {
         SecItemCopyMatching(queryLoad as CFDictionary, UnsafeMutablePointer($0))
      }
      if resultCodeLoad != 0 {
         print("Keychain: unable to load data - \(resultCodeLoad)")
         return nil
      }
      guard let resultVal = result as? NSData, let keyValue = NSString(data: resultVal as Data, encoding: String.Encoding.utf8.rawValue) as String? else {
         print("Keychain: error parsing keychain result - \(resultCodeLoad)")
         return nil
      }
      return keyValue
   }
}
/**
 * Private helper
 */
extension Keychain {
   /**
    * Delete
    */
   fileprivate static func delete(itemKey: String) throws {
      let queryDelete: [String: AnyObject] = [
         kSecClass as String: kSecClassGenericPassword,
         kSecAttrAccount as String: itemKey as AnyObject
      ]
      let resultCodeDelete = SecItemDelete(queryDelete as CFDictionary)
      if resultCodeDelete != 0 {
         print("Keychain: unable to delete from keychain: \(resultCodeDelete)")
      } else {
         print("Keychain: successfully deleted item")
      }
   }
}
