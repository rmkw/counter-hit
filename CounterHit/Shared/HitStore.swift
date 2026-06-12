import Foundation
import WidgetKit

final class HitStore {
    static let shared = HitStore()

    private let appGroupIdentifier = "group.com.rmkwz.CounterHit"
    private let storageKey = "counter-hit.records"
    private let fallbackDefaults = UserDefaults.standard

    private var defaults: UserDefaults {
        UserDefaults(suiteName: appGroupIdentifier) ?? fallbackDefaults
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
