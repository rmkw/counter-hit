import Foundation

final class HitModel: ObservableObject {
    @Published private(set) var records: [HitRecord]

    private let store: HitStore

    init(store: HitStore = .shared) {
        self.store = store
        records = store.records()
    }

    var todayTotal: Int {
        HitAnalytics.totalToday(records: records)
    }

    var weekTotal: Int {
        HitAnalytics.totalThisWeek(records: records)
    }

    var monthTotal: Int {
        HitAnalytics.totalThisMonth(records: records)
    }

    var yearTotal: Int {
        HitAnalytics.totalThisYear(records: records)
    }

    func buckets(for period: HitPeriod) -> [HitBucket] {
        HitAnalytics.buckets(for: period, records: records)
    }

    func addHitToday() {
        store.addHit()
        records = store.records()
    }

    func refresh() {
        records = store.records()
    }
}
