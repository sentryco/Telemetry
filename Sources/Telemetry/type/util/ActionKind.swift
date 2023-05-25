import Foundation
/**
 * Protocol for structs types
 * - Fixme: ⚠️️ add more doc
 * - Fixme: ⚠️️ Rename to TMActionKind? or TMAction?
 * - Fixme: ⚠️️ Probably remove params from json etc
 */
public protocol ActionKind: Codable {
   var params: [String: String] { get }
   var output: [String: String] { get }
   var key: String { get }
}
