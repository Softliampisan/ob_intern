//
//  CreateShortVideoViewModel.swift
//  ob_intern
//
//  Created by Soft Liampisan on 8/6/2566 BE.
//  Copyright (c) 2566 BE ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

protocol CreateShortVideoViewModelDelegate: AnyObject {
    func showSuccessPost()
    func showError(error: Error)
    func showLoading()
    func hideLoading()
    func isPostSuccess()
}

class CreateShortVideoViewModel {
    
    // MARK: - Properties
    weak var delegate: CreateShortVideoViewModelDelegate?
    var asset: AVAsset?

    //MARK: - Usecase
    
    //MARK: - Init
    init(delegate: CreateShortVideoViewModelDelegate, asset: AVAsset? = nil) {
        self.delegate = delegate
        self.asset = asset
    }
    
    // MARK: - Functions
    func createFrontCover() -> UIImage? {
        guard let asset = asset else { return nil }
        let assetImageGenerator = AVAssetImageGenerator(asset: asset)
        assetImageGenerator.appliesPreferredTrackTransform = true
        let time = CMTime(seconds: 0.1, preferredTimescale: 1)
        let imageResolution = CGSize(width: 150, height: 200)
        assetImageGenerator.maximumSize = imageResolution
        
        do {
            let cgImage = try assetImageGenerator.copyCGImage(at: time, actualTime: nil)
            let uiImage = UIImage(cgImage: cgImage)
            return uiImage
        } catch let error as NSError {
            print("Error generating image: \(error)")
            return nil
        }
    }
    
    func createShortVDO(coverImageURL: String,
                        caption: String,
                        isAllowComments: Bool,
                        isPublic: Bool,
                        isAllowGifts: Bool) {
        delegate?.showLoading()
        ShortVDOService().createShortVDO(coverImageURL: coverImageURL,
                                         caption: caption,
                                         isAllowComments: isAllowComments,
                                         isPublic: isPublic,
                                         isAllowGifts: isAllowGifts) {
            self.delegate?.hideLoading()
            self.delegate?.showSuccessPost()
            
            
        } errorHandler: { [weak self] error in
            self?.delegate?.showError(error: error)
        }
    }
}
