//
//  Gradient.swift
//  ob_intern
//
//  Created by Soft Liampisan on 15/6/2566 BE.
//

import Foundation
import UIKit

extension UIView {

    func removeGradientBackground() {
        self.layer.sublayers?.forEach {
            if $0.isKind(of: CAGradientLayer.self) {
                $0.removeFromSuperlayer()
            }
        }
    }
}
