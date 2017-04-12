//
//  WeatherAppUtils.swift
//  WeatherApp
//
//  Created by Mukunda Dhirendrachar on 4/11/17.
//

import Foundation

// Any utility methods can be placed here

class WeatherAppUtils {
    
    class func convertUnixTimeToTimeAndReturn(time: Double?) -> String {
        let date = Date(timeIntervalSince1970: time!)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: date)
    }
}
