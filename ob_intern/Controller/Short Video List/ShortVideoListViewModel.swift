//
//  ShortVideoListViewModel.swift
//  ob_intern
//
//  Created by Soft Liampisan on 7/6/2566 BE.
//  Copyright (c) 2566 BE ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

protocol ShortVideoListViewModelDelegate: AnyObject {
    func showError(error: Error)
    func showLoading()
    func hideLoading()
}

class ShortVideoListViewModel {
    
    // MARK: - Properties
    weak var delegate: ShortVideoListViewModelDelegate?
    
    //MARK: - Usecase
    
    //MARK: - Init
    init(delegate: ShortVideoListViewModelDelegate) {
        self.delegate = delegate
    }
    
    // MARK: - Functions
    
}
