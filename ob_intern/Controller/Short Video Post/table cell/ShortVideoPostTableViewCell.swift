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

protocol ShortVideoPostTableViewCellDelegate: AnyObject {
    func tapProfileAction(post: ShortVideoPost)
    func tapVideo(post: ShortVideoPost, currentTime: CMTime)
}

class ShortVideoPostTableViewCell: UITableViewCell {

    
    @IBOutlet weak var imageViewPost: UIImageView!
    @IBOutlet weak var viewVDO: UIView!
    @IBOutlet weak var viewProfile: UIView!
    @IBOutlet weak var viewHashtag: SocialPostHashTagView!
    @IBOutlet weak var viewLikeComment: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var labelCaption: UILabel!
    @IBOutlet weak var buttonMute: UIButton!
    
    var profileView: ProfileView?
    var likeCommentView: LikeCommentView?
    var player: AVPlayer?
    var playerLayer = AVPlayerLayer()
    var post: ShortVideoPost?
    weak var delegate: ShortVideoPostTableViewCellDelegate?
    private let notificationCenter = NotificationCenter.default
    

    override func awakeFromNib() {
        super.awakeFromNib()
        setProfile()
        setLikeComment()
        buttonMute.setButtonImage(imageName: "speaker.wave.2", iconColor: .white)
        selectionStyle = .none
        notificationCenter.addObserver(self,
                                       selector: #selector(stopVideo(_:)),
                                       name: NSNotification.Name ("stopVideo"),
                                       object: nil)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.tapVideo))
        self.viewVDO.addGestureRecognizer(gesture)
        playerLayer.frame = viewVDO.bounds

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = viewVDO.bounds
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        player?.pause()
        player = nil
        viewVDO.removePlayerLayer()
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @objc func tapVideo(sender : UITapGestureRecognizer) {
        guard let currentTime = player?.currentTime() else { return }
        guard let post = post else { return }
        delegate?.tapVideo(post: post, currentTime: currentTime)

    }
    
    @objc func stopVideo(_ notification: Notification){
        guard let player = self.player,
              let newPostID = notification.userInfo?["postID"] as? Int,
              let currentPostID = self.post?.postID else { return }
        if newPostID != currentPostID {
            player.pause()

        }
    }
    
    func setData(delegate: ShortVideoPostTableViewCellDelegate,
                 shortVDOPost: ShortVideoPost){
        self.delegate = delegate
        self.post = shortVDOPost
        
        profileView?.imageViewProfilePic.sd_setImage(with: URL(string: post?.user?.profilePic ?? "" ))
        profileView?.labelProfileName.text = post?.user?.profileName
        profileView?.labelPostTime.text = post?.media?.datePosted
        //imageViewPost.sd_setImage(with: URL(string: postImageURL))

        if let videoURL = URL(string: post?.media?.video ?? "") {
            createVideoPlayer(url: videoURL)
            checkMuteState()

        }
        viewHashtag.setData(hashtags: post?.hashtag ?? [])
        viewHashtag.isHidden = (post?.hashtag == [])
        viewHashtag.layoutIfNeeded()
        labelCaption.text = post?.media?.caption
        labelCaption.sizeToFit()
        labelCaption.isHidden = (post?.media?.caption == "")
        likeCommentView?.labelNumLikes.text = post?.numberOfLikes
        likeCommentView?.labelNumComments.text = post?.numberOfComments

    }
    
    func createVideoPlayer(url: URL) {
        player = AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.frame = viewVDO.bounds
        viewVDO.layer.addSublayer(playerLayer)
    }
    
    func setProfile() {
        profileView = ProfileView(frame: viewProfile.bounds)
        profileView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        profileView?.clipsToBounds = true
        if let profileView = profileView {
            viewProfile.addSubview(profileView)
        }
        profileView?.delegate = self
        
    }
    
    func setLikeComment() {
        likeCommentView = LikeCommentView(frame: viewLikeComment.bounds)
        likeCommentView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        likeCommentView?.clipsToBounds = true
        if let likeCommentView = likeCommentView {
            viewLikeComment.addSubview(likeCommentView)
        }

    }
    
    func checkMuteState() {
        if ShortVideoManager.isMute == true {
            player?.volume = 0.0
        }
        let buttonImage = ShortVideoManager.isMute ? "speaker.slash" : "speaker.wave.2"
        buttonMute.setButtonImage(imageName: buttonImage, iconColor: .white)
    }
    
    func checkFirstLoad() {
        if ShortVideoManager.isFirstLoad == true {
            player?.play()
        }
    }
    
    func setPlayerTime(time: CMTime) {
        player?.seek(to: time)
        player?.play()
    }
    
    func pauseVideo() {
        player?.pause()
    }
    
    
    @IBAction func buttonMuteAction(_ sender: Any) {
        ShortVideoManager.isMute.toggle()
        player?.volume = ShortVideoManager.isMute ? 0.0 : 1.0
        let buttonImage = ShortVideoManager.isMute ? "speaker.slash" : "speaker.wave.2"
        buttonMute.setButtonImage(imageName: buttonImage, iconColor: .white)
    }
    
}

extension ShortVideoPostTableViewCell: ProfileViewDelegate {
    func tapProfile() {
        guard let post = post else { return }
        delegate?.tapProfileAction(post: post)
    }
    
    
}
