//
//  Date+Extensions.swift
//  Demo
//
//  Created by 123 on 2018/6/29.
//  Copyright © 2018年 郑桂杰. All rights reserved.
//

import Foundation
extension Date: JJCompatible {}

public extension JJ where Base == Date {
    var year: Int {
        return Calendar.current.component(.year, from: base)
    }
    var month: Int {
        return Calendar.current.component(.month, from: base)
    }
    var day: Int {
        return Calendar.current.component(.day, from: base)
    }
    var hour: Int {
        return Calendar.current.component(.hour, from: base)
    }
    var minute: Int {
        return Calendar.current.component(.minute, from: base)
    }
    var second: Int {
        return Calendar.current.component(.second, from: base)
    }
    var weekday: Int {
        return Calendar.current.component(.weekday, from: base)
    }
    var weekdayOrdinal: Int {
        return Calendar.current.component(.weekdayOrdinal, from: base)
    }
    var weekOfMonth: Int {
        return Calendar.current.component(.weekOfMonth, from: base)
    }
    var weekOfYear: Int {
        return Calendar.current.component(.weekOfYear, from: base)
    }
    var yearForWeekOfYear: Int {
        return Calendar.current.component(.yearForWeekOfYear, from: base)
    }
    /// 几刻钟，也就是15分钟。范围为1-4
    var quarter: Int {
        return Calendar.current.component(.quarter, from: base)
    }
    var isLeapMonth: Bool? {
        return Calendar.current.dateComponents([.quarter], from: base).isLeapMonth
    }
    var isLeapYear: Bool {
        return (year % 400 == 0) || ((year % 100 != 0) && (year % 4 == 0))
    }
    var isToday: Bool {
        if fabs(base.timeIntervalSinceNow) >= 60 * 60 * 24 { return false }
        return day == Date().jj.day
    }
    var isYesterday: Bool {
        if let added = addDays(1) {
            return added.jj.isToday
        } else {
            return false
        }
    }
    func addYears(_ years: Int) -> Date? {
        return Calendar.current.date(byAdding: .year, value: years, to: base)
    }
    func addMonths(_ months: Int) -> Date? {
        return Calendar.current.date(byAdding: .month, value: months, to: base)
    }
    func addWeeks(_ weeks: Int) -> Date? {
        return Calendar.current.date(byAdding: .weekOfYear, value: weeks, to: base)
    }
    func addDays(_ days: Int) -> Date? {
        return Calendar.current.date(byAdding: .day, value: days, to: base)
    }
    func addHours(_ hours: Int) -> Date? {
        return Calendar.current.date(byAdding: .hour, value: hours, to: base)
    }
    func addMinutes(_ minutes: Int) -> Date? {
        return Calendar.current.date(byAdding: .minute, value: minutes, to: base)
    }
    func addSeconds(_ seconds: Int) -> Date? {
        return Calendar.current.date(byAdding: .second, value: seconds, to: base)
    }
    func string(with format: String, timeZone: TimeZone = TimeZone.current, locale: Locale = Locale.current) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = timeZone
        formatter.locale = locale
        return formatter.string(from: base)
    }
    func string(for formatterStyle: DateFormatterStyle) -> String {
        return formatterStyle.formatter.string(from: base)
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
    
    static func from(timestamp: Double) -> (DateFormatterStyle) -> String {
        let date = Date(timeIntervalSince1970: timestamp / 1000)
        return { style in
            return date.jj.string(for: style)
        }
    }
    
    static func from(_ string: String, formatterStyle: DateFormatterStyle) -> Date? {
        let formatter = formatterStyle.formatter
        return formatter.date(from: string)
    }
}



/// DateFormatter类型
///
/// - ymd: yyyy-MM-dd
/// - ymdHms: yyyy-MM-dd HH:mm:ss
/// - ym: yyyy年MM月
/// - md: MM月dd日
/// - custom: 自定义
public enum DateFormatterStyle {
    case ymd
    case ymdHms
    case ym
    case md
    case custom(DateFormatter)
    
    var formatter: DateFormatter {
        switch self {
        case .ymd:
            return DateFormatterManager.shared.ymd
        case .custom(let formatter):
            return formatter
        case .ymdHms:
            return DateFormatterManager.shared.ymdHms
        case .ym:
            return DateFormatterManager.shared.ym
        case .md:
            return DateFormatterManager.shared.md
        }
    }
}

private struct DateFormatterManager {
    static let shared = DateFormatterManager()
    private init() {}
    fileprivate let ymd: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = .current
        formatter.locale = .current
        return formatter
    }()
    fileprivate let ymdHms: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = .current
        formatter.locale = .current
        return formatter
    }()
    fileprivate let ym: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月"
        formatter.timeZone = .current
        formatter.locale = .current
        return formatter
    }()
    fileprivate let md: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM月dd日"
        formatter.timeZone = .current
        formatter.locale = .current
        return formatter
    }()
}
