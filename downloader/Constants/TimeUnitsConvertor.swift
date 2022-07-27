//
//  TimeSizeUnits.swift
//  downloader
//
//  Created by LAP14812 on 01/07/2022.
//

import Foundation
public struct TimeUnitsConvertor{
    public let seconds: Int64
    
    public var minutes: Int64{
        return seconds/60
    }
    
    public var hours: Int64{
        return minutes/60
    }
    
    public var days: Int64{
        return hours/24
    }
    
    public var weeks: Int64{
        return days/7
    }
    
    public var months: Int64{
        return weeks/4
    }
    public var year: Int64{
        return months/12
    }
    
    public init(withSeconds seconds: Int64){
        self.seconds = seconds
    }
    let oneMinuteUnit: Int64 = 60;
    var oneHourUnit: Int64 {
        return oneMinuteUnit * 60
    }
    var oneDayUnit: Int64{
        return oneHourUnit * 24
    }
    var oneWeekUnit: Int64{
        return oneDayUnit * 7
    }
    var oneMonthUnit: Int64{
        return oneWeekUnit * 4
    }
    
    var oneYearUnit: Int64{
        return oneMonthUnit * 12
    }
    
    public func getReadableTimeUnit() -> String{
        switch seconds {
        case 0..<oneMinuteUnit:
            return "\(seconds) sec(s) ago"
        case oneMinuteUnit..<oneHourUnit:
            return "\(minutes) min(s) ago"
        case oneHourUnit..<oneDayUnit:
            return "\(hours) h(s) ago"
        case oneDayUnit..<oneWeekUnit:
            return "\(days) day(s) ago"
        case oneWeekUnit..<oneMonthUnit:
            return "\(weeks) wk(s) ago"
        case oneMonthUnit..<oneYearUnit:
            return "\(months) mth(s) ago"
        case oneYearUnit..<Int64.max:
            return "\(year) year(s) ago"
        default:
            return "\(seconds) second(s) ago"
        }
    }
}
