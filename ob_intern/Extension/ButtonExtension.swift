//
//  BackButtonExtension.swift
//  ob_intern
//
//  Created by Soft Liampisan on 28/6/2566 BE.
//

import Foundation
import UIKit

extension UIButton {
    func setButtonImage(imageName: String? = nil,
                        iconColor: UIColor){
        
        if let imageName = imageName,
           let image = UIImage(systemName: imageName) {
            
            let colorImage = image.withTintColor(iconColor, renderingMode: .alwaysOriginal)
            self.setImage(colorImage, for: .normal)
            
        }
    }
}
