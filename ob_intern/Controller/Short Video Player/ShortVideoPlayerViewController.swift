//
//  ShortVideoPlayerViewController.swift
//  ob_intern
//
//  Created by Soft Liampisan on 20/6/2566 BE.
//  Copyright (c) 2566 BE ___ORGANIZATIONNAME___. All rights reserved.
import SDWebImage
import UIKit

class ShortVideoPlayerViewController: UIViewController {

    //MARK: - New Instance
    class func newInstance() -> ShortVideoPlayerViewController {
        let viewController = ShortVideoPlayerViewController(nibName: String(describing: ShortVideoPlayerViewController.self),
                                                       bundle: nil)
        
        let viewModel = ShortVideoPlayerViewModel(delegate: viewController)
        viewController.viewModel = viewModel
        
        return viewController
    }
    
    //MARK: - IBOutlet
    @IBOutlet weak var viewGradient: UIView!
    @IBOutlet weak var viewVideoInfo: UIView!
    @IBOutlet weak var imageViewVideo: UIImageView!
    @IBOutlet weak var viewVideoInfoHeight: NSLayoutConstraint!
    @IBOutlet weak var viewGradientHeight: NSLayoutConstraint!
    
    //MARK: - Parameters
    private var viewModel: ShortVideoPlayerViewModel?
    private var videoInfoViewModel: VideoInfoViewModelDelegate?
    var videoInfoView: VideoInfoView?
    let gradient: CAGradientLayer = CAGradientLayer()
    var mockImageUrls: [String] = ["https://images3.alphacoders.com/110/1108129.jpg",
                                   "https://wallpaperaccess.com/full/6193236.jpg",
                                   "https://imgix.bustle.com/uploads/image/2022/2/11/c277a32f-c52c-4d7a-98ea-1a0bbec3cf2d-baby-yoda-use-the-force.jpg?w=1200&h=630&fit=crop&crop=focalpoint&fm=jpg&fp-x=0.4813&fp-y=0.3059",
                                   "https://i.pinimg.com/originals/4e/52/2d/4e522df5de3a6903cf2272572eb471aa.jpg"]
    var profileName: [String] = ["eewarnruk", "soft.liampisan", "goft"]
    var caption: [String] = ["Lorem Ipsum is simply dummy text of the printingaii and indust Lorem Ipsum is simply dummy text dummy Lorem Ipsum is simply dummy text of the printingaii and indust Lorem Ipsum is simply dummy text simply dum Lorem Ipsum is simply dummy text of the printingaii and indust Lorem Ipsum is simply dummy text dummy Lorem Ipsum is simply dummy text of the printingaii and indust Lorem Ipsum is simply dummy text simply dum Lorem Ipsum is simply dummy text of the printingaii and indust Lorem Ipsum is simply dummy text dummy Lorem Ipsum is simply dummy text of the printingaii and indust Lorem Ipsum is simply dummy text simply dum Lorem Ipsum is simply dummy text of the printingaii and indust Lorem Ipsum is simply dummy text dummy Lorem Ipsum is simply dummy text of the printingaii and indust Lorem Ipsum is simply dummy text simply dum", "Lorem Ipsum is simply dummy text of the printingaii and indust Lorem Ipsum is simply dummy text dummy Lorem Ipsum is simply dummy text of the printingaii and indust Lorem Ipsum is simply dummy text simply dum Lorem Ipsum is simply dummy text of the printingaii and indust Lorem Ipsum is simply dummy text dummy Lorem Ipsum is simply dummy text ", "Lorem Ipsum is"]
    
   
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setData()
        setGradient()
    }
    override func viewWillLayoutSubviews() {
//        UIView.animate(withDuration: 0.2, animations: {
        
        DispatchQueue.main.async {
            self.gradient.frame = self.viewGradient.bounds
//                    }, completion: { [weak self] _ in
//            //            self?.viewGradient.isHidden = false
//                    })
//
//
        }
    }
    
    //MARK: - Functions
    func setupView() {
        setupVideoInfo()
        viewVideoInfo.backgroundColor = .clear
        
    }
    
    func setData() {
        imageViewVideo.sd_setImage(with: URL(string: "https://imgix.bustle.com/uploads/image/2022/2/11/c277a32f-c52c-4d7a-98ea-1a0bbec3cf2d-baby-yoda-use-the-force.jpg?w=1200&h=630&fit=crop&crop=focalpoint&fm=jpg&fp-x=0.4813&fp-y=0.3059"))
        videoInfoView?.config(profileImageURL: mockImageUrls.randomElement() ?? "",
                              profileName: profileName.randomElement() ?? "",
                              postTime: "just now",
                              caption: caption.randomElement(),
                              hashtag: ["netflix", "movie", "music"])
    }
    
    func setupVideoInfo(){
        videoInfoView = VideoInfoView(frame: viewVideoInfo.bounds)
        videoInfoView?.delegate = self
        videoInfoView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        videoInfoView?.clipsToBounds = true
        if let videoInfoView = videoInfoView {
            viewVideoInfo.addSubview(videoInfoView)
        }
    }
    
    func setGradient() {
        let colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.6).cgColor]
        gradient.frame = viewGradient.bounds
        gradient.colors = colors
        viewGradient.clipsToBounds = true
        viewGradient.layer.insertSublayer(gradient, at: 0)
        
    }
    
   
    //MARK: - Action
    
}

extension ShortVideoPlayerViewController: ShortVideoPlayerViewModelDelegate {
    
    func showError(error: Error) {
        
    }
    
    func showLoading() {
        
    }
    
    func hideLoading() {
        
    }
    
}

extension ShortVideoPlayerViewController: VideoInfoViewModelDelegate {
    func updateHeight(height: CGFloat) {
        //viewVideoInfo.layoutIfNeeded()
//        videoInfoView?.frame = CGRect(x: videoInfoView?.frame.origin.x ?? 0,
//                                      y: videoInfoView?.frame.origin.y ?? 0,
//                                      width: videoInfoView?.frame.width ?? 0,
//                                      height: viewVideoInfo.frame.height)
        viewVideoInfoHeight.constant = height
        viewGradientHeight.constant = viewVideoInfoHeight.constant
        viewGradient.layoutIfNeeded()

        let maxHeight = UIScreen.main.bounds.height * 0.4
        if viewVideoInfoHeight.constant > maxHeight {
            viewVideoInfoHeight.constant = maxHeight
            viewGradientHeight.constant = viewVideoInfoHeight.constant
//            UIView.animate(withDuration: 1) {
//                viewToAnimate.alpha = 0
//            }
//            viewGradient.frame = CGRect(x: viewGradient.frame.origin.x,
//                                        y: viewGradient.frame.origin.y,
//                                        width: viewGradient.frame.width,
//                                        height: viewGradientHeight.constant)
                
            self.viewWillLayoutSubviews()
        }
        
        viewGradient.layoutIfNeeded()
    }
    
    
}
