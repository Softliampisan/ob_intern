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
    func getVideoList() {
        ShortVDOService().getShortVDOList { [weak self] videoList in
            guard let self = self else { return}
            currentList = videoList
            guard let delegate = delegate else { return }
            delegate.updateData()
        } errorHandler: { error in
            let alert = UIAlertController(title: "Error", message: "Oops, something went wrong. Please try again later.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.delegate?.showAlert(alert: alert)
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
