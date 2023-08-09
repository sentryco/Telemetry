import Foundation

extension Dictionary {
   /**
    * - Fixme: ⚠️️ Add doc
    * - Fixme: ⚠️️ We could also use reduce like shown here: https://stackoverflow.com/a/75548503/5389500
    * - Fixme: ⚠️️ We can even add it to a + operator like: `func + <Self>(a: Self, b: Self) -> Self {...}`
    * - Parameter other: - Fixme: ⚠️️ Add doc
    * - Returns: - Fixme: ⚠️️ Add doc
    */
   func combinedWith(_ other: [Key: Value]) -> [Key: Value] {
      var dict = self
      for (key, value) in other {
         dict[key] = value
      }
      return dict
   }
}
