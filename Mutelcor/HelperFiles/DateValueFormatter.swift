//
//  DateValueFormatter.m
//  ChartsDemo
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/Charts
//

import Charts

class DateValueFormatter: NSObject {
    
    let todaysDate = Date().startOfDay
    
    var formatterType: GraphPlotType
    var dateFormatter = Date.dateFormatter
    
    var lastMonthDate: Date?
    
    init(for type: GraphPlotType) {
        formatterType = type
        super.init()
    }
    
    func stringForValue(_ value: Double) -> String {
        switch formatterType {
        case .month:
            return getMonthString(value)
        case .threeMonths:
            return getThreeMonthString(value)
        case .sixMonths:
            return getSixMonthString(value)
        case .year:
            return getYearString(value)
        default:
            return getWeekString(value)
        }
    }
    
    // Used to get day name using value, eg: Mon Tue
    // here value is timeIntervalSince1970
    func getWeekString(_ value: Double) -> String {
        dateFormatter.dateFormat = "d MMM"
        return (dateFormatter.string(from: Date(timeIntervalSince1970: value)))
    }
    
    // Used to get month string using value, eg: 1-5 Jun, 6-10 Jun
    // here value is timeIntervalSince1970
    func getMonthString(_ value: Double) -> String {
        let date = Date(timeIntervalSince1970: value)
        var startDate = Date()
        var endDate = Date()
        dateFormatter.dateFormat = "d MMM"
        
        let firstChunkStart = todaysDate.adding(.month, value: -1)
        let secondChunkStart = firstChunkStart.adding(.day, value: 5)
        let thirdChunkStart = secondChunkStart.adding(.day, value: 5)
        let fourthChunkStart = thirdChunkStart.adding(.day, value: 5)
        let fifthChunkStart = fourthChunkStart.adding(.day, value: 5)
        let sixthChunkStart = fifthChunkStart.adding(.day, value: 5)
        let sixthChunkEnd = sixthChunkStart.adding(.day, value: 4)
        
        if date < secondChunkStart {
            startDate = firstChunkStart
            endDate = secondChunkStart.adding(.day, value: -1)
        } else if date < thirdChunkStart {
            startDate = secondChunkStart
            endDate = thirdChunkStart.adding(.day, value: -1)
        } else if date < fourthChunkStart {
            startDate = thirdChunkStart
            endDate = fourthChunkStart.adding(.day, value: -1)
        } else if date < fifthChunkStart {
            startDate = fourthChunkStart
            endDate = fifthChunkStart.adding(.day, value: -1)
        } else if date < sixthChunkStart {
            startDate = fifthChunkStart
            endDate = sixthChunkStart.adding(.day, value: -1)
        } else if date < sixthChunkEnd {
            startDate = sixthChunkStart
            endDate = sixthChunkEnd
        } else {
            startDate = sixthChunkEnd.adding(.day, value: 1)
            endDate = todaysDate
        }
        
        let startMonth = startDate.startOfMonth
        let endMonth = endDate.startOfMonth
        
        if startDate == endDate {
            return dateFormatter.string(from: todaysDate)
            
        } else if startMonth == endMonth {
            dateFormatter.dateFormat = "d"
            var string = ""
            string += dateFormatter.string(from: startDate)
            string += "-"
            dateFormatter.dateFormat = "d MMM"
            let date = (endDate > todaysDate ? todaysDate:endDate)
            string += dateFormatter.string(from: date)
            return string
        }
        return "\(dateFormatter.string(from: startDate))-\(dateFormatter.string(from: endDate))"
    }
    
    // Used to get three month string using value, eg: 1-15 Jun, 16-31 Jun
    // here value is timeIntervalSince1970
    func getThreeMonthString(_ value: Double) -> String {
        let date = Date(timeIntervalSince1970: value)
        let monthsStartDate = date.startOfMonth
        let monthsEndDate = date.endOfMonth
        let monthsMidDateTimeInterval = (monthsStartDate.timeIntervalSince1970 + monthsEndDate.timeIntervalSince1970) / 2
        var string = ""
        
        if value < monthsMidDateTimeInterval {
            dateFormatter.dateFormat = "d"
            string += dateFormatter.string(from: monthsStartDate)
            string += "-"
            dateFormatter.dateFormat = "d MMM"
            string += dateFormatter.string(from: monthsStartDate.adding(.day, value: 14))
            
        } else {
            dateFormatter.dateFormat = "d"
            string += dateFormatter.string(from: monthsStartDate.adding(.day, value: 15))
            string += "-"
            dateFormatter.dateFormat = "d MMM"
            string += dateFormatter.string(from: monthsEndDate)
        }
        return string
    }
    
    // Used to get 3 letter month name using value, eg: Jan, Feb
    // here value is timeIntervalSince1970
    func getSixMonthString(_ value: Double) -> String {
        let date = Date(timeIntervalSince1970: value)
        dateFormatter.dateFormat = "MMM"
        return dateFormatter.string(from: date)
    }
    
    // Used to get year using value, eg: 2016, 2017
    // here value is timeIntervalSince1970
    func getYearString(_ value: Double) -> String {
        
        let date = Date(timeIntervalSince1970: value)
        var firstMonthDate = date.adding(.day, value: -15)
        var secondMonthDate = date.adding(.day, value: 15)
        
        if lastMonthDate?.startOfMonth == firstMonthDate.startOfMonth {
            let modifiedDate = date.adding(.month, value: 1)
            firstMonthDate = modifiedDate.adding(.day, value: -15)
            secondMonthDate = modifiedDate.adding(.day, value: 15)
        }
        
        lastMonthDate = secondMonthDate
        
        dateFormatter.dateFormat = "MMM"
        if secondMonthDate.endOfMonth > todaysDate {
            return dateFormatter.string(from: todaysDate)
        }
        
        let firstMonthStr = dateFormatter.string(from: firstMonthDate)
        let lastMonthStr = dateFormatter.string(from: secondMonthDate)
        
        let str = "\(firstMonthStr)-\(lastMonthStr)"
        return str
    }
    
}

// MARK: IValueFormatter Methods
extension DateValueFormatter: IValueFormatter {
    
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        return stringForValue(value)
    }
    
}

// MARK: IAxisValueFormatter Methods
extension DateValueFormatter: IAxisValueFormatter {
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return stringForValue(value)
    }
    
}


