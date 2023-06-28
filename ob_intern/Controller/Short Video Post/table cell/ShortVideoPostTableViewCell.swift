//
//  ShortVideoPostTableViewCell.swift
//  ob_intern
//
//  Created by Soft Liampisan on 15/6/2566 BE.
//

import SDWebImage
import UIKit

class ShortVideoPostTableViewCell: UITableViewCell {

    @IBOutlet weak var imageViewPost: UIImageView!
    @IBOutlet weak var viewVDO: UIView!
    @IBOutlet weak var viewProfile: UIView!
    @IBOutlet weak var viewHashtag: SocialPostHashTagView!
    @IBOutlet weak var viewLikeComment: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var labelCaption: UILabel!

    let gradient: CAGradientLayer = CAGradientLayer()
    var profileView: ProfileView?
    var likeCommentView: LikeCommentView?

    override func awakeFromNib() {
        super.awakeFromNib()
        setProfile()
        setLikeComment()
        DispatchQueue.main.async {
            self.setViewProfileDesign()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageViewPost.image = nil 
        removeGradientBackground()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradient.frame = viewProfile.bounds //if this is removed, the gradient doesn't fill the view
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setViewProfileDesign() {
        let colors = [UIColor.black.withAlphaComponent(0.8).cgColor, UIColor.clear.cgColor]
        gradient.frame = viewProfile.bounds
        gradient.colors = colors
        viewProfile.layer.insertSublayer(gradient, at: 0)
        
    }
    
    func setData(profilePicURL: String,
                 profileName: String,
                 caption: String,
                 postImageURL: String,
                 hashtag: [String],
                 numLikes: String,
                 numComments: String,
                 datePosted: String){
        profileView?.imageViewProfilePic.sd_setImage(with: URL(string: profilePicURL))
        profileView?.labelProfileName.text = profileName
        profileView?.labelPostTime.text = datePosted
        imageViewPost.sd_setImage(with: URL(string: postImageURL))
        viewHashtag.setData(hashtags: hashtag)
        viewHashtag.isHidden = hashtag.isEmpty
        viewHashtag.layoutIfNeeded()
        labelCaption.text = caption
        labelCaption.sizeToFit()
        labelCaption.isHidden = caption.isEmpty
        likeCommentView?.labelNumLikes.text = numLikes
        likeCommentView?.labelNumComments.text = numComments

    }
    
    func setProfile() {
        profileView = ProfileView(frame: viewProfile.bounds)
        profileView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        profileView?.clipsToBounds = true
        if let profileView = profileView {
            viewProfile.addSubview(profileView)
        }
        
    }
    
    func setLikeComment() {
        likeCommentView = LikeCommentView(frame: viewLikeComment.bounds)
        likeCommentView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        likeCommentView?.clipsToBounds = true
        if let likeCommentView = likeCommentView {
            viewLikeComment.addSubview(likeCommentView)
        }

    }
 
}


