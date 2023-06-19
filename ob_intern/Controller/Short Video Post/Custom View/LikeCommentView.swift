//
//  LikeComment.swift
//  ob_intern
//
//  Created by Soft Liampisan on 19/6/2566 BE.
//

import Foundation
import UIKit

class LikeCommentView: InitializeXibView {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageLike: UIImageView!
    @IBOutlet weak var imageComment: UIImageView!
    @IBOutlet weak var labelNumLikes: UILabel!
    @IBOutlet weak var labelNumComments: UILabel!
    
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
        setupLikeComment()
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
    
    private func setupLikeComment() {
        containerView.addSubview(imageLike)
        containerView.addSubview(imageComment)
        containerView.addSubview(labelNumLikes)
        containerView.addSubview(labelNumComments)
    }
    
}
