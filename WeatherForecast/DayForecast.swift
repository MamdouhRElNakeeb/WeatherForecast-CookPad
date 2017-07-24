//
//  DayForecast.swift
//  WeatherForecast
//
//  Created by Mamdouh El Nakeeb on 7/25/17.
//  Copyright © 2017 Mamdouh El Nakeeb. All rights reserved.
//

import Foundation

class DayForecast {
    
    var dayName: String
    var weatherState: String
    var temp: String
    
    init (dayName: String, weatherState: String, temp: String){
        self.dayName = dayName
        self.weatherState = weatherState
        self.temp = temp
    }
    
}
