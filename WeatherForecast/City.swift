//
//  City.swift
//  WeatherForecast
//
//  Created by Mamdouh El Nakeeb on 7/23/17.
//  Copyright © 2017 Mamdouh El Nakeeb. All rights reserved.
//

import Foundation

class City {
    
    var id: Int
    var name: String
    var country: String
    
    init (id: Int, name: String, country: String){
        self.id = id
        self.name = name
        self.country = country
    }
    
}
