//
//  ShortVideoPlayerViewModel.swift
//  ob_intern
//
//  Created by Soft Liampisan on 20/6/2566 BE.
//  Copyright (c) 2566 BE ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import UIKit

protocol ShortVideoPlayerViewModelDelegate: AnyObject {
    func showError(error: Error)
    func showLoading()
    func hideLoading()
    func updateData(video: ShortVideo)
    func updateData()
    func showAlert(alert: UIAlertController)
}

class ShortVideoPlayerViewModel {
    
    // MARK: - Properties
    weak var delegate: ShortVideoPlayerViewModelDelegate?
    var currentList: [ShortVideo] = []
    var post: ShortVideoPost?

    //MARK: - Usecase
    
    //MARK: - Init
    init(delegate: ShortVideoPlayerViewModelDelegate, post: ShortVideoPost) {
        self.delegate = delegate
        self.post = post
    }
    
    // MARK: - Functions
    func getVideo() {
        delegate?.showLoading()
        ShortVDOService().getShortVDO { [weak self] video in
            guard let self = self else { return}
            currentList = video
            guard let delegate = delegate else { return }
            if let currentVideo = self.currentList.first {
                delegate.updateData(video: currentVideo)
                
            }
            delegate.hideLoading()
        } errorHandler: { error in
            let alert = UIAlertController(title: "Error", message: "Oops, something went wrong. Please try again later.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.delegate?.showAlert(alert: alert)
        }
    }
    
    func getVideoFromPost() {
        delegate?.updateData()
    }
}
