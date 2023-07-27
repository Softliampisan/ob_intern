//
//  CreateMenuViewModel.swift
//  ob_intern
//
//  Created by Soft Liampisan on 27/7/2566 BE.
//  Copyright (c) 2566 BE ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

protocol CreateMenuViewModelDelegate: AnyObject {
    func showError(error: Error)
    func showLoading()
    func hideLoading()
}

class CreateMenuViewModel {
    
    // MARK: - Properties
    weak var delegate: CreateMenuViewModelDelegate?
    
    //MARK: - Usecase
    
    //MARK: - Init
    init(delegate: CreateMenuViewModelDelegate) {
        self.delegate = delegate
    }
    
    // MARK: - Functions
    
}
