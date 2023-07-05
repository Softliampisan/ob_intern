//
//  ShortVideoPostTableViewCell.swift
//  ob_intern
//
//  Created by Soft Liampisan on 15/6/2566 BE.
//

import SDWebImage
import UIKit
import AVFoundation
import AVKit

class ShortVideoPostTableViewCell: UITableViewCell {

    @IBOutlet weak var imageViewPost: UIImageView!
    @IBOutlet weak var viewVDO: UIView!
    @IBOutlet weak var viewProfile: UIView!
    @IBOutlet weak var viewHashtag: SocialPostHashTagView!
    @IBOutlet weak var viewLikeComment: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var labelCaption: UILabel!

    var profileView: ProfileView?
    var likeCommentView: LikeCommentView?
    var player: AVPlayer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setProfile()
        setLikeComment()        
        selectionStyle = .none
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    
    func setData(profilePicURL: String,
                 profileName: String,
                 caption: String,
                 postImageURL: String,
                 videoURL: String,
                 hashtag: [String],
                 numberOfLikes: String,
                 numberOfComments: String,
                 datePosted: String){
        profileView?.imageViewProfilePic.sd_setImage(with: URL(string: profilePicURL))
        profileView?.labelProfileName.text = profileName
        profileView?.labelPostTime.text = datePosted
        //imageViewPost.sd_setImage(with: URL(string: postImageURL))
        
        let videoURL = URL(string: "https://samplelib.com/lib/preview/mp4/sample-5s.mp4")
        player = AVPlayer(url: videoURL!)
        print("vid url \(videoURL)")
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = viewVDO.bounds
        playerLayer.backgroundColor = UIColor.red.cgColor
        viewVDO.layer.addSublayer(playerLayer)
        player?.play()
      
        
        viewHashtag.setData(hashtags: hashtag)
        viewHashtag.isHidden = hashtag.isEmpty
        viewHashtag.layoutIfNeeded()
        labelCaption.text = caption
        labelCaption.sizeToFit()
        labelCaption.isHidden = caption.isEmpty
        likeCommentView?.labelNumLikes.text = numberOfLikes
        likeCommentView?.labelNumComments.text = numberOfComments

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


