import Foundation

struct HitRecord: Codable, Identifiable, Hashable {
    let id: UUID
    let date: Date

    init(id: UUID = UUID(), date: Date = Date()) {
        self.id = id
        self.date = date
    }
}
