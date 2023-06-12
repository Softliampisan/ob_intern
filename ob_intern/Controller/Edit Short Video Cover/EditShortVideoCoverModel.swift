//
//  EditVideoTimelineViewModel.swift
//  ob_intern
//
//  Created by Soft Liampisan on 9/6/2566 BE.
//  Copyright (c) 2566 BE ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

protocol EditShortVideoCoverViewModelDelegate: AnyObject {
    func showError(error: Error)
    func showLoading()
    func hideLoading()
}

class EditShortVideoCoverViewModel {
    
    // MARK: - Properties
    weak var delegate: EditShortVideoCoverViewModelDelegate?
    var currentList: [ShortVideoList] = []

    
    //MARK: - Usecase
    
    //MARK: - Init
    init(delegate: EditShortVideoCoverViewModelDelegate) {
        self.delegate = delegate
        currentList.append(ShortVideoList.mock())
        currentList.append(ShortVideoList.mock())
        currentList.append(ShortVideoList.mock())
        currentList.append(ShortVideoList.mock())
        currentList.append(ShortVideoList.mock())
        currentList.append(ShortVideoList.mock())
        currentList.append(ShortVideoList.mock())
        currentList.append(ShortVideoList.mock())
        currentList.append(ShortVideoList.mock())
        currentList.append(ShortVideoList.mock())
    }
    
    // MARK: - Functions
    
}
