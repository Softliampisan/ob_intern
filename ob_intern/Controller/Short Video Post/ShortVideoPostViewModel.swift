//
//  ShortVideoPostViewModel.swift
//  ob_intern
//
//  Created by Soft Liampisan on 15/6/2566 BE.
//  Copyright (c) 2566 BE ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

protocol ShortVideoPostViewModelDelegate: AnyObject {
    func showError(error: Error)
    func showLoading()
    func hideLoading()
    func updateData()
}

class ShortVideoPostViewModel {
    
    // MARK: - Properties
    weak var delegate: ShortVideoPostViewModelDelegate?
    var currentList: [ShortVideoPost] = []
    
    //MARK: - Usecase
    
    //MARK: - Init
    init(delegate: ShortVideoPostViewModelDelegate) {
        self.delegate = delegate
        

    }
    
    // MARK: - Functions
    func getVideoPost() {
        ShortVDOService().getShortVDOPost { [weak self] videoPosts in
            guard let self = self else { return}
            currentList = videoPosts
            guard let delegate = delegate else { return }
            delegate.updateData()
        } errorHandler: { error in
            
        }
    }
    
}
