//
//  Gradient.swift
//  ob_intern
//
//  Created by Soft Liampisan on 15/6/2566 BE.
//

import Foundation
import UIKit

extension UIView {

    public func setGradient(colorOne: UIColor, colorTwo: UIColor) {

        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        
        layer.insertSublayer(gradient, at: 0)
    }
}
