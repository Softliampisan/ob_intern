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
        self.navigationController?.setNavigationBarHidden(true, animated: false)
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
        let vc = TabBarViewController()
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.present(vc, animated: true)
    }
    
    
    @IBAction func buttonToPost(_ sender: Any) {
        let controller = ShortVideoPostViewController.newInstance()
        self.navigationController?.pushViewController(controller, animated: false)
       
    }
    
    
    @IBAction func buttonToVideoPlayer(_ sender: Any) {
        let controller = ShortVideoPlayerViewController.newInstance()
        self.navigationController?.pushViewController(controller, animated: false)
        
    }
    
    
}

