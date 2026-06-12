import Foundation

struct HitBucket: Identifiable, Hashable {
    let id: String
    let label: String
    let count: Int
    let date: Date
}
