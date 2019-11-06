//
//  FoundationExtensions.swift
//

import Foundation

// MARK: - Constants

let kOneDayTimeInterval: Double = 86400

// MARK: - NSRange

extension NSRange {

    func toRange(_ string: String) -> Range<String.Index> {
        let start = string.index(string.startIndex, offsetBy: self.location)
        let end = string.index(start, offsetBy: self.length)
        return start..<end
    }

}

// MARK: - String

extension String {

    subscript (bounds: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
    }

    subscript (bounds: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }

}

// MARK: - NSDate

extension Date {

    // sunday = 1. saturday = 7
    func dayOfWeekIndex() -> Int {
        let calendar: Calendar = Calendar.current
        return calendar.component(.weekday, from: self)
    }

    func year() -> Int {
        return Calendar.current.component(.year, from: self)
    }

    func month() -> Int {
        return Calendar.current.component(.month, from: self)
    }

    func day() -> Int {
        return Calendar.current.component(.day, from: self)
    }

    func hours() -> Int {
        return Calendar.current.component(.hour, from: self)
    }

    func minutes() -> Int {
        return Calendar.current.component(.minute, from: self)
    }

    func seconds() -> Int {
        return Calendar.current.component(.second, from: self)
    }

    func dateAtBeginningOfDay() -> Date {
        let calendar: Calendar = Calendar.current
        return calendar.startOfDay(for: self)
    }

