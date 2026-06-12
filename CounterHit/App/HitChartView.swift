import Charts
import SwiftUI

struct HitChartView: View {
    let period: HitPeriod
    let buckets: [HitBucket]

    private var maxCount: Int {
        max(buckets.map(\.count).max() ?? 0, 1)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(period.title)
                        .font(.title3.bold())

                    Text("Abajo: \(period.xAxisTitle). Arriba: hits.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Text("\(buckets.reduce(0) { $0 + $1.count })")
                    .font(.title2.bold())
                    .monospacedDigit()
            }

            Chart(buckets) { bucket in
                BarMark(
                    x: .value(period.xAxisTitle, bucket.label),
                    y: .value("Hits", bucket.count)
                )
                .foregroundStyle(.green.gradient)
                .annotation(position: .top) {
                    Text("\(bucket.count)")
                        .font(.caption2.weight(.semibold))
                        .monospacedDigit()
                        .foregroundStyle(.secondary)
                }
            }
            .chartYScale(domain: 0...(maxCount + 1))
            .chartXAxisLabel(period.xAxisTitle)
            .chartYAxisLabel("Hits")
            .frame(height: 260)
        }
        .padding(18)
        .background(.background, in: RoundedRectangle(cornerRadius: 8))
    }
}
