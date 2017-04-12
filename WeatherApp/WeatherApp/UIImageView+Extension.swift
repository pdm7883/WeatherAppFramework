//
//  UIImageView+Extension.swift
//  WeatherApp
//
//  Created by Mukunda Dhirendrachar on 4/11/17.
//

import UIKit

extension UIImageView {
    
    func moveLeftToRight () {
        UIView.animate(withDuration: 20.0,
                       delay: 0.0,
                       options: [.repeat, .curveLinear],
                       animations: {
                        self.frame = self.frame.offsetBy(dx: self.frame.width+400, dy: 0.0)
        },
                       completion: nil)
    }
}
