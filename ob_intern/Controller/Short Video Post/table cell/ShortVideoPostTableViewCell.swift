//
//  ShortVideoPostTableViewCell.swift
//  ob_intern
//
//  Created by Soft Liampisan on 15/6/2566 BE.
//

import UIKit

class ShortVideoPostTableViewCell: UITableViewCell {

    @IBOutlet weak var imageViewPost: UIImageView!
    @IBOutlet weak var viewVDO: UIView!
    @IBOutlet weak var viewProfile: UIView!
    @IBOutlet weak var viewHashtag: UIView!
    @IBOutlet weak var viewLikeComment: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var labelCaption: UILabel!

    let gradient: CAGradientLayer = CAGradientLayer()

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setViewProfileDesign(colorOne: .black.withAlphaComponent(0.8), colorTwo: .clear)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradient.frame = viewProfile.bounds //if this is removed, the gradient doesn't fill the view
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setViewProfileDesign(colorOne: UIColor, colorTwo: UIColor) {
        let colors = [colorOne.cgColor, colorTwo.cgColor]
        gradient.frame = viewProfile.bounds
        gradient.colors = colors
        viewProfile.layer.insertSublayer(gradient, at: 0)
        
    }
    
    func setData(caption: String,
                 imageURL: String,
                 hashtag: Bool){
        
        labelCaption.text = caption
        imageViewPost.sd_setImage(with: URL(string: imageURL))
        viewHashtag.isHidden = !hashtag
        viewHashtag.layoutIfNeeded()
        labelCaption.sizeToFit()
        labelCaption.isHidden = caption.isEmpty
    }
    
 
    
}


