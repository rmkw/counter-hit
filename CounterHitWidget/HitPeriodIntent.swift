import AppIntents
import WidgetKit

enum HitPeriodOption: String, AppEnum {
    case week
    case month
    case year

    static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Rango")

    static var caseDisplayRepresentations: [HitPeriodOption: DisplayRepresentation] = [
        .week: "Semanal",
        .month: "Mensual",
        .year: "Anual"
    ]

    var period: HitPeriod {
        switch self {
        case .week: .week
        case .month: .month
        case .year: .year
        }
    }
}

struct SelectHitPeriodIntent: AppIntent {
    static var title: LocalizedStringResource = "Cambiar rango"
    static var description = IntentDescription("Cambia el rango visible del widget Counter Hit.")

    @Parameter(title: "Rango")
    var period: HitPeriodOption

    init() {}

    init(period: HitPeriodOption) {
        self.period = period
    }

    func perform() async throws -> some IntentResult {
        HitPreferences.selectedPeriod = period.period
        WidgetCenter.shared.reloadAllTimelines()
        return .result()
    }
}
