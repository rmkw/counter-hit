import Foundation

enum HitDefaults {
    static let appGroupIdentifier = "group.com.rmkwz.CounterHit"

    static var appGroup: UserDefaults? {
        UserDefaults(suiteName: appGroupIdentifier)
    }

    static var shared: UserDefaults {
        appGroup ?? .standard
    }

    static func migrateStandardValueIfNeeded(forKey key: String) {
        guard let appGroup, appGroup.object(forKey: key) == nil else {
            return
        }

        guard let standardValue = UserDefaults.standard.object(forKey: key) else {
            return
        }

        appGroup.set(standardValue, forKey: key)
        UserDefaults.standard.removeObject(forKey: key)
    }
}
