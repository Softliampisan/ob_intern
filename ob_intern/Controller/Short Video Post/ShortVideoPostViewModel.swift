//
//  ShortVideoPostViewModel.swift
//  ob_intern
//
//  Created by Soft Liampisan on 15/6/2566 BE.
//  Copyright (c) 2566 BE ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import UIKit

protocol ShortVideoPostViewModelDelegate: AnyObject {
    func showError(error: Error)
    func showLoading()
    func hideLoading()
    func updateData()
    func showAlert(alert: UIAlertController)

}

class ShortVideoPostViewModel {
    
    // MARK: - Properties
    weak var delegate: ShortVideoPostViewModelDelegate?
    var currentList: [ShortVideoPost] = []
    
    //MARK: - Usecase
    
    //MARK: - Init
    init(delegate: ShortVideoPostViewModelDelegate) {
        self.delegate = delegate
        

    }
    
    // MARK: - Functions
    func getVideoPost() {
        delegate?.showLoading()
        ShortVDOService().getShortVDOPost { [weak self] videoPosts in
            guard let self = self else { return}
            currentList = videoPosts
            guard let delegate = delegate else { return }
            delegate.updateData()
            delegate.hideLoading()
        } errorHandler: { [weak self] error in
            let alert = UIAlertController(title: "Error", message: "Oops, something went wrong. Please try again later.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self?.delegate?.showAlert(alert: alert)
        }
    }
    
}
