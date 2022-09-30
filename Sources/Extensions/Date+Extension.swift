//
//  Date+Extension.swift
//  JJKit
//
//  Created by 郑桂杰 on 2022/9/30.
//

import Foundation

extension Date: JJCompatible {}

extension Date {
    public enum DateComponentType {
        case second, minute, hour, day, weekday, weekdayOrdinal, week, month, year
    }
    
    /// 默认的日期格式化对象。(why: 因为创建DateFormatter开销较大)
    fileprivate static var defaultDateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.timeZone = .current
        f.locale = .current
        return f
    }()
}

public extension JJBox where Base == Date {
    /// 获取日期的对应描述
    /// - Parameter component: 描述类型
    /// - Returns: 获取到的结果
    func component(_ component:Date.DateComponentType) -> Int? {
        let components = Calendar.current.dateComponents([.year, .month, .day, .weekOfYear, .hour, .minute, .second, .weekday, .weekdayOrdinal, .weekOfYear], from: base)
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
    
    /// 是不是今天
    var isToday: Bool {
        if fabs(base.timeIntervalSinceNow) >= 60 * 60 * 24 {
            return false
        }
        guard let day = component(.day) else {
            return false
        }
        return day == Date().jj.component(.day)
    }
    
    /// 是不是昨天
    var isYesterday: Bool {
        return add(component: .day, offset: 1).jj.isToday
    }
    
    /// 获取偏移对应类型之后的日志
    /// - Parameters:
    ///   - component: 偏移的类型
    ///   - offset: 偏移大小
    /// - Returns: 新的日期
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
        return Calendar.current.date(byAdding: dateComp, to: base)!
    }
    
    /// 根据给定的字符串格式化date
    /// - Parameter dateFormatter: 格式化对象(why: 因为创建DateFormatter开销较大,可以根据使用情景来决定是临时创建或者保存的formatter)
    /// - Returns: (日期格式化字符串)->(格式化之后的字符串)block
    func format(dateFormatter: DateFormatter?) -> (_ format: String) -> String {
        let formatter = dateFormatter ?? Date.defaultDateFormatter
        return { formatString in
            formatter.dateFormat = formatString
            return formatter.string(from: base)
        }
    }
    
    /// 根据给定的格式化方式格式化date
    /// - Parameter dateFormatter: 格式化对象(why: 因为创建DateFormatter开销较大,可以根据场景来决定是临时创建或者保存的formatter)
    /// - Returns: (格式化方式)->(格式化之后的字符串)block
    func format(dateFormatter: DateFormatter?) -> (_ formatterStyle: Date.DateFormatterStyle) -> String {
        let formatter = dateFormatter ?? Date.defaultDateFormatter
        return { style in
            formatter.dateFormat = style.stringFormat
            return formatter.string(from: base)
        }
    }
}

public extension Date {
    /// 根据日期字符串快速创建Date对象
    /// - Parameters:
    ///   - string: 日期字符串
    ///   - format: 日期字符串格式
    ///   - timeZone: 时区
    ///   - locale: 地区
    /// - Returns: Date对象
    static func from(_ string: String, format: String, timeZone: TimeZone = .current, locale: Locale = .current) -> Date? {
        let formatter = Date.defaultDateFormatter
        formatter.dateFormat = format
        formatter.timeZone = timeZone
        formatter.locale = locale
        return formatter.date(from: string)
    }
    
    /// 根据给定的时间格式化方式格式化时间戳
    /// - Parameter timestamp: 时间戳
    /// - Returns: (格式化方式字符串)->(格式化之后的字符串)block
    static func from(timestamp: Double) -> (_ format: String) -> String {
        let date = Date(timeIntervalSince1970: timestamp / 1000)
        return date.jj.format(dateFormatter: nil)
    }
    
    /// 根据给定的时间格式化方式格式化时间戳
    /// - Parameter timestamp: 时间戳
    /// - Returns: (格式化方式)->(格式化之后的字符串)block
    static func from(timestamp: Double) -> (_ format: Date.DateFormatterStyle) -> String {
        let date = Date(timeIntervalSince1970: timestamp / 1000)
        return date.jj.format(dateFormatter: nil)
    }
    
    /// 根据日期字符串创建对应的日期
    /// - Parameters:
    ///   - string: 日期字符串
    ///   - formatterStyle: 格式化方式
    /// - Returns: 日期
    static func from(_ string: String, formatterStyle: Date.DateFormatterStyle) -> Date? {
        let formatter = Date.defaultDateFormatter
        formatter.dateFormat = formatterStyle.stringFormat
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
        /// "yyyy-MM-dd HH:mm:ss"
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
