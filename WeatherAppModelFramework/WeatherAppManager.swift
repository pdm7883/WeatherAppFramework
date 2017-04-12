//
//  WeatherAppManager.swift
//  WeatherAppModelFramework
//
//  Created by Mukunda Dhirendrachar on 4/11/17.
//

import Foundation

// Test class method access
public func classMethod() {
    print("Hello Class Method.")
}

public class WeatherAppManager {
    // Test instance method access
    public func hello() {
        print("Hello Instance Method.")
    }
    
    public init () {
        
    }
    
    // FIXME: Read it from plist file: Store safely
    fileprivate let weatherUrl = "http://api.openweathermap.org/data/2.5/weather?q="
    fileprivate let baseImageUrl = "http://openweathermap.org/img/w/"
    fileprivate let API_KEY = "3da5c0ce08da71e8fc86e78af4e17804"
    
    // get weather report for a city
    public func getWeatherReport(city: String?, success:@escaping (Any)->(), failure:@escaping (Any)->()) {

    }
    
    // get weather image
    public func getWeatherImage(imageID: String?, success:@escaping (UIImage?)->(), failure:@escaping (Any)->()) {

    }
}
