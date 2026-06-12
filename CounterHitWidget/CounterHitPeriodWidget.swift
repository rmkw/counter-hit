import SwiftUI
import WidgetKit

struct CounterHitEntry: TimelineEntry {
    let date: Date
    let period: HitPeriod
    let buckets: [HitBucket]
    let todayTotal: Int
}

struct CounterHitProvider: TimelineProvider {
    let period: HitPeriod

    func placeholder(in context: Context) -> CounterHitEntry {
        CounterHitEntry(
            date: .now,
            period: period,
            buckets: sampleBuckets(for: period),
            todayTotal: 3
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
            labels = ["Lun", "Mar", "Mie", "Jue", "Vie", "Sab", "Dom"]
        case .month:
            labels = ["S1", "S2", "S3", "S4", "S5"]
        case .year:
            labels = ["Ene", "Feb", "Mar", "Abr", "May", "Jun"]
        }

        return labels.enumerated().map { index, label in
            HitBucket(id: "\(period.rawValue)-\(index)", label: label, count: (index + 1) % 5, date: .now)
        }
    }
}

struct CounterHitWeeklyWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "CounterHitWeeklyWidget", provider: CounterHitProvider(period: .week)) { entry in
            CounterHitWidgetView(entry: entry)
        }
        .configurationDisplayName("Hits Semanal")
        .description("Grafica de hits por dias. Toca para confirmar un nuevo hit.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

struct CounterHitMonthlyWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "CounterHitMonthlyWidget", provider: CounterHitProvider(period: .month)) { entry in
            CounterHitWidgetView(entry: entry)
        }
        .configurationDisplayName("Hits Mensual")
        .description("Grafica de hits por semanas. Toca para confirmar un nuevo hit.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

struct CounterHitAnnualWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "CounterHitAnnualWidget", provider: CounterHitProvider(period: .year)) { entry in
            CounterHitWidgetView(entry: entry)
        }
        .configurationDisplayName("Hits Anual")
        .description("Grafica de hits por meses. Toca para confirmar un nuevo hit.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}
