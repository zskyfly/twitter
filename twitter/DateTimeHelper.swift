//
//  TwitterDateFormatter.swift
//  twitter
//
//  Created by Zachary Matthews on 2/23/16.
//  Copyright © 2016 zskyfly productions. All rights reserved.
//

import Foundation
import UIKit


class DateTimeHelper: NSDateFormatter {

    static let sharedInstance = DateTimeHelper()
    static let numberFormatterInstance = NSNumberFormatter()

    static let defaultFormatString = "EEE MMM dd HH:mm:ss Z y"
    static let detailViewFormat = NSDateFormatterStyle.ShortStyle

    static let secondsInMinute = 60.0
    static let secondsInHour = secondsInMinute * 60.0
    static let secondsInDay = secondsInHour * 24.0
    static let secondsInWeek = secondsInDay * 7.0

    enum TimeUnit {
        case Seconds, Minutes, Hours, Days
    }

    func convertStringToDate(dateString: String, formatString: String? = nil) -> NSDate? {
        let dateFormatter = DateTimeHelper.sharedInstance
        dateFormatter.dateFormat = DateTimeHelper.defaultFormatString
        if let formatString = formatString {
            dateFormatter.dateFormat = formatString
        }
        let date = dateFormatter.dateFromString(dateString)
        return date
    }

    func convertDateToString(date: NSDate, formatStyle: NSDateFormatterStyle? = nil, formatString: String? = nil, includeTime: Bool = true) -> String {
        let dateFormatter = DateTimeHelper.sharedInstance
        dateFormatter.dateFormat = DateTimeHelper.defaultFormatString

        if let formatStyle = formatStyle {
            dateFormatter.dateStyle = formatStyle
            if includeTime {
                dateFormatter.timeStyle = formatStyle
            } else {
                dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
            }
        } else if let formatString = formatString {
            dateFormatter.dateFormat = formatString
        }

        let dateString = dateFormatter.stringFromDate(date)
        return dateString
    }

    func getSecondsBeforeNow(date: NSDate) -> Double {
        return getTimeUnitFromNowToDate(date, timeUnit: TimeUnit.Seconds)
    }

    func getMinutesBeforeNow(date: NSDate) -> Double {
        return getTimeUnitFromNowToDate(date, timeUnit: TimeUnit.Minutes)
    }

    func getHoursBeforeNow(date: NSDate) -> Double {
        return getTimeUnitFromNowToDate(date, timeUnit: TimeUnit.Hours)
    }

    func getDaysBeforeNow(date: NSDate) -> Double {
        return getTimeUnitFromNowToDate(date, timeUnit: TimeUnit.Days)
    }

    func getTimeUnitFromNowToDate(date: NSDate, timeUnit: TimeUnit) -> Double {
        let now = NSDate()
        let secondsSinceDate = now.timeIntervalSinceDate(date)

        switch timeUnit {
        case .Minutes:
            return secondsSinceDate / DateTimeHelper.secondsInMinute
        case .Hours:
            return secondsSinceDate / DateTimeHelper.secondsInHour
        case .Days:
            return secondsSinceDate / DateTimeHelper.secondsInDay
        default:
            return secondsSinceDate
        }
    }

    func getDateStringForDetailView(date: NSDate?) -> String {
        var dateString = ""
        if let date = date {
            dateString = DateTimeHelper.sharedInstance.convertDateToString(date, formatStyle: DateTimeHelper.detailViewFormat)
        }
        return dateString
    }

    func getDateStringForListView(date: NSDate?) -> String {
        var dateString = ""

        if let date = date {
            let secondsAgo = getSecondsBeforeNow(date)

            switch secondsAgo {

            case 0..<DateTimeHelper.secondsInMinute:
                dateString = "\(getRoundIntFromDouble(secondsAgo))s"

            case DateTimeHelper.secondsInMinute..<DateTimeHelper.secondsInHour:
                let minutesAgo = getMinutesBeforeNow(date)
                dateString = "\(getRoundIntFromDouble(minutesAgo))m"

            case DateTimeHelper.secondsInHour..<DateTimeHelper.secondsInDay:
                let hoursAgo = getHoursBeforeNow(date)
                dateString = "\(getRoundIntFromDouble(hoursAgo))h"

            case DateTimeHelper.secondsInDay..<DateTimeHelper.secondsInWeek:
                let daysAgo = getDaysBeforeNow(date)
                dateString = "\(getRoundIntFromDouble(daysAgo))d"

            default:
                dateString = DateTimeHelper.sharedInstance.convertDateToString(date, formatStyle: DateTimeHelper.detailViewFormat, includeTime: false)
            }
        }
        return dateString
    }

    func getRoundIntFromDouble(num: Double) -> Int {
        return Int(round(num))
    }

    func getNumberFormatted(myNumber: Int) -> String? {
        let numberFormatter = DateTimeHelper.numberFormatterInstance

        numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        return numberFormatter.stringFromNumber(myNumber)
    }

}
