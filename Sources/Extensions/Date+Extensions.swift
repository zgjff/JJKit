import Foundation
extension Date: JJCompatible {}

extension Date {
    public enum DateComponentType {
        case second, minute, hour, day, weekday, weekdayOrdinal, week, month, year
    }
}

public extension JJ where Original == Date {
    func component(_ component:Date.DateComponentType) -> Int? {
        let components = Calendar.current.dateComponents([.year, .month, .day, .weekOfYear, .hour, .minute, .second, .weekday, .weekdayOrdinal, .weekOfYear], from: original)
        switch component {
        case .second:
            return components.second
        case .minute:
            return components.minute
        case .hour:
            return components.hour
        case .day:
            return components.day
        case .weekday:
            return components.weekday
        case .weekdayOrdinal:
            return components.weekdayOrdinal
        case .week:
            return components.weekOfYear
        case .month:
            return components.month
        case .year:
            return components.year
        }
    }
    var isToday: Bool {
        guard let day = component(.day) else { return false }
        if fabs(original.timeIntervalSinceNow) >= 60 * 60 * 24 { return false }
        return day == Date().jj.component(.day)
    }
    var isYesterday: Bool {
        return add(component: .day, offset: 1).jj.isToday
    }
    func add(component: Date.DateComponentType, offset: Int) -> Date {
        var dateComp = DateComponents()
        switch component {
        case .second:
            dateComp.second = offset
        case .minute:
            dateComp.minute = offset
        case .hour:
            dateComp.hour = offset
        case .day:
            dateComp.day = offset
        case .weekday:
            dateComp.weekday = offset
        case .weekdayOrdinal:
            dateComp.weekdayOrdinal = offset
        case .week:
            dateComp.weekOfYear = offset
        case .month:
            dateComp.month = offset
        case .year:
            dateComp.year = offset
        }
        return Calendar.current.date(byAdding: dateComp, to: original)!
    }
    func string(with format: String, timeZone: TimeZone = TimeZone.current, locale: Locale = Locale.current) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = timeZone
        formatter.locale = locale
        return formatter.string(from: original)
    }
    func string(for formatterStyle: Date.DateFormatterStyle) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = formatterStyle.stringFormat
        formatter.timeZone = .current
        formatter.locale = .current
        return formatter.string(from: original)
    }
}

public extension Date {
    static func from(_ string: String, format: String, timeZone: TimeZone = .current, locale: Locale = .current) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = timeZone
        formatter.locale = locale
        return formatter.date(from: string)
    }
    
    static func from(timestamp: Double) -> (String) -> String {
        let date = Date(timeIntervalSince1970: timestamp / 1000)
        return { format in
            return date.jj.string(with: format)
        }
    }
    
    static func from(timestamp: Double) -> (Date.DateFormatterStyle) -> String {
        let date = Date(timeIntervalSince1970: timestamp / 1000)
        return { style in
            return date.jj.string(for: style)
        }
    }
    
    static func from(_ string: String, formatterStyle: Date.DateFormatterStyle) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = formatterStyle.stringFormat
        formatter.timeZone = .current
        formatter.locale = .current
        return formatter.date(from: string)
    }
}


extension Date {
    public enum DateFormatterStyle {
        /// "yyyy"
        case year
        /// "yyyy-MM"
        case yearMonth
        /// "MM-dd"
        case monthDay
        /// "yyyy-MM-dd"
        case date
        /// "HH:mm:ss"
        case hms
        /// "yyyy-MM-dd HH:mm:ss" i.e. 1997-07-16 12:23:23
        case ymdhms
        /// A custom date format string
        case custom(String)
        
        var stringFormat:String {
            switch self {
            case .year: return "yyyy"
            case .yearMonth: return "yyyy-MM"
            case .monthDay: return "MM-dd"
            case .date: return "yyyy-MM-dd"
            case .hms: return "HH:mm:ss"
            case .ymdhms: return "yyyy-MM-dd HH:mm:ss"
            case .custom(let customFormat): return customFormat
            }
        }
    }
}