    func dateAtEndOfDay() -> Date {
        let calendar = Calendar.current
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: self)!
        let tomorrowMidnight = calendar.startOfDay(for: tomorrow)
        return calendar.date(byAdding: .second, value: -1, to: tomorrowMidnight)!
    }

    func dateAtBeginningOfHour() -> Date? {
        var components: DateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
        components.hour = self.hours()
        components.minute = 0
        components.second = 0
        return Calendar.current.date(from: components)
    }

    func dateWithZeroSeconds() -> Date {
        let time: TimeInterval = floor(self.timeIntervalSinceReferenceDate / 60.0) * 60.0
        return Date(timeIntervalSinceReferenceDate: time)
    }

    func debugString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter.string(from: self)
    }

    // Returns date formatted as countdown:
    //
    // >= 1 day == time in day(s) rounded up
    // >= 1 hour == time in hour(s) rounded up
    // >= 5 minutes == time in minutes rounded up
    // < 5 minutes == time in minutes, seconds rounded up

    func countdownTimeStringUntilDate(targetDate: Date, noRounding : Bool = false) -> String {
        let nextReminderSecondsLeft:Int = Int(self.timeIntervalSince(targetDate))
        var days : Int = nextReminderSecondsLeft / Int(kOneDayTimeInterval)
        var hours : Int = nextReminderSecondsLeft % Int(kOneDayTimeInterval) / 3600
        var minutes : Int = (nextReminderSecondsLeft % 3600) / 60
        let seconds : Int = (nextReminderSecondsLeft % 3600) % 60
        var countdownString: String = ""

        if (noRounding) {
            hours = nextReminderSecondsLeft / 3600
            if (hours > 0) {
                countdownString = String(format: NSLocalizedString("%d:%02d:%02d", comment:"hours:minutes:seconds left in reminder"),hours,minutes,seconds)
            } else if (minutes > 0) {
                countdownString = String(format: NSLocalizedString("%d:%02d", comment:"minutes:seconds left in reminder"),minutes,seconds)
            } else {
                countdownString = String(format: NSLocalizedString("%d", comment:"seconds left in reminder"),seconds)
            }
        } else {
            if days >= 1 {
                if hours > 0 || minutes > 0 || seconds > 0 {
                    days += 1
                }
                if days == 1 {
                    countdownString = String(format: NSLocalizedString("%d Day", comment: "number of days left in reminder (singular)"), days)
                } else {
                    countdownString = String(format: NSLocalizedString("%d Days", comment: "number of days left in reminder (plural)"), days)
                }
            } else if hours >= 1 {
                if minutes > 0 || seconds > 0 {
                    hours += 1
                }
                if hours == 1 {
                    countdownString = String(format: NSLocalizedString("%d Hour", comment: "number of hours left in reminder (singular)"), hours)
                } else {
                    countdownString = String(format: NSLocalizedString("%d Hours", comment: "number of hours left in reminder (plural)"), hours)
                }
            } else if minutes >= 5 {
                if seconds > 0 {
                    minutes += 1
                }
                if minutes == 1 {
                    countdownString = String(format: NSLocalizedString("%d Min", comment: "number of minutes left in reminder (singular)"), minutes)
                } else {
                    countdownString = String(format: NSLocalizedString("%d Mins", comment: "number of minutes left in reminder (plural)"), minutes)
                }
            } else {
                countdownString = String(format: NSLocalizedString("%d:%02d", comment: "number of minutes and seconds left in reminder"), minutes, seconds)
            }
        }
        return countdownString
    }

    // Returns date formatted as:
    //
    // Today, 10:15 PM
    // Friday, 12:13 AM

    func getRelativeTimeString() -> String {

        let formatter: DateFormatter = DateFormatter()

        let fireTimeAtMidnight: Date = self.dateAtBeginningOfDay()
        let todayAtMidnight: Date = Date().dateAtBeginningOfDay()

        var dayString: String = NSLocalizedString("Today", comment:"")

        if (todayAtMidnight.isEarlierThan(date: fireTimeAtMidnight)) {
            formatter.dateFormat = "EEEE"
            dayString = formatter.string(from: self)
        }

        formatter.dateFormat = "h:mm a"

        return dayString + ", " + formatter.string(from: self)
    }

    func getReminderAlarmString() -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: self)
    }

    func isBetweenDates(startDate: Date, endDate: Date) -> Bool {
        if (self.isEarlierThan(date: startDate)) {
            return false
        }
        if (self.isLaterThan(date: endDate)) {
            return false
        }
        return true
    }

    func isEarlierThan(date: Date) -> Bool {
        return self.compare(date) == .orderedAscending
    }

    func isLaterThan(date: Date) -> Bool {
        return self.compare(date) == .orderedDescending
    }

    func isToday() -> Bool
    {
        let today = Date()
        return self.year() == today.year() && self.month() == today.month() && self.day() == today.day()
    }

    func roundToMinutes(interval: Int) -> Date {
        let time: DateComponents = Calendar.current.dateComponents([.hour, .minute], from: self)
        let minutes: Int = time.minute!
        let remain = minutes % interval
        return self.addingTimeInterval(TimeInterval(60 * (interval - remain))).dateWithZeroSeconds()
    }

    func dateByAddingDayIndexFromToday(dayIndex: Int) -> Date? {
        let calendar = Calendar.current
        let dateComponents: DateComponents = calendar.dateComponents([.hour, .minute, .second], from: self)
        var tomorrowComponents: DateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self.addingTimeInterval(kOneDayTimeInterval))

        tomorrowComponents.hour = dateComponents.hour
        tomorrowComponents.minute = dateComponents.minute
        tomorrowComponents.second = dateComponents.second

        let tomorrow = calendar.date(from: tomorrowComponents)

        return calendar.date(byAdding: .day, value: dayIndex, to: tomorrow!)
    }

    func hasTimePassed() -> Bool {
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

    func dateByAddingYears(numberOfYears: Int) -> Date? {
        return Calendar.current.date(byAdding: .year, value: numberOfYears, to: self)
    }

    func dateByAddingMonths(numberOfMonths: Int) -> Date? {
        return Calendar.current.date(byAdding: .month, value: numberOfMonths, to: self)
    }

    func dateByAddingDays(numberOfDays: Int) -> Date? {
        return Calendar.current.date(byAdding: .day, value: numberOfDays, to: self)
    }

    func dateByAddingHours(numberOfHours: Int) -> Date? {
        return Calendar.current.date(byAdding: .hour, value: numberOfHours, to: self)
    }

    func dateByAddingMinutes(numberOfMinutes: Int) -> Date? {
        return Calendar.current.date(byAdding: .minute, value: numberOfMinutes, to: self)
    }

    func dateByAddingSeconds(numberOfSeconds: Int) -> Date? {
        return Calendar.current.date(byAdding: .second, value: numberOfSeconds, to: self)
    }

}
