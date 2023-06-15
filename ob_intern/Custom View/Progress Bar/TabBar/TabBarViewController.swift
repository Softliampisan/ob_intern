//
//  TabBarViewController.swift
//  ob_intern
//
//  Created by Soft Liampisan on 14/6/2566 BE.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        // Do any additional setup after loading the view.
    }
    func setupTabBar(){
        
        self.tabBar.tintColor = .red
        self.tabBar.backgroundColor = .white
        self.tabBar.isHidden = false
        

        let controller = TestProgressBarViewController.newInstance()
        self.navigationController?.pushViewController(controller, animated: false)
        controller.tabBarItem.image = UIImage(systemName: "house.fill")
        
        let controller2 = EditShortVideoCoverViewController.newInstance()
        self.navigationController?.pushViewController(controller, animated: false)
        controller2.tabBarItem.image = UIImage(systemName: "magnifyingglass.circle.fill")

        
        viewControllers = [UINavigationController(rootViewController: controller), UINavigationController(rootViewController: controller2)]
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
