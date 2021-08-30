//
//  DateExtensions.swift
//

import Foundation

extension Date {

    // sunday = 1. saturday = 7
    var dayOfWeekIndex: Int {
        let calendar: Calendar = Calendar.current
        return calendar.component(.weekday, from: self)
    }

    var year: Int {
        return Calendar.current.component(.year, from: self)
    }

    var month: Int {
        return Calendar.current.component(.month, from: self)
    }

    var week: Int {
        return Calendar.current.component(.weekOfYear, from: self)
    }

    var day: Int {
        return Calendar.current.component(.day, from: self)
    }

    var hours: Int {
        return Calendar.current.component(.hour, from: self)
    }

    var minutes: Int {
        return Calendar.current.component(.minute, from: self)
    }

    var seconds: Int {
        return Calendar.current.component(.second, from: self)
    }

    var dateAtBeginningOfDay: Date {
        let calendar: Calendar = Calendar.current
        return calendar.startOfDay(for: self)
    }

    var dateAtEndOfDay: Date {
        let calendar = Calendar.current
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: self)!
        let tomorrowMidnight = calendar.startOfDay(for: tomorrow)
        return calendar.date(byAdding: .second, value: -1, to: tomorrowMidnight)!
    }

    var dateAtBeginningOfHour: Date? {
        var components: DateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
        components.hour = self.hours
        components.minute = 0
        components.second = 0
        return Calendar.current.date(from: components)
    }

    var dateWithZeroSeconds: Date {
        let time: TimeInterval = floor(self.timeIntervalSinceReferenceDate / 60.0) * 60.0
        return Date(timeIntervalSinceReferenceDate: time)
    }

    func isBetweenDates(_ startDate: Date, endDate: Date, inclusive: Bool = false) -> Bool {
        if inclusive == true {
            var result = self.isBetweenDates(startDate, endDate: endDate)
            if (!result)
            {
                if ((self == startDate) || (self == endDate))
                {
                    result = true
                }
            }
            return result
        } else {
            if (self.isEarlierThan(startDate)) {
                return false
            }
            if (self.isLaterThan(endDate)) {
                return false
            }
            return true
        }
    }

    func isEarlierThan(_ date: Date) -> Bool {
        return self.compare(date) == .orderedAscending
    }

    func isEarlierThanOrEqualTo(_ date: Date) -> Bool {
        if isEarlierThan(date) == true || date.isToday == true {
            return true
        }
        return false
    }

    func isLaterThan(_ date: Date) -> Bool {
        return self.compare(date) == .orderedDescending
    }

    func isLaterThanOrEqualTo(_ date: Date) -> Bool {
        if isLaterThan(date) == true || date.isToday == true {
            return true
        }
        return false
    }

    var isToday: Bool
    {
        let today = Date()
        return self.year == today.year && self.month == today.month && self.day == today.day
    }

    func roundToMinutes(interval: Int) -> Date {
        let time: DateComponents = Calendar.current.dateComponents([.hour, .minute], from: self)
        let minutes: Int = time.minute!
        let remain = minutes % interval
        return self.addingTimeInterval(TimeInterval(60 * (interval - remain))).dateWithZeroSeconds
    }

    func addingDayIndexFromToday(dayIndex: Int) -> Date? {
        let calendar = Calendar.current
        let dateComponents: DateComponents = calendar.dateComponents([.hour, .minute, .second], from: self)
        let OneDayTimeInterval: TimeInterval = 86400
        var tomorrowComponents: DateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self.addingTimeInterval(OneDayTimeInterval))

        tomorrowComponents.hour = dateComponents.hour
        tomorrowComponents.minute = dateComponents.minute
        tomorrowComponents.second = dateComponents.second

        let tomorrow = calendar.date(from: tomorrowComponents)

        return calendar.date(byAdding: .day, value: dayIndex, to: tomorrow!)
    }

    var timeHasPassed: Bool {
        let calendar = Calendar.current
        var dateComponents: DateComponents = calendar.dateComponents([.hour, .minute, .second], from: self)
        let todayComponents: DateComponents = calendar.dateComponents([.year, .month, .day], from: Date())

        dateComponents.day = todayComponents.day
        dateComponents.month = todayComponents.month
        dateComponents.year = todayComponents.year

        let timeOnly = calendar.date(from: dateComponents)

        if (timeOnly!.timeIntervalSince(Date()) < 0.0) {
            return true
        } else {
            return false
        }
    }

    func numberOfDaysUntilDate(date: Date) -> Int {
        let calendar: Calendar = Calendar.current
        let components: DateComponents = calendar.dateComponents([.day], from: self, to: date)
        return components.day!
    }

    func addingYears(numberOfYears: Int) -> Date? {
        return Calendar.current.date(byAdding: .year, value: numberOfYears, to: self)
    }

    func addingMonths(numberOfMonths: Int) -> Date? {
        return Calendar.current.date(byAdding: .month, value: numberOfMonths, to: self)
    }

    func addingDays(numberOfDays: Int) -> Date? {
        return Calendar.current.date(byAdding: .day, value: numberOfDays, to: self)
    }

    func addingHours(numberOfHours: Int) -> Date? {
         return Calendar.current.date(byAdding: .hour, value: numberOfHours, to: self)
    }

    func addingMinutes(numberOfMinutes: Int) -> Date? {
        return Calendar.current.date(byAdding: .minute, value: numberOfMinutes, to: self)
    }

    func addingSeconds(numberOfSeconds: Int) -> Date? {
        return Calendar.current.date(byAdding: .second, value: numberOfSeconds, to: self)
    }

    static func dateFromISOString(_ isoString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let result = formatter.date(from: isoString)
        return result
    }

    var isoString: String {
        let formatter = ISO8601DateFormatter()
        return formatter.string(from: self)
    }

    static func dateFromShortISOString(_ isoString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: isoString)
    }

    var shortISOString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }

    var elapsedTimeSinceNow: String {
        let interval = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: self, to: Date())
        if let year = interval.year, year > 0 {
            return year == 1 ? "\(year)" + " " + "yr ago" :
                "\(year)" + " " + "years ago"
        } else if let month = interval.month, month > 0 {
            return month == 1 ? "\(month)" + " " + "month ago" :
                "\(month)" + " " + "months ago"
        } else if let day = interval.day, day > 0 {
            return day == 1 ? "\(day)" + " " + "day ago" :
                "\(day)" + " " + "days ago"
        } else if let hour = interval.hour, hour > 0 {
            return hour == 1 ? "\(hour)" + " " + "hour ago" :
                "\(hour)" + " " + "hours ago"
        } else if let minute = interval.minute, minute > 0 {
            return minute == 1 ? "\(minute)" + " " + "minute ago" :
                "\(minute)" + " " + "minutes ago"
        } else {
            return "a moment ago"
        }
    }

}
