import Foundation

/**
 * `ActionKind` is a protocol that defines a common interface for action types in the telemetry system.
 * It is Codable, meaning instances of types conforming to this protocol can be encoded to or decoded from external representations like JSON.
 *
 * Types conforming to `ActionKind` must provide:
 * - `params`: a dictionary of parameters associated with the action. The keys and values are both Strings.
 * - `output`: a dictionary representing the output of the action. Again, the keys and values are both Strings.
 * - `key`: a unique String key identifying the action.
 *
 * ## Future Improvements
 * - Consider renaming to `TMActionKind` or `TMAction` for better clarity and consistency with other naming conventions in the codebase.
 * - Consider removing `params` from JSON representations if they are not necessary.
 */
public protocol ActionKind: Codable {
   var params: [String: String] { get }
   var output: [String: String] { get }
   var key: String { get }
}