//
//  CreatePostButtonView.swift
//  ob_intern
//
//  Created by Soft Liampisan on 10/7/2566 BE.
//

import Foundation
import UIKit

protocol CreatePostButtonViewDelegate: AnyObject {
    func presentPopupMenu()
}

class CreatePostButtonView: InitializeXibView {
    
    weak var delegate: CreatePostButtonViewDelegate?

    @IBOutlet weak var buttonCreate: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        setupButton()
    }
    
    private func setupButton() {
        buttonCreate.layer.cornerRadius = buttonCreate.frame.size.width / 2
        buttonCreate.clipsToBounds = true
        self.addSubview(buttonCreate)

    }
    
    
    @IBAction func tapCreatePostButton(_ sender: Any) {
        delegate?.presentPopupMenu()
    }
    
}
