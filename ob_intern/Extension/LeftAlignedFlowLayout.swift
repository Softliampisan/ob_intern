//
//  LeftAlignedFlowLayout.swift
//  ob_intern
//
//  Created by Soft Liampisan on 27/6/2566 BE.
//

import Foundation
import UIKit

class LeftAlignedFlowLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let originalAttributes = super.layoutAttributesForElements(in: rect) else {
            return nil
        }
        var leftMargin: CGFloat = 0.0
        var lastY: Int = 0
        return originalAttributes.map {
            let changedAttribute = $0
            if Int(changedAttribute.center.y.rounded()) != lastY {
                leftMargin = sectionInset.left
            }
            changedAttribute.frame.origin.x = leftMargin
            lastY = Int(changedAttribute.center.y.rounded())
            leftMargin += changedAttribute.frame.width + minimumInteritemSpacing
            return changedAttribute
        }
    }
}
