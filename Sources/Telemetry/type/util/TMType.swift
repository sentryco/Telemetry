import Foundation

/**
 * The `TMType` enum represents the different types of telemetry.
 * - Note: Consider renaming to `EndPointType` or `EPType` for clarity.
 * The enum has two cases:
 * - `ga`: The Google Analytics telemetry type.
 * - `agg`: An aggregated telemetry type with a specified aggregator.
 */
public enum TMType {
   case ga // The Google Analytics telemetry type
   case agg(_ agg: Aggregator) // An aggregated telemetry type with a specified aggregator
}
extension TMType {
   /**
    * This computed property provides a convenient way to get the aggregator.
    * It returns the aggregator if the TMType is .agg, otherwise it returns nil.
    */
   public var aggregator: Aggregator? {
      if case .agg(let aggregator) = self { // Checks if the telemetry type is an aggregated type
         return aggregator // Returns the aggregator if the telemetry type is an aggregated type
      } else { return nil } // Returns nil if the telemetry type is not an aggregated type
   }
}
