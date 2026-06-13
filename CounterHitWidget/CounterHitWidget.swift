import SwiftUI
import WidgetKit

struct CounterHitEntry: TimelineEntry {
    let date: Date
    let period: HitPeriod
    let buckets: [HitBucket]
    let todayTotal: Int
}

struct CounterHitProvider: TimelineProvider {
    func placeholder(in context: Context) -> CounterHitEntry {
        CounterHitEntry(
            date: .now,
            period: .week,
            buckets: sampleBuckets(for: .week),
            todayTotal: 0
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (CounterHitEntry) -> Void) {
        completion(entry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<CounterHitEntry>) -> Void) {
        let currentEntry = entry()
        let nextRefresh = Calendar.current.date(byAdding: .minute, value: 15, to: .now) ?? .now
        completion(Timeline(entries: [currentEntry], policy: .after(nextRefresh)))
    }

    private func entry() -> CounterHitEntry {
        let period = HitPreferences.selectedPeriod
        let records = HitStore.shared.records()
        return CounterHitEntry(
            date: .now,
            period: period,
            buckets: HitAnalytics.buckets(for: period, records: records),
            todayTotal: HitAnalytics.totalToday(records: records)
        )
    }

    private func sampleBuckets(for period: HitPeriod) -> [HitBucket] {
        let labels: [String]

        switch period {
        case .week:
            labels = ["Dom", "Lun", "Mar", "Mie", "Jue", "Vie", "Sab"]
        case .month:
            labels = ["S1", "S2", "S3", "S4", "S5"]
        case .year:
            labels = ["Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Sep", "Oct", "Nov", "Dic"]
        }

        return labels.enumerated().map { index, label in
            HitBucket(id: "\(period.rawValue)-\(index)", label: label, count: 0, date: .now)
        }
    }
}

struct CounterHitWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "CounterHitWidget", provider: CounterHitProvider()) { entry in
            CounterHitWidgetView(entry: entry)
        }
        .configurationDisplayName("Counter Hit")
        .description("Grafica compacta de hits con rango semanal, mensual o anual.")
        .supportedFamilies([.systemMedium])
    }
}
