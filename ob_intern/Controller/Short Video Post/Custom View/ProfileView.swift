//
//  Profile.swift
//  ob_intern
//
//  Created by Soft Liampisan on 19/6/2566 BE.
//

import Foundation
import UIKit
//import SkeletonView

protocol ProfileViewDelegate: AnyObject {
    func tapProfile()
}

class ProfileView: InitializeXibView {
    
    // MARK: - Properties
    weak var delegate: ProfileViewDelegate?

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageViewGradient: UIImageView!
    @IBOutlet weak var imageViewProfilePic: UIImageView!
    @IBOutlet weak var labelProfileName: UILabel!
    @IBOutlet weak var labelPostTime: UILabel!
    @IBOutlet weak var buttonToProfile: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        setupContainerView()
        setupImageAndLabel()
    }
    private func setupContainerView() {
        containerView.layer.masksToBounds = true
        self.addSubview(containerView)
        containerView.addSubview(imageViewGradient)
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
        containerView.addSubview(buttonToProfile)

    }
    
    
    @IBAction func tapProfile(_ sender: Any) {
        delegate?.tapProfile()
    }
    

}
