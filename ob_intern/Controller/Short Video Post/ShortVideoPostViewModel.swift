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
}

class ShortVideoPostViewModel {
    
    // MARK: - Properties
    weak var delegate: ShortVideoPostViewModelDelegate?
    
    //MARK: - Usecase
    
    //MARK: - Init
    init(delegate: ShortVideoPostViewModelDelegate) {
        self.delegate = delegate
    }
    
    // MARK: - Functions
    
}
