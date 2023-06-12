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
    
    
    @IBAction func buttonSVLAction(_ sender: Any) {
        let controller = ShortVideoListViewController.newInstance()
        self.navigationController?.pushViewController(controller, animated: false)
    }
    
    
    @IBAction func buttonCSVAction(_ sender: Any) {
        let controller = CreateShortVideoViewController.newInstance()
        self.navigationController?.pushViewController(controller, animated: false)
    }
    
    @IBAction func buttonEVTAction(_ sender: Any) {
        let controller = EditShortVideoCoverViewController.newInstance()
        self.navigationController?.pushViewController(controller, animated: false)
    }
    
    @IBAction func buttonPBAction(_ sender: Any) {
//        let controller = TestPBViewController.newInstance()
//        self.navigationController?.pushViewController(controller, animated: false)
    }
    
    
}

