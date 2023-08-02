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
//        self.navigationController?.setNavigationBarHidden(true, animated: false)
//        let vc = TabBarViewController()
//        vc.modalPresentationStyle = .fullScreen
//        self.navigationController?.present(vc, animated: false)
//        
//        AppDirector.sharedInstance().rootViewController = vc.navigationController
        
    }
    
    @IBAction func buttonToCreateShortVideo(_ sender: Any) {
        let controller = StampLogoVideoViewController.newInstance()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func buttonToEditShortVideoCover(_ sender: Any) {
        let controller = EditShortVideoCoverViewController.newInstance()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func buttonToTestProgressBar(_ sender: Any) {
        let vc = TabBarViewController()
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.present(vc, animated: true)
    }
    
    
    @IBAction func buttonToPost(_ sender: Any) {
        let controller = ShortVideoPostViewController.newInstance()
        self.navigationController?.pushViewController(controller, animated: true)
       
    }
    
    
}

