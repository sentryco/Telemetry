import Foundation

/**
 * This enum represents the different types of telemetry.
 * - Fixme: ⚠️️ Consider renaming to EndPointType or EPType for clarity.
 */
public enum TMType {
   case ga, agg(_ agg: Aggregator)
}

extension TMType {
   /**
    * This computed property provides a convenient way to get the aggregator.
    * It returns the aggregator if the TMType is .agg, otherwise it returns nil.
    */
   public var aggregator: Aggregator? {
      if case .agg(let aggregator) = self {
         return aggregator
      } else { return nil }
   }
}