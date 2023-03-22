import Foundation

public enum TMType {
   case ga, agg(_ agg: Aggregator)
}
extension TMType {
   /**
    * Convenient getter for aggregator (since its stored in the type)
    */
   public var aggregator: Aggregator? {
      if case .agg(let aggregator) = self {
         return aggregator
      } else { return nil }
   }
}
