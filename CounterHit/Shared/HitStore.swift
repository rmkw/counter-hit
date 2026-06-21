import Foundation
import WidgetKit

final class HitStore {
    static let shared = HitStore()

    private let storageKey = "counter-hit.records"

    private var defaults: UserDefaults {
        HitDefaults.shared
    }

    init() {
        HitDefaults.migrateStandardValueIfNeeded(forKey: storageKey)
    }

    func records() -> [HitRecord] {
        guard let data = defaults.data(forKey: storageKey) else {
            return []
        }

        do {
            return try JSONDecoder().decode([HitRecord].self, from: data)
        } catch {
            return []
        }
    }

    func addHit(on date: Date = Date()) {
        var allRecords = records()
        allRecords.append(HitRecord(date: date))
        save(allRecords)
        WidgetCenter.shared.reloadAllTimelines()
    }

    func removeHitToday(calendar: Calendar = .current, now: Date = Date()) {
        var allRecords = records()
        guard let index = allRecords.lastIndex(where: { calendar.isDate($0.date, inSameDayAs: now) }) else {
            return
        }

        allRecords.remove(at: index)
        save(allRecords)
        WidgetCenter.shared.reloadAllTimelines()
    }

    func removeAll() {
        save([])
        WidgetCenter.shared.reloadAllTimelines()
    }

    private func save(_ records: [HitRecord]) {
        guard let data = try? JSONEncoder().encode(records) else {
            return
        }

        defaults.set(data, forKey: storageKey)
    }
}
