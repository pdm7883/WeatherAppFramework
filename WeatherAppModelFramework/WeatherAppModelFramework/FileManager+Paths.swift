//
//  FileManager+Paths.swift
//  WeatherAppModelFramework
//
//  Created by bell on 4/11/17.
//  Copyright © 2017 Mukunda Dhirendrachar. All rights reserved.
//

import Foundation

extension FileManager {
    class func cacheDir() -> String {
        var paths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
        return paths[0]
    }
}
