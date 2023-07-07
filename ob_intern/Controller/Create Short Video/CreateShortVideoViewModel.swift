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
    func showSuccessPost()
    func showError(error: Error)
    func showLoading()
    func hideLoading()
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
            self.delegate?.showSuccessPost()
            
            
        } errorHandler: { [weak self] error in
            self?.delegate?.showError(error: error)
        }
    }
}
