//
//  Weather.swift
//  WeatherAppModelFramework
//
//  Created by Mukunda Dhirendrachar on 4/11/17.
//

import Foundation

enum JSONSerializationError : Error {
    case unknown(String)
    case invalid(String)
}

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
    
    init(json: [String : Any]) throws {
        guard let main = json["main"] as? [String: Any],
            let humidity = main["humidity"] as? Int,
            let pressure = main["pressure"] as? Int,
            let temp = main["temp"] as? Float,
            let minTemp = main["temp_min"] as? Float,
            let maxTemp = main["temp_max"] as? Float else {
                throw JSONSerializationError.unknown("Failed to decode main key")
        }
        
        guard let city = json["name"] as? String else {
            throw JSONSerializationError.unknown("Failed to decode name key")
        }
        
        guard let id = json["id"] as? Int else {
            throw JSONSerializationError.unknown("Failed to decode id key")
        }
        
        guard let coordinates = json["coord"] as? [String: Double], let lat = coordinates["lat"], let lon = coordinates["lon"] else {
            throw JSONSerializationError.unknown("Failed to decode coord key")
        }
        
        guard let sysInfo = json["sys"] as? [String: Any],
            let country = sysInfo["country"] as? String,
            let sunrise = sysInfo["sunrise"] as? Double,
            let sunset = sysInfo["sunset"] as? Double else {
                throw JSONSerializationError.unknown("Failed to decode sys key")
        }
        
        guard let clouds = json["clouds"] as? [String: Any], let cloudValue = clouds["all"] as? Int else {
            throw JSONSerializationError.unknown("Failed to decode clouds key")
        }
        
        guard let winds = json["wind"] as? [String: Any], let windSpeed = winds["speed"] as? Double else {
            throw JSONSerializationError.unknown("Failed to decode wind key")
        }
        
        guard let weather = json["weather"] as? [[String: Any]], let description = weather.first?["description"], let icon = weather.first?["icon"] else {
            throw JSONSerializationError.unknown("Failed to decode weather key")
        }
        
        self.city = city
        self.cityID = id
        self.location = (lat, lon)
        self.country = country
        self.temp = temp
        self.maxTemp = maxTemp
        self.minTemp = minTemp
        self.pressure = pressure
        self.humidity = humidity
        self.clouds = cloudValue
        self.speed = windSpeed
        self.description = description as? String
        self.icon = icon as? String
        self.sunRise = sunrise
        self.sunSet = sunset
    }
}
