//
//  DateFormat.swift
//  WeatherForecast
//
//  Created by Mamdouh El Nakeeb on 7/24/17.
//  Copyright © 2017 Mamdouh El Nakeeb. All rights reserved.
//

import Foundation

class DateFormat {
    
    var formatterDate: DateFormatter
    
    init() {
        
        formatterDate = DateFormatter()
        formatterDate.timeZone = NSTimeZone(name: "UTC+2") as TimeZone! //TimeZone.current
        formatterDate.dateFormat = "EEEE,dd,MMMM"
        
    }
    
    func getDateStr(dateMilli: Int) -> String {
        let date = NSDate(timeIntervalSince1970: Double(dateMilli))
        
        //var dateArr: [String] = Array()
        //formatterDate.dateFormat = "EEEE"
        //dateArr.append(date.monthMedium)
//        dateArr.append(formatterDate.weekdaySymbols[Calendar.current.component(.day, from: date as Date)])
//        dateArr.append(formatterDate.weekdaySymbols[Calendar.current.component(.month, from: date as Date)])
        return formatterDate.string(from: date as Date)
    }
    
}



