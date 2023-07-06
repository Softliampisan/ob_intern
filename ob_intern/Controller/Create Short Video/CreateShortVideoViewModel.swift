//
//  CreateShortVideoViewModel.swift
//  ob_intern
//
//  Created by Soft Liampisan on 8/6/2566 BE.
//  Copyright (c) 2566 BE ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import UIKit

protocol CreateShortVideoViewModelDelegate: AnyObject {
    func showError(error: Error)
    func showLoading()
    func hideLoading()
    func showAlert(alert: UIAlertController)
    func isPostSuccess()
}

class CreateShortVideoViewModel {
    
    // MARK: - Properties
    weak var delegate: CreateShortVideoViewModelDelegate?
    
    //MARK: - Usecase
    
    //MARK: - Init
    init(delegate: CreateShortVideoViewModelDelegate) {
        self.delegate = delegate
    }
    
    // MARK: - Functions
    func createShortVDO(coverImageURL: String,
                        caption: String,
                        isAllowComments: Bool,
                        isPublic: Bool,
                        isAllowGifts: Bool) {
        delegate?.showLoading()
        ShortVDOService().createShortVDO(coverImageURL: coverImageURL,
                                         caption: caption,
                                         isAllowComments: isAllowComments,
                                         isPublic: isPublic,
                                         isAllowGifts: isAllowGifts) {
            self.delegate?.hideLoading()
            let alert = UIAlertController(title: "Success", message: "Your post has been uploaded", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                (action) in
                self.delegate?.isPostSuccess()
            }))
            self.delegate?.showAlert(alert: alert)
            
            
        } errorHandler: { error in
            let alert = UIAlertController(title: "Error", message: "Oops, something went wrong. Please try again later.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.delegate?.showAlert(alert: alert)
        }
    }
}
