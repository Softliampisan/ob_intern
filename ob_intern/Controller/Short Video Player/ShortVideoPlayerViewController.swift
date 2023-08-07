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
import Photos

protocol ShortVideoPlayerDelegate: AnyObject {
    func updateCurrentTime(currentTime: CMTime)
}

class ShortVideoPlayerViewController: UIViewController {

    //MARK: - New Instance
    class func newInstance(post: ShortVideoPost,
                           asset: AVAsset? = nil) -> ShortVideoPlayerViewController {
        let viewController = ShortVideoPlayerViewController(nibName: String(describing: ShortVideoPlayerViewController.self),
                                                       bundle: nil)
        
        let viewModel = ShortVideoPlayerViewModel(delegate: viewController, post: post, asset: asset)
        viewController.viewModel = viewModel
        
        return viewController
    }
    
    //MARK: - IBOutlet
    @IBOutlet weak var viewGradient: UIView!
    @IBOutlet weak var viewVideoInfo: UIView!
    @IBOutlet weak var viewVDO: UIView!
    @IBOutlet weak var viewVideoInfoHeight: NSLayoutConstraint!
    @IBOutlet weak var viewGradientHeight: NSLayoutConstraint!
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var buttonDownload: UIButton!
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        player?.play()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player?.pause()
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
    
    func createVideoPlayer(url: URL? = nil, asset: AVAsset? = nil) {
        
        if let asset = viewModel?.asset as? AVURLAsset {
            player = AVPlayer(url: asset.url)
            buttonBack.setImage(UIImage(systemName: "xmark"), for: .normal)
        } else if let url = url {
            player = AVPlayer(url: url)
        }
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
    
    func checkPhotosAuthorizationStatus() {
        let status = PHPhotoLibrary.authorizationStatus()
        if (status == PHAuthorizationStatus.denied) {
            let alertController = UIAlertController (title: "Please go to settings for access to photo library", message: nil, preferredStyle: .alert)
            let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)")
                    })
                }
            }
            alertController.addAction(settingsAction)
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            alertController.addAction(cancelAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    func downloadSuccessAlert() {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Your video was successfully saved", message: nil, preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func downloadAssetVideo(asset: AVURLAsset) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: asset.url)
        }) { [weak self] saved, error in
            guard let self = self else { return }
            if saved {
                downloadSuccessAlert()
            }
        }
    }
    
    func downloadVideo(url: URL) {
        DispatchQueue.global(qos: .background).async {
            guard let urlData = NSData(contentsOf: url) else { return }
            
            let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0];
            let randomFilename = UUID().uuidString
            let filePath = "\(documentsPath)\(randomFilename).mov"
            DispatchQueue.main.async {
                urlData.write(toFile: filePath, atomically: true)
                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: URL(fileURLWithPath: filePath))
                }) { [weak self] completed, error in
                    guard let self = self else { return }
                    if completed {
                        downloadSuccessAlert()
                    }
                }
            }
        }
    }
    
    
    //MARK: - Action
    //TODO: - check code smell
    @IBAction func buttonBackAction(_ sender: Any) {
        if let currentTime = player?.currentTime() {
            delegate?.updateCurrentTime(currentTime: currentTime)
        }
        AppDirector.sharedInstance().rootViewController?.popToRootViewController(animated: false)
        
    }
    
    
    @IBAction func buttonDownloadAction(_ sender: Any) {
        
        checkPhotosAuthorizationStatus()
        if let asset = viewModel?.asset as? AVURLAsset {
            downloadAssetVideo(asset: asset)
        } else if let url = URL(string: viewModel?.post?.media?.video ?? "") {
            downloadVideo(url: url)
        }
        
    }
    
    
}

extension ShortVideoPlayerViewController: ShortVideoPlayerViewModelDelegate {
    
    func updateMockData() {
        videoInfoView?.config(delegate: self,
                              profileImageURL: viewModel?.post?.user?.profilePic ?? "",
                              profileName: viewModel?.post?.user?.profileName ?? "",
                              postTime: viewModel?.post?.media?.datePosted.convertDateFormat() ?? "",
                              caption: viewModel?.post?.media?.caption ?? "",
                              hashtag: viewModel?.post?.hashtag ?? [])
        if viewModel?.asset != nil {
            createVideoPlayer()
        } else {
            createVideoPlayer(url: URL(string: viewModel?.post?.media?.video ?? ""))

        }
    }
    
    func showAlert(alert: UIAlertController) {
        self.present(alert, animated: true, completion: nil)
    }
    
   
    
    func updateData(video: ShortVideo) {
        videoInfoView?.config(delegate: self,
                              profileImageURL: video.user?.profilePic ?? "",
                              profileName: video.user?.profileName ?? "",
                              postTime: video.media?.datePosted.convertDateFormat() ?? "",
                              caption: video.media?.caption ?? "",
                              hashtag: video.hashtag)
    }
    
    func updateData() {
        videoInfoView?.config(delegate: self,
                              profileImageURL: viewModel?.post?.user?.profilePic ?? "",
                              profileName: viewModel?.post?.user?.profileName ?? "",
                              postTime: viewModel?.post?.media?.datePosted.convertDateFormat() ?? "",
                              caption: viewModel?.post?.media?.caption ?? "",
                              hashtag: viewModel?.post?.hashtag ?? [])
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
        AppDirector.sharedInstance().rootViewController?.pushViewController(controller, animated: true)
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
