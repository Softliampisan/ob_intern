//
//  Profile.swift
//  ob_intern
//
//  Created by Soft Liampisan on 19/6/2566 BE.
//

import Foundation
import UIKit

class Profile: InitializeXibView {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageViewProfilePic: UIImageView!
    @IBOutlet weak var labelProfileName: UILabel!
    @IBOutlet weak var labelPostTime: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpValues()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpValues()
    }
    
    private func setUpValues() {
        setupContainerView()
        setupImageAndLabel()
    }
    private func setupContainerView() {
        containerView.layer.masksToBounds = true
        self.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setupImageAndLabel() {
        imageViewProfilePic.layer.cornerRadius = imageViewProfilePic.frame.size.width / 2
        imageViewProfilePic.clipsToBounds = true
        
        containerView.addSubview(imageViewProfilePic)
        containerView.addSubview(labelProfileName)
        containerView.addSubview(labelPostTime)

    }
    

}
