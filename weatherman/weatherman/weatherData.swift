//
//  weatherData.swift
//  OWM_Weather
//
//  Created by Fahad Ali Khan on 18/11/15.
//  Copyright (c) 2015 MapCase Media. All rights reserved.
//

import Foundation

/*
struct defined which contains weather parameters
*/
struct weatherData
{
    let cityNameStruct: String
    let tempStruct: Double!
    let tempFahStruct: Double
    let descriptionStruct: String
    
    /*
    initializer
    */
    init(cityName: String, temp: Double!, tempFah: Double, description: String)
    {
        self.cityNameStruct = cityName
        self.tempStruct = temp
        self.tempFahStruct = tempFah
        self.descriptionStruct = description
    }
}