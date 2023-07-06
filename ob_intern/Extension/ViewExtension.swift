//
//  Gradient.swift
//  ob_intern
//
//  Created by Soft Liampisan on 15/6/2566 BE.
//

import Foundation
import UIKit
import AVFoundation

extension UIView {

    func removeGradientBackground() {
        self.layer.sublayers?.forEach {
            if $0.isKind(of: CAGradientLayer.self) {
                $0.removeFromSuperlayer()
            }
        }
    }
    
 
    func removePlayerLayer() {
        self.layer.sublayers?.forEach {
            if $0.isKind(of: AVPlayerLayer.self) {
                $0.removeFromSuperlayer()
            }
        }
    }

}
