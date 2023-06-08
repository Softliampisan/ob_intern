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
        let controller = CreateShortVideoViewController.newInstance()
        self.navigationController?.pushViewController(controller, animated: false)
    }


}

