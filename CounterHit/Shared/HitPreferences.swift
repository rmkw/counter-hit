import Foundation
import WidgetKit

enum HitPreferences {
    private static let selectedPeriodKey = "counter-hit.selected-period"

    private static var defaults: UserDefaults {
        HitDefaults.shared
    }

    static var selectedPeriod: HitPeriod {
        get {
            HitDefaults.migrateStandardValueIfNeeded(forKey: selectedPeriodKey)

            guard
                let rawValue = defaults.string(forKey: selectedPeriodKey),
                let period = HitPeriod(rawValue: rawValue)
            else {
                return .week
            }

            return period
        }
        set {
            defaults.set(newValue.rawValue, forKey: selectedPeriodKey)
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
}
