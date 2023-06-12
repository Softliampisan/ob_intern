//
//  EditVideoTimelineViewModel.swift
//  ob_intern
//
//  Created by Soft Liampisan on 9/6/2566 BE.
//  Copyright (c) 2566 BE ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

protocol EditVideoTimelineViewModelDelegate: AnyObject {
    func showError(error: Error)
    func showLoading()
    func hideLoading()
}

class EditVideoTimelineViewModel {
    
    // MARK: - Properties
    weak var delegate: EditVideoTimelineViewModelDelegate?
    
    //MARK: - Usecase
    
    //MARK: - Init
    init(delegate: EditVideoTimelineViewModelDelegate) {
        self.delegate = delegate
    }
    
    // MARK: - Functions
    
}
