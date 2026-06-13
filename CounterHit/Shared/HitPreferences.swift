import Foundation
import WidgetKit

enum HitPreferences {
    private static let appGroupIdentifier = "group.com.rmkwz.CounterHit"
    private static let selectedPeriodKey = "counter-hit.selected-period"

    private static var defaults: UserDefaults {
        UserDefaults(suiteName: appGroupIdentifier) ?? .standard
    }

    static var selectedPeriod: HitPeriod {
        get {
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
