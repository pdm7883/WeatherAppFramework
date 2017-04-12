//
//  UIViewController+Alerts.swift
//  WeatherApp
//
//  Created by Mukunda Dhirendrachar on 4/11/17.
//

import UIKit

extension UIViewController {
    // Helper to present a simple alert to the user
    
    func alert(title: String, message: String, completion: (() -> Void)! = nil) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: { () -> Void in
            completion?()
        })
    }
}
