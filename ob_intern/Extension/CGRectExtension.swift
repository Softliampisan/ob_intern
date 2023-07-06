//
//  CGRectExtension.swift
//  ob_intern
//
//  Created by Soft Liampisan on 5/7/2566 BE.
//

import Foundation

extension CGRect {
    var center: CGPoint {
        return CGPoint(x: self.midX, y: self.midY)
    }
}
