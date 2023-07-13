//
//  StampLogoVideoViewModel.swift
//  ob_intern
//
//  Created by Soft Liampisan on 11/7/2566 BE.
//  Copyright (c) 2566 BE ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

protocol StampLogoVideoViewModelDelegate: AnyObject {
    func showError(error: Error)
    func showLoading()
    func hideLoading()
}

class StampLogoVideoViewModel {
    
    // MARK: - Properties
    weak var delegate: StampLogoVideoViewModelDelegate?
    
    //MARK: - Usecase
    
    //MARK: - Init
    init(delegate: StampLogoVideoViewModelDelegate) {
        self.delegate = delegate
    }
    
    // MARK: - Functions
    
}
