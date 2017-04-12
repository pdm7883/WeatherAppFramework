//
//  UILabel+Extension.swift
//  WeatherApp
//
//  Created by Mukunda Dhirendrachar on 4/11/17.
//

import UIKit

extension UILabel {
    func startBlink () {
        self.alpha = 0.0
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       options: [.autoreverse, .repeat],
                       animations: {self.alpha = 1.0},
                       completion: nil)
    }
}
