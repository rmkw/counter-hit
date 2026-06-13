import Charts
import SwiftUI
import WidgetKit

struct CounterHitWidgetView: View {
    let entry: CounterHitEntry

    private var maxCount: Int {
        max(entry.buckets.map(\.count).max() ?? 0, 1)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 7) {
            header
            periodTabs
            chart
        }
        .containerBackground(for: .widget) {
            LinearGradient(
                colors: [Color(red: 0.13, green: 0.13, blue: 0.14), Color(red: 0.06, green: 0.06, blue: 0.07)],
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }

    private var header: some View {
        HStack(alignment: .center, spacing: 14) {
            Button(intent: RemoveHitIntent()) {
                Image(systemName: "minus.circle.fill")
                    .font(.system(size: 30, weight: .bold))
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(.white.opacity(0.5))
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Restar hit")

            Spacer(minLength: 0)

            VStack(alignment: .center, spacing: 1) {
                Text(entry.period.title)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(.white)

                Text("Hoy \(entry.todayTotal)")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(.white.opacity(0.54))
                    .monospacedDigit()
            }
            .frame(maxWidth: .infinity)

            Spacer(minLength: 0)

            Button(intent: AddHitIntent()) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 32, weight: .bold))
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(.green)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Agregar hit")
        }
    }

    private var periodTabs: some View {
        HStack(spacing: 6) {
            tabButton(.week)
            tabButton(.month)
            tabButton(.year)
        }
    }

    private func tabButton(_ period: HitPeriod) -> some View {
        Button(intent: SelectHitPeriodIntent(period: option(for: period))) {
            Text(period.shortTitle)
                .font(.system(size: 11, weight: .bold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 4)
                .foregroundStyle(entry.period == period ? .black : .white.opacity(0.62))
                .background(entry.period == period ? Color.green : Color.white.opacity(0.08))
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }

    private var chart: some View {
        Chart(entry.buckets) { bucket in
            BarMark(
                x: .value(entry.period.xAxisTitle, bucket.label),
                y: .value("Hits", bucket.count)
            )
            .foregroundStyle(Color.green.gradient)
            .cornerRadius(4)
            .annotation(position: .top) {
                Text("\(bucket.count)")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.52))
                    .monospacedDigit()
            }
        }
        .chartYScale(domain: 0...(maxCount + 2))
        .chartXAxis {
            AxisMarks { value in
                AxisValueLabel {
                    if let label = value.as(String.self) {
                        Text(label)
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(.white.opacity(0.52))
                    }
                }
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading, values: .automatic(desiredCount: 3)) {
                AxisGridLine()
                    .foregroundStyle(.white.opacity(0.14))
                AxisValueLabel()
                    .font(.system(size: 10))
                    .foregroundStyle(.white.opacity(0.52))
            }
        }
    }

    private func option(for period: HitPeriod) -> HitPeriodOption {
        switch period {
        case .week: .week
        case .month: .month
        case .year: .year
        }
    }
}
