//
//  AppDelegate.swift
//  WeatherApp
//
//  Created by Mukunda Dhirendrachar on 4/11/17.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let nav = storyboard.instantiateInitialViewController()! as! UINavigationController
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        
        // configure app with default settings and have such methods and helpers to bootstrap the app to init any services
        WeatherAppDefaults.configureDefaults()

        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // perform auto lookup on last saved search query and display
        
        let nav = self.window?.rootViewController as! UINavigationController
        if let vc = nav.visibleViewController as? ViewController {
            vc.searchButtonAction(nil)
        }
    }
}

