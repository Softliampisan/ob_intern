//
//  SettingsViewModel.swift
//  ob_intern
//
//  Created by Soft Liampisan on 27/7/2566 BE.
//  Copyright (c) 2566 BE ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

protocol SettingsViewModelDelegate: AnyObject {
    func showError(error: Error)
    func showLoading()
    func hideLoading()
}

class SettingsViewModel {
    
    // MARK: - Properties
    weak var delegate: SettingsViewModelDelegate?
    
    //MARK: - Usecase
    
    //MARK: - Init
    init(delegate: SettingsViewModelDelegate) {
        self.delegate = delegate
    }
    
    // MARK: - Functions
    
}
