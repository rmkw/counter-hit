import Charts
import SwiftUI
import WidgetKit

struct CounterHitWidgetView: View {
    @Environment(\.widgetFamily) private var family

    let entry: CounterHitEntry

    private var maxCount: Int {
        max(entry.buckets.map(\.count).max() ?? 0, 1)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            header
            chart
        }
        .containerBackground(for: .widget) {
            Color(.systemBackground)
        }
        .widgetURL(URL(string: "counterhit://add-hit"))
    }

    private var header: some View {
        HStack(alignment: .firstTextBaseline) {
            VStack(alignment: .leading, spacing: 2) {
                Text(entry.period.title)
                    .font(.headline)

                Text("Hoy \(entry.todayTotal)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .monospacedDigit()
            }

            Spacer(minLength: 6)

            Image(systemName: "plus.circle.fill")
                .foregroundStyle(.green)
                .font(.title3)
        }
    }

    private var chart: some View {
        Chart(entry.buckets) { bucket in
            BarMark(
                x: .value(entry.period.xAxisTitle, bucket.label),
                y: .value("Hits", bucket.count)
            )
            .foregroundStyle(.green.gradient)
            .annotation(position: .top) {
                if family != .systemSmall {
                    Text("\(bucket.count)")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .monospacedDigit()
                }
            }
        }
        .chartYScale(domain: 0...(maxCount + 1))
        .chartXAxis {
            AxisMarks { value in
                AxisValueLabel {
                    if let label = value.as(String.self) {
                        Text(shortLabel(label))
                            .font(.caption2)
                    }
                }
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading, values: .automatic(desiredCount: family == .systemSmall ? 2 : 4)) {
                AxisGridLine()
                AxisValueLabel()
                    .font(.caption2)
            }
        }
    }

    private func shortLabel(_ label: String) -> String {
        guard family == .systemSmall, label.count > 3 else {
            return label
        }

        return String(label.prefix(3))
    }
}
