import Charts
import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var hitModel: HitModel
    @Binding var showAddHitConfirmation: Bool
    @State private var selectedPeriod: HitPeriod = HitPreferences.selectedPeriod

    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()

            compactCard
                .padding(18)
        }
        .onAppear {
            hitModel.refresh()
        }
        .onChange(of: selectedPeriod) { _, newValue in
            HitPreferences.selectedPeriod = newValue
        }
    }

    private var compactCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(selectedPeriod.title)
                        .font(.title2.weight(.bold))
                        .foregroundStyle(.white)

                    Text("Hoy \(hitModel.todayTotal)")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.56))
                        .monospacedDigit()
                }

                Spacer()

                HStack(spacing: 10) {
                    Button {
                        hitModel.removeHitToday()
                    } label: {
                        Image(systemName: "minus.circle.fill")
                            .font(.title2)
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(.white.opacity(0.5))
                    }
                    .accessibilityLabel("Restar hit")

                    Button {
                        showAddHitConfirmation = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title)
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(.green)
                    }
                    .accessibilityLabel("Agregar hit")
                }
            }

            Picker("Rango", selection: $selectedPeriod) {
                ForEach(HitPeriod.allCases) { period in
                    Text(period.title).tag(period)
                }
            }
            .pickerStyle(.segmented)

            HitCompactChart(period: selectedPeriod, buckets: hitModel.buckets(for: selectedPeriod))
                .frame(height: 172)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 22)
        .background(
            LinearGradient(
                colors: [Color(red: 0.12, green: 0.12, blue: 0.13), Color(red: 0.05, green: 0.05, blue: 0.06)],
                startPoint: .top,
                endPoint: .bottom
            ),
            in: RoundedRectangle(cornerRadius: 26, style: .continuous)
        )
        .shadow(color: .black.opacity(0.24), radius: 22, y: 10)
    }
}
