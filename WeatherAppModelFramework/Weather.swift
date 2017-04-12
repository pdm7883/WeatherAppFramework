//
//  Weather.swift
//  WeatherAppModelFramework
//
//  Created by Mukunda Dhirendrachar on 4/11/17.
//

import Foundation

// this model is easy to unit test with XCTest
struct Weather {
    let city : String?
    let cityID : Int?
    let location : (latitude: Double, longitude: Double)
    let country: String?
    let humidity: Int?
    let pressure: Int?
    let temp: Float?
    let maxTemp : Float?
    let minTemp : Float?
    let clouds : Int?
    let speed : Double?
    let description : String?
    let icon : String?
    let sunRise : Double?
    let sunSet : Double?
}
