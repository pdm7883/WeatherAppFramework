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
        let serverURL = getServerURL()
        let key = getAPIKey()
        let city = city
        
        guard city != nil else {
            print("Nil search query")
            return
        }
        
        guard serverURL != nil else {
            print("Serevr URL is nil")
            return
        }
        
        guard key != nil else {
            print("API key is nil")
            return
        }
        
        let url = serverURL! + city! + "US&APPID=" + key!
        
        // FIXME: prepare target url in a nice custom method and return
        let targetURL = URL(string: url)
        guard targetURL != nil else {
            return
        }
        
        print("Out going request: \(targetURL)")
        
        let session = URLSession.shared.dataTask(with: targetURL!) {(data, rsponse, error) in
            guard error == nil else {
                print("Server error = \(error)")
                failure(error?.localizedDescription as Any)
                return
            }
            
            guard let data = data else {
                print("Data is nil")
                failure("Data is nil")
                return
            }
            
            var weatherData: [Weather] = []
            do {
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                    print("guard success, returning since errored")
                    return
                }
                
                print("Incoming response : \(json)")
                do {
                    // TODO: check if its 200 response and handle all HTTP code respectively
                    // For now check if server returned any error message and log accordingly
                    if let error = json["message"] as? String {
                        failure(error)
                        return
                    }
                    
                    // parse json and store it in model
                    let weather = try Weather.init(json: json)
                    weatherData.append(weather)
                    success(weatherData)
                }
                catch JSONSerializationError.unknown {
                    print("Decoding JSON failed with error : \(JSONSerializationError.unknown)")
                    failure("JSON Serialization failed with unknown key")
                }
                catch JSONSerializationError.invalid {
                    print("Decoding JSON failed with error : \(JSONSerializationError.invalid)")
                    failure("JSON Serialization failed with Invalid Key.")
                }
            }
            catch {
                print("JSON Serialization failed.")
                failure("JSON Serialization failed.")
            }
        }
        session.resume()
    }
    
    // get weather image
    public func getWeatherImage(imageID: String?, success:@escaping (UIImage?)->(), failure:@escaping (Any)->()) {
        guard imageID != nil else {
            print("Nil image ID")
            return
        }
        
        let serverURL = getDownloadImageBaseURL()
        guard serverURL != nil else {
            print("Nil server URL")
            return
        }
        
        // Retrive image if found in cache
        if self.isImageCached(icon: imageID!) {
            // Implement retrieve image from cache logic
            print("Returning image from cache")
        }
        
        // FIXME: prepare target url in a nice custom method and return
        let url = serverURL! + "\(imageID)" + ".png"
        let targetURL = URL(string: url)
        guard targetURL != nil else {
            return
        }
        
        print("Out going request to get image : \(targetURL)")
        let session = URLSession.shared.dataTask(with: targetURL!) {(data, response, error) in
            guard error != nil else {
                failure("Received error")
                return
            }
            
            guard data != nil else {
                failure("Received nil data ")
                return
            }
            
            // cache the image
            self.saveImage(data: data!, iconName: imageID!)
            DispatchQueue.main.async {
                success(UIImage(data:data!))
            }
        }
        session.resume()
    }
    
    // MARK: private methods
    
    fileprivate func getServerURL() -> String? {
        var baseURL = weatherUrl
        baseURL = baseURL.trimmingCharacters(in: .whitespacesAndNewlines)
        baseURL = baseURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        return baseURL
    }
    
    fileprivate func getAPIKey() -> String? {
        return API_KEY
    }

    fileprivate func getDownloadImageBaseURL() -> String? {
        var baseURL = baseImageUrl
        baseURL = baseURL.trimmingCharacters(in: .whitespacesAndNewlines)
        baseURL = baseURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        return baseURL
    }
    
    // if found, get the image from cache
    fileprivate func isImageCached(icon: String) -> Bool {
        return FileManager.default.fileExists(atPath: icon)
    }
    
    // save the image in cache folder
    fileprivate func saveImage(data : Data, iconName icon: String) {
        let cache = FileManager.cacheDir() as String
        let folder = cache.appending("/Image") as String
        if !FileManager.default.fileExists(atPath: folder as String) {
            do {
                try FileManager.default.createDirectory(atPath: folder as String, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Failed to create cache directory for temp file storage")
            }
        }
        
        let path = URL(fileURLWithPath:folder).appendingPathComponent("\(icon)").path
        print("Cache Image Path : \(path)")
        do {
            try data.write(to: URL(fileURLWithPath: path), options: .atomicWrite)
        } catch {
            print("Failed to save Image file")
        }
    }
}
