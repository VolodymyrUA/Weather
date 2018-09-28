//
//  File.swift
//  WeatherApp
//
//  Created by Володимир Смульський on 9/27/18.
//  Copyright © 2018 Володимир Смульський. All rights reserved.
//

import Foundation

class Weather: NSObject {
    var sunrise: String
    var sunset : String
    
    init(sunrise: String, sunset: String) {
       
        self.sunset  = sunset
        self.sunrise = sunrise
    }
}
