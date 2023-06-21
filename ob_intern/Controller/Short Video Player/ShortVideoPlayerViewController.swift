//
//  ShortVideoPlayerViewController.swift
//  ob_intern
//
//  Created by Soft Liampisan on 20/6/2566 BE.
//  Copyright (c) 2566 BE ___ORGANIZATIONNAME___. All rights reserved.

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
    
    //MARK: - Parameters
    private var viewModel: ShortVideoPlayerViewModel?
    var videoInfoView: VideoInfoView?
    let gradient: CAGradientLayer = CAGradientLayer()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setData()
        setGradient()
    }
    override func viewWillLayoutSubviews() {
        gradient.frame = viewGradient.bounds
    }
    
    //MARK: - Functions
    func setupView() {
        setupVideoInfo()
        gradient.frame = viewGradient.bounds
        viewVideoInfo.backgroundColor = .clear
        
    }
    
    func setData() {
        imageViewVideo.sd_setImage(with: URL(string: "https://imgix.bustle.com/uploads/image/2022/2/11/c277a32f-c52c-4d7a-98ea-1a0bbec3cf2d-baby-yoda-use-the-force.jpg?w=1200&h=630&fit=crop&crop=focalpoint&fm=jpg&fp-x=0.4813&fp-y=0.3059"))
    }
    
    func setupVideoInfo(){
        videoInfoView = VideoInfoView(frame: viewVideoInfo.bounds)
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

