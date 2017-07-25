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
        formatterDate.timeZone = TimeZone.current
        formatterDate.dateFormat = "EEEE,dd,MMMM"
        
    }
    
    func getDateStr(dateMilli: Int) -> String {
        let date = NSDate(timeIntervalSince1970: Double(dateMilli))
        
        return formatterDate.string(from: date as Date)
    }
    
}



