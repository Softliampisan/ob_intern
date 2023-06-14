//
//  TestProgressBarViewModel.swift
//  ob_intern
//
//  Created by Soft Liampisan on 14/6/2566 BE.
//  Copyright (c) 2566 BE ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

protocol TestProgressBarViewModelDelegate: AnyObject {
    func showError(error: Error)
    func showLoading()
    func hideLoading()
}

class TestProgressBarViewModel {
    
    // MARK: - Properties
    var delegate: TestProgressBarViewModelDelegate?
    
    //MARK: - Usecase
    
    //MARK: - Init
    init(delegate: TestProgressBarViewModelDelegate) {
        self.delegate = delegate
    }
    
    // MARK: - Functions
    
}
