//
//  CreateShortVideoViewModel.swift
//  ob_intern
//
//  Created by Soft Liampisan on 8/6/2566 BE.
//  Copyright (c) 2566 BE ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

protocol CreateShortVideoViewModelDelegate {
    func showError(error: Error)
    func showLoading()
    func hideLoading()
}

class CreateShortVideoViewModel {
    
    // MARK: - Properties
    var delegate: CreateShortVideoViewModelDelegate?
    
    //MARK: - Usecase
    
    //MARK: - Init
    init(delegate: CreateShortVideoViewModelDelegate) {
        self.delegate = delegate
    }
    
    // MARK: - Functions
    
}
