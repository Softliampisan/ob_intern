//
//  ShortVideoPlayerViewController.swift
//  ob_intern
//
//  Created by Soft Liampisan on 20/6/2566 BE.
//  Copyright (c) 2566 BE ___ORGANIZATIONNAME___. All rights reserved.
import SDWebImage
import UIKit
import AVFoundation
import AVKit

protocol ShortVideoPlayerDelegate: AnyObject {
    func updateCurrentTime(currentTime: CMTime)
}

class ShortVideoPlayerViewController: UIViewController {

    //MARK: - New Instance
    class func newInstance(post: ShortVideoPost) -> ShortVideoPlayerViewController {
        let viewController = ShortVideoPlayerViewController(nibName: String(describing: ShortVideoPlayerViewController.self),
                                                       bundle: nil)
        
        let viewModel = ShortVideoPlayerViewModel(delegate: viewController, post: post)
        viewController.viewModel = viewModel
        
        return viewController
    }
    
    //MARK: - IBOutlet
    @IBOutlet weak var viewGradient: UIView!
    @IBOutlet weak var viewVideoInfo: UIView!
    @IBOutlet weak var imageViewVideo: UIImageView!
    @IBOutlet weak var viewVDO: UIView!
    @IBOutlet weak var viewVideoInfoHeight: NSLayoutConstraint!
    @IBOutlet weak var viewGradientHeight: NSLayoutConstraint!
    @IBOutlet weak var buttonBack: UIButton!
    
    //MARK: - Parameters
    private var viewModel: ShortVideoPlayerViewModel?
    private var videoInfoDelegate: VideoInfoViewDelegate?
    var videoInfoView: VideoInfoView?
    let mockImageUrls: [String] = ["https://images3.alphacoders.com/110/1108129.jpg",
                                   "https://wallpaperaccess.com/full/6193236.jpg",
                                   "https://imgix.bustle.com/uploads/image/2022/2/11/c277a32f-c52c-4d7a-98ea-1a0bbec3cf2d-baby-yoda-use-the-force.jpg?w=1200&h=630&fit=crop&crop=focalpoint&fm=jpg&fp-x=0.4813&fp-y=0.3059",
                                   "https://i.pinimg.com/originals/4e/52/2d/4e522df5de3a6903cf2272572eb471aa.jpg"]
    let profileName: [String] = ["eewarnruk", "soft.liampisan", "goft"]
    var caption: [String] = ["Lorem Ipsum is simply dummy text of the printingaii and indust Lorem Ipsum is simply dummy text dummy Lorem Ipsum is simply dummy text of the printingaii and indust Lorem Ipsum is simply dummy text simply dum Lorem Ipsum is simply dummy text of the printingaii and indust Lorem Ipsum is simply dummy text dummy Lorem Ipsum is simply dummy text of the printingaii and indust Lorem Ipsum is simply dummy text simply dum Lorem Ipsum is simply dummy text of the printingaii and indust Lorem Ipsum is simply dummy text dummy Lorem Ipsum is simply dummy text of the printingaii and indust Lorem Ipsum is simply dummy text simply dum Lorem Ipsum is simply dummy text of the printingaii and indust Lorem Ipsum is simply dummy text dummy Lorem Ipsum is simply dummy text of the printingaii and indust Lorem Ipsum is simply dummy text simply dum", "Lorem Ipsum is simply dummy text of the printingaii and indust Lorem Ipsum is simply dummy text dummy Lorem Ipsum is simply dummy text of the printingaii and indust Lorem Ipsum is simply dummy text simply dum Lorem Ipsum is simply dummy text of the printingaii and indust Lorem Ipsum is simply dummy text dummy Lorem Ipsum is simply dummy text ", "Lorem Ipsum is"]
    private let MAX_SCREEN_RATIO = 0.4
    private var activityView = UIActivityIndicatorView(style: .large)
    var player: AVPlayer?
    var playerLayer = AVPlayerLayer()
    var currentTime: CMTime?
    var post: ShortVideoPost?
    weak var delegate: ShortVideoPlayerDelegate?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupVideoInfo()
        viewModel?.getVideoFromPost()

    }
    override func viewDidLayoutSubviews() {
        playerLayer.frame = viewVDO.bounds
    }

    
    //MARK: - Functions
    func setupView() {
        viewVideoInfo.backgroundColor = .clear
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func setupVideoInfo(){
        videoInfoView = VideoInfoView(frame: viewVideoInfo.bounds)
        videoInfoView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        videoInfoView?.clipsToBounds = true
        if let videoInfoView = videoInfoView {
            viewVideoInfo.addSubview(videoInfoView)
        }
    }
    
    func createVideoPlayer(url: URL) {
        player = AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.frame = viewVDO.bounds
        viewVDO.layer.addSublayer(playerLayer)
        if let currentTime = currentTime {
            player?.seek(to: currentTime)
        }
        player?.play()
    }
    
    func showActivityIndicator() {
        self.activityView = UIActivityIndicatorView(style: .large)
        self.activityView.center = self.view.center
        self.view.addSubview(self.activityView)
        self.activityView.startAnimating()
        
    }
    
    func hideActivityIndicator() {
        self.activityView.stopAnimating()
        self.activityView.removeFromSuperview()
    }
    
    
    //MARK: - Action
    @IBAction func buttonBackAction(_ sender: Any) {
        if let currentTime = player?.currentTime() {
            delegate?.updateCurrentTime(currentTime: currentTime)
        }
        self.navigationController?.popViewController(animated: true)
        
    }
    
   
    
}

