//
//  ShortVideoPlayerViewModel.swift
//  ob_intern
//
//  Created by Soft Liampisan on 20/6/2566 BE.
//  Copyright (c) 2566 BE ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

protocol ShortVideoPlayerViewModelDelegate: AnyObject {
    func showError(error: Error)
    func showLoading()
    func hideLoading()
}

class ShortVideoPlayerViewModel {
    
    // MARK: - Properties
    weak var delegate: ShortVideoPlayerViewModelDelegate?
    
    //MARK: - Usecase
    
    //MARK: - Init
    init(delegate: ShortVideoPlayerViewModelDelegate) {
        self.delegate = delegate
    }
    
    // MARK: - Functions
    
}
