//
//  EditVideoTimelineViewController.swift
//  ob_intern
//
//  Created by Soft Liampisan on 9/6/2566 BE.
//  Copyright (c) 2566 BE ___ORGANIZATIONNAME___. All rights reserved.

import UIKit

class EditVideoTimelineViewController: UIViewController {

    //MARK: - New Instance
    class func newInstance() -> EditVideoTimelineViewController {
        let viewController = EditVideoTimelineViewController(nibName: String(describing: EditVideoTimelineViewController.self),
                                                       bundle: nil)
        
        let viewModel = EditVideoTimelineViewModel(delegate: viewController)
        viewController.viewModel = viewModel
        
        return viewController
    }
    
    //MARK: - IBOutlet
    @IBOutlet weak var buttonCancel: UIButton!
    @IBOutlet weak var buttonAgree: UIButton!
    @IBOutlet weak var labelSelectCover: UILabel!
    @IBOutlet weak var imageViewVideo: UIImageView!
    
    //MARK: - Parameters
    private var viewModel: EditVideoTimelineViewModel?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    //MARK: - Functions
    func setupView() {
        imageViewVideo.layer.cornerRadius = 21
        imageViewVideo.clipsToBounds = true
        imageViewVideo.sd_setImage(with: URL(string: "https://i.pinimg.com/originals/31/9f/f9/319ff939cbca334407451fa12613783e.jpg"))
        self.navigationController?.isNavigationBarHidden = true

    }
    
    //MARK: - Action
    @IBAction func buttonCancelAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}

extension EditVideoTimelineViewController: EditVideoTimelineViewModelDelegate {
    
    func showError(error: Error) {
        
    }
    
    func showLoading() {
        
    }
    
    func hideLoading() {
        
    }
    
}