extension ShortVideoPlayerViewController: ShortVideoPlayerViewModelDelegate {
    func showAlert(alert: UIAlertController) {
        self.present(alert, animated: true, completion: nil)
    }
    
   
    
    func updateData(video: ShortVideo) {
        videoInfoView?.config(delegate: self,
                              profileImageURL: video.user?.profilePic ?? "",
                              profileName: video.user?.profileName ?? "",
                              postTime: video.media?.datePosted ?? "",
                              caption: video.media?.caption ?? "",
                              hashtag: video.hashtag)
        imageViewVideo.sd_setImage(with: URL(string: video.media?.coverImage ?? ""))
    }
    
    func updateData() {
        videoInfoView?.config(delegate: self,
                              profileImageURL: viewModel?.post?.user?.profilePic ?? "",
                              profileName: viewModel?.post?.user?.profileName ?? "",
                              postTime: viewModel?.post?.media?.datePosted ?? "",
                              caption: viewModel?.post?.media?.caption ?? "",
                              hashtag: viewModel?.post?.hashtag ?? [])
        imageViewVideo.sd_setImage(with: URL(string: viewModel?.post?.media?.coverImage ?? ""))
        if let videoURL = URL(string: viewModel?.post?.media?.video ?? "") {
            createVideoPlayer(url: videoURL)
        }
    }
    
    func showError(error: Error) {
        
    }
    
    func showLoading() {
        self.showActivityIndicator()
    }
    
    func hideLoading() {
        self.hideActivityIndicator()
    }
    
}

extension ShortVideoPlayerViewController: VideoInfoViewDelegate {
    func tapProfile() {
        player?.pause()
        guard let post = viewModel?.post else { return }
        let controller = ShortVideoListViewController.newInstance(post: post)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func updateHeight(height: CGFloat) {
        viewVideoInfoHeight.constant = height
        viewGradientHeight.constant = viewVideoInfoHeight.constant
        viewGradient.layoutIfNeeded()

        let maxHeight = UIScreen.main.bounds.height * MAX_SCREEN_RATIO
        if viewVideoInfoHeight.constant > maxHeight {
            viewVideoInfoHeight.constant = maxHeight
            viewGradientHeight.constant = viewVideoInfoHeight.constant
            self.viewWillLayoutSubviews()
        }
        
        viewGradient.layoutIfNeeded()
    }
    
    
}
