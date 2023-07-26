//
//  UIImageExtension.swift
//  ob_intern
//
//  Created by Soft Liampisan on 20/7/2566 BE.
//

import Foundation
import UIKit

extension UIImage {
   
    func dataWithImageResizeMaxWidthOrHeightValue(value : CGFloat) -> UIImage? {
        let width = self.size.width
        let height = self.size.height
        
        let ratio = width/height
        
        var newWidth = value
        var newHeight = value
        
        if ratio > 1 {
            newWidth = width * (newHeight/height)
        } else {
            newHeight = height * (newWidth/width)
        }
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: newWidth, height: newHeight), false, 0)
        
        draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
}
