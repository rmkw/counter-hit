import Charts
import SwiftUI

struct HitCompactChart: View {
    let period: HitPeriod
    let buckets: [HitBucket]

    private var maxCount: Int {
        max(buckets.map(\.count).max() ?? 0, 1)
    }

    var body: some View {
        Chart(buckets) { bucket in
            BarMark(
                x: .value(period.xAxisTitle, bucket.label),
                y: .value("Hits", bucket.count)
            )
            .foregroundStyle(.clear)
            .annotation(position: .top) {
                Text("\(bucket.count)")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.56))
                    .monospacedDigit()
            }
        }
        .chartYScale(domain: 0...(maxCount + 2))
        .chartXAxis {
            AxisMarks { value in
                AxisValueLabel {
                    if let label = value.as(String.self) {
                        Text(label)
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.white.opacity(0.56))
                    }
                }
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading, values: .automatic(desiredCount: 3)) {
                AxisGridLine()
                    .foregroundStyle(.white.opacity(0.14))
                AxisValueLabel()
                    .font(.caption2)
                    .foregroundStyle(.white.opacity(0.56))
            }
        }
        .chartPlotStyle { plotArea in
            plotArea
                .background(.clear)
        }
    }
}
