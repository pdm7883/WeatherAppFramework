//
//  ViewController.swift
//  WeatherApp
//
//  Created by Mukunda Dhirendrachar on 4/11/17.
//

import UIKit
import WeatherAppModelFramework

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // call framewok methods
        let obj = WeatherAppManager()
        obj.getWeatherReport(city: "Cupertino",
                             success: { (response) in
                                print("View controller received success response : \(response)")
                            },
                             failure: { (error) in
                                print("View controller received error response : \(error)")
                            })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

