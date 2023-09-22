import Foundation

extension Dictionary {
   /**
    * - Fixme: ⚠️️ We could also use reduce like shown here: https://stackoverflow.com/a/75548503/5389500
    * - Fixme: ⚠️️ We can even add it to a + operator like: `func + <Self>(a: Self, b: Self) -> Self {...}`
    * Combines the current dictionary with another dictionary.
    * - Parameter other: The dictionary to be combined with.
    * - Returns: A new dictionary that contains the combined key-value pairs.
    */
   func combinedWith(_ other: [Key: Value]) -> [Key: Value] {
      var dict = self // Initializes a new dictionary with the current dictionary
      for (key, value) in other { // Loops through the key-value pairs in the other dictionary
         dict[key] = value // Adds the key-value pair to the new dictionary
      }
      return dict // Returns the updated dictionary
   }
}
