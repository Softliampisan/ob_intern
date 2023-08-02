//
//  AppDirector.swift
//  ob_intern
//
//  Created by Soft Liampisan on 31/7/2566 BE.
//

import Foundation
import UIKit
import AVFoundation

class AppDirector: NSObject {
    
    static var shared: AppDirector?
    static func sharedInstance() -> AppDirector {
        if let sharedInstance = AppDirector.shared {
            return sharedInstance
        } else {
            AppDirector.shared = AppDirector()
            return AppDirector.shared!
        }
    }
    
    var rootViewController: UINavigationController?
    
    func presentMenuViewController() {
        if let rootViewController = rootViewController {
            let menuVC = CreateMenuViewController()
            menuVC.modalPresentationStyle = .overCurrentContext
            menuVC.modalTransitionStyle = .crossDissolve
            rootViewController.present(menuVC, animated: true, completion: nil)
        }
    }
    
    func displayStampLogoVideoViewController() {
        let stampLogoVC = StampLogoVideoViewController()
        AppDirector.sharedInstance().rootViewController?.pushViewController(stampLogoVC, animated: true)
    }
    
    func displayCreateShortViewController(asset: AVURLAsset) {
        let createShortVC = CreateShortVideoViewController.newInstance(asset: asset)
        AppDirector.sharedInstance().rootViewController?.pushViewController(createShortVC, animated: true)
    }
    
  
}
