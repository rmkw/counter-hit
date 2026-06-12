import Foundation

enum HitAnalytics {
    static func buckets(for period: HitPeriod, records: [HitRecord], calendar: Calendar = .current, now: Date = Date()) -> [HitBucket] {
        switch period {
        case .week:
            weekBuckets(records: records, calendar: calendar, now: now)
        case .month:
            monthBuckets(records: records, calendar: calendar, now: now)
        case .year:
            yearBuckets(records: records, calendar: calendar, now: now)
        }
    }

    static func totalToday(records: [HitRecord], calendar: Calendar = .current, now: Date = Date()) -> Int {
        records.filter { calendar.isDate($0.date, inSameDayAs: now) }.count
    }

    static func totalThisWeek(records: [HitRecord], calendar: Calendar = .current, now: Date = Date()) -> Int {
        count(records: records, matching: .weekOfYear, calendar: calendar, now: now)
    }

    static func totalThisMonth(records: [HitRecord], calendar: Calendar = .current, now: Date = Date()) -> Int {
        count(records: records, matching: .month, calendar: calendar, now: now)
    }

    static func totalThisYear(records: [HitRecord], calendar: Calendar = .current, now: Date = Date()) -> Int {
        count(records: records, matching: .year, calendar: calendar, now: now)
    }

    private static func weekBuckets(records: [HitRecord], calendar: Calendar, now: Date) -> [HitBucket] {
        let start = calendar.dateInterval(of: .weekOfYear, for: now)?.start ?? now
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es_MX")
        formatter.dateFormat = "E"

        return (0..<7).compactMap { offset in
            guard let date = calendar.date(byAdding: .day, value: offset, to: start) else {
                return nil
            }

            let count = records.filter { calendar.isDate($0.date, inSameDayAs: date) }.count
            let label = formatter.string(from: date).replacingOccurrences(of: ".", with: "").capitalized
            return HitBucket(id: "day-\(offset)", label: label, count: count, date: date)
        }
    }

    private static func monthBuckets(records: [HitRecord], calendar: Calendar, now: Date) -> [HitBucket] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: now) else {
            return []
        }

        var buckets: [HitBucket] = []
        var weekStart = monthInterval.start
        var weekNumber = 1

        while weekStart < monthInterval.end {
            let nextWeek = calendar.date(byAdding: .day, value: 7, to: weekStart) ?? monthInterval.end
            let bucketEnd = min(nextWeek, monthInterval.end)
            let count = records.filter { record in
                record.date >= weekStart && record.date < bucketEnd
            }.count

            buckets.append(HitBucket(id: "week-\(weekNumber)", label: "S\(weekNumber)", count: count, date: weekStart))
            weekStart = nextWeek
            weekNumber += 1
        }

        return buckets
    }

    private static func yearBuckets(records: [HitRecord], calendar: Calendar, now: Date) -> [HitBucket] {
        guard let yearInterval = calendar.dateInterval(of: .year, for: now) else {
            return []
        }

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es_MX")
        formatter.dateFormat = "MMM"

        return (1...12).compactMap { month in
            var components = calendar.dateComponents([.year], from: now)
            components.month = month
            components.day = 1

            guard let date = calendar.date(from: components) else {
                return nil
            }

            let count = records.filter {
                yearInterval.contains($0.date) && calendar.component(.month, from: $0.date) == month
            }.count
            let label = formatter.string(from: date).replacingOccurrences(of: ".", with: "").CapitalizedForChart
            return HitBucket(id: "month-\(month)", label: label, count: count, date: date)
        }
    }

    private static func count(records: [HitRecord], matching component: Calendar.Component, calendar: Calendar, now: Date) -> Int {
        records.filter {
            calendar.component(.year, from: $0.date) == calendar.component(.year, from: now) &&
            calendar.component(component, from: $0.date) == calendar.component(component, from: now)
        }.count
    }
}

private extension String {
    var CapitalizedForChart: String {
        prefix(1).uppercased() + dropFirst()
    }
}
