//
//  WeatherAppDefaults.swift
//  WeatherApp
//
//  Created by Mukunda Dhirendrachar on 4/11/17.
//

import Foundation

typealias AppDefaults = WeatherAppDefaults

struct WeatherAppDefaultsKeys {
    static let lastSearchedCityID = "KEY_LAST_SEARCHED_CITY_ID"
}

class WeatherAppDefaults : NSObject {
    
    /*
     NOTES:
     1. Lookup supports multiple options. We should think about the best option to store if user searches by any of these options. May be a dictionary with NSCoder stored in NSUserDefaults? For now just storing plain query - city name.
     a. CityID
     b. City Name, Country code
     c. Zip,  Country code
     d. Lat and Long
     e. Lookup by multiple CityIDs
     2. Multiple factors to consider while storing last searched city
     */
    class var searchKey: String? {
        get {
            return UserDefaults.standard.string(forKey: WeatherAppDefaultsKeys.lastSearchedCityID)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: WeatherAppDefaultsKeys.lastSearchedCityID)
        }
    }
    
    class func configureDefaults() {
        WeatherAppDefaults.searchKey = "<Enter City>"
        if let key1 = WeatherAppDefaults.searchKey {
            print("Setting the default text<placeholder> for search field: \(key1)")
        }
    }
}
