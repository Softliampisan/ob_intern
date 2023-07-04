//
//  PaddingLabel.swift
//  ob_intern
//
//  Created by Soft Liampisan on 9/6/2566 BE.
//

import Foundation
//
//  PaddingLabel.swift
//  Joy
//
//  Created by Pat Pawasantanon on 21/8/20.
//  Copyright © 2020 ookbee. All rights reserved.
//

import UIKit

class PaddingLabel: UILabel {

    @IBInspectable var topInset: CGFloat = 5.0
    @IBInspectable var bottomInset: CGFloat = 5.0
    @IBInspectable var leftInset: CGFloat = 5.0
    @IBInspectable var rightInset: CGFloat = 5.0

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        get {
            var contentSize = super.intrinsicContentSize
            contentSize.height += topInset + bottomInset
            contentSize.width += leftInset + rightInset
            return contentSize
        }
    }
}
