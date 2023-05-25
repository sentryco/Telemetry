import Foundation

extension Dictionary {
   /**
    * - Fixme: ⚠️️ add doc
    * - Parameter other: - Fixme: ⚠️️ add doc
    * - Returns: - Fixme: ⚠️️ add doc
    */
   func combinedWith(_ other: [Key: Value]) -> [Key: Value] {
      var dict = self
      for (key, value) in other {
         dict[key] = value
      }
      return dict
   }
}
