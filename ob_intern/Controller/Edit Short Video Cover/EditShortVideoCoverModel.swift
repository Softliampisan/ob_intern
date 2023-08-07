//
//  EditVideoTimelineViewModel.swift
//  ob_intern
//
//  Created by Soft Liampisan on 9/6/2566 BE.
//  Copyright (c) 2566 BE ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

protocol EditShortVideoCoverViewModelDelegate: AnyObject {
    func showError(error: Error)
    func showLoading()
    func hideLoading()
}

class EditShortVideoCoverViewModel {
    
    // MARK: - Properties
    weak var delegate: EditShortVideoCoverViewModelDelegate?
    var currentList: [ShortVideoList] = []
    var asset: AVAsset?
    var videoFrames: [UIImage]

    //MARK: - Usecase
    
    //MARK: - Init
    init(delegate: EditShortVideoCoverViewModelDelegate, asset: AVAsset? = nil, videoFrames: [UIImage] = []) {
        self.delegate = delegate
        self.asset = asset
        self.videoFrames = videoFrames
    }
    
    // MARK: - Functions
    func generateFramesFromAsset(numberOfFrames: Int) {
        guard let asset = asset as? AVURLAsset else { return }
        let assetDuration = asset.duration
        let totalTime = CMTimeGetSeconds(assetDuration)
        let interval = totalTime / Double(numberOfFrames)

        let assetImageGenerator = AVAssetImageGenerator(asset: asset)
        assetImageGenerator.appliesPreferredTrackTransform = true
        //UI requirements for width and height
        assetImageGenerator.maximumSize = CGSize(width: 300, height: 400)

        var currentTime = CMTime.zero

        for _ in 0..<numberOfFrames {
            do {
                let cgImage = try assetImageGenerator.copyCGImage(at: currentTime, actualTime: nil)
                let uiImage = UIImage(cgImage: cgImage)
                videoFrames.append(uiImage) // Append the generated frame to 'videoFrames'.
            } catch let error as NSError {
                print("Error generating image: \(error)")
            }

            currentTime = CMTimeMakeWithSeconds(CMTimeGetSeconds(currentTime) + interval, preferredTimescale: assetDuration.timescale)
        }
        
    }
}
