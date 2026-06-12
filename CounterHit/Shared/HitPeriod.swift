import Foundation

enum HitPeriod: String, CaseIterable, Identifiable {
    case week
    case month
    case year

    var id: String { rawValue }

    var title: String {
        switch self {
        case .week: "Semanal"
        case .month: "Mensual"
        case .year: "Anual"
        }
    }

    var xAxisTitle: String {
        switch self {
        case .week: "Dias"
        case .month: "Semanas"
        case .year: "Meses"
        }
    }
}
