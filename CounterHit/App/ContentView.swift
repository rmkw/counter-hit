import Charts
import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var hitModel: HitModel
    @Binding var showAddHitConfirmation: Bool
    @State private var selectedPeriod: HitPeriod = .week

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    header
                    totalsGrid
                    periodPicker
                    HitChartView(period: selectedPeriod, buckets: hitModel.buckets(for: selectedPeriod))
                }
                .padding(20)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Counter Hit")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAddHitConfirmation = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel("Agregar hit")
                }
            }
            .onAppear {
                hitModel.refresh()
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Hits de hoy")
                .font(.headline)
                .foregroundStyle(.secondary)

            HStack(alignment: .firstTextBaseline, spacing: 10) {
                Text("\(hitModel.todayTotal)")
                    .font(.system(size: 56, weight: .bold, design: .rounded))
                    .monospacedDigit()

                Text("hits")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(.background, in: RoundedRectangle(cornerRadius: 8))
    }

    private var totalsGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            TotalTile(title: "Dia", value: hitModel.todayTotal, symbol: "sun.max")
            TotalTile(title: "Semana", value: hitModel.weekTotal, symbol: "calendar")
            TotalTile(title: "Mes", value: hitModel.monthTotal, symbol: "chart.bar")
            TotalTile(title: "Ano", value: hitModel.yearTotal, symbol: "calendar.badge.clock")
        }
    }

    private var periodPicker: some View {
        Picker("Rango", selection: $selectedPeriod) {
            ForEach(HitPeriod.allCases) { period in
                Text(period.title).tag(period)
            }
        }
        .pickerStyle(.segmented)
    }
}

private struct TotalTile: View {
    let title: String
    let value: Int
    let symbol: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: symbol)
                .font(.headline)
                .foregroundStyle(.tint)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)

                Text("\(value)")
                    .font(.title.bold())
                    .monospacedDigit()
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(.background, in: RoundedRectangle(cornerRadius: 8))
    }
}
