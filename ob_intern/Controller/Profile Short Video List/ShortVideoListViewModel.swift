//
//  ShortVideoListViewModel.swift
//  ob_intern
//
//  Created by Soft Liampisan on 7/6/2566 BE.
//  Copyright (c) 2566 BE ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import UIKit

protocol ShortVideoListViewModelDelegate: AnyObject {
    func showError(error: Error)
    func showLoading()
    func hideLoading()
    func updateData()
    func showAlert(alert: UIAlertController)
}

class ShortVideoListViewModel {
    
    // MARK: - Properties
    weak var delegate: ShortVideoListViewModelDelegate?
    var currentList: [ShortVideoList] = []
    var post: ShortVideoPost?

    //MARK: - Usecase
    
    //MARK: - Init
    init(delegate: ShortVideoListViewModelDelegate, post: ShortVideoPost) {
        self.delegate = delegate
        self.post = post

    }
   
    // MARK: - Functions
    func getVideoList() {
        delegate?.showLoading()
        ShortVDOService().getShortVDOList { [weak self] videoList in
            guard let self = self else { return}
            currentList = videoList
            guard let delegate = delegate else { return }
            delegate.updateData()
            delegate.hideLoading()
        } errorHandler: { [weak self] error in
            self?.delegate?.hideLoading()
            let alert = UIAlertController(title: "Error", message: "Oops, something went wrong. Please try again later.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self?.delegate?.showAlert(alert: alert)
        }
    }
    
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
