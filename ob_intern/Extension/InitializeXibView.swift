//
//  InitializeXibView.swift
//  ob_intern
//
//  Created by Soft Liampisan on 14/6/2566 BE.
//

import Foundation
import UIKit

class InitializeXibView: UIView {
    
    var view: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    func xibSetup() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView
        view.frame = bounds
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        self.layoutIfNeeded()
        addSubview(view)
        self.layoutIfNeeded()
    }
}
