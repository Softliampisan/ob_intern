//
//  ViewController.swift
//  ob_intern
//
//  Created by Soft Liampisan on 7/6/2566 BE.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    @IBAction func buttonToShortVideoList(_ sender: Any) {
        let controller = ShortVideoListViewController.newInstance()
        self.navigationController?.pushViewController(controller, animated: false)
    }
    
    
    @IBAction func buttonToCreateShortVideo(_ sender: Any) {
        let controller = CreateShortVideoViewController.newInstance()
        self.navigationController?.pushViewController(controller, animated: false)
    }
    
    @IBAction func buttonToEditShortVideoCover(_ sender: Any) {
        let controller = EditShortVideoCoverViewController.newInstance()
        self.navigationController?.pushViewController(controller, animated: false)
    }
    
    @IBAction func buttonToTestProgressBar(_ sender: Any) {
//        let controller = TestProgressBarViewController.newInstance()
//        self.navigationController?.pushViewController(controller, animated: false)
        let vc = TabBarViewController()
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.present(vc, animated: true)
    }
    
    
}

