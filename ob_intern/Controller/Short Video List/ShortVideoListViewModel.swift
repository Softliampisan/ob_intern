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
    var currentList: [ShortVideoList] = []

    //MARK: - Usecase
    
    //MARK: - Init
    init(delegate: ShortVideoListViewModelDelegate) {
        self.delegate = delegate
        currentList.append(ShortVideoList.mock())
        currentList.append(ShortVideoList.mock())
        currentList.append(ShortVideoList.mock())
        currentList.append(ShortVideoList.mock())
        

    }
   
    // MARK: - Functions
    func addMockData(){
        let numberOfVideos: Int = 20
        for _ in 0..<numberOfVideos {
            let user = ShortVideoList.mock()
            self.currentList.append(user)
        }
    }
    
    func updateData() {
        // Fetch or update the new data
        let newData: [ShortVideoList] = [
            ShortVideoList.mock(),
            ShortVideoList.mock(),
            ShortVideoList.mock()
        ]
        
        // Replace the current data with the new data
        currentList = newData
        
    }
    
}
