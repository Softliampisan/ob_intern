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
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if let index = tabBar.items?.firstIndex(of: item), index == 2 {
            ShortVideoManager.myProfile = true
        } else {
            ShortVideoManager.myProfile = false
        }
    }
    
    func setupTabBar(){
        
        self.tabBar.tintColor = .red
        self.tabBar.backgroundColor = .white
        self.tabBar.isHidden = false
        

        let controller = ShortVideoPostViewController.newInstance()
        self.navigationController?.pushViewController(controller, animated: false)
        controller.tabBarItem.image = UIImage(systemName: "house.fill")
        
        let controller2 = CreateShortVideoViewController.newInstance()
        self.navigationController?.pushViewController(controller2, animated: false)
        controller2.tabBarItem.image = UIImage(systemName: "magnifyingglass.circle.fill")

        let controller3 = ShortVideoListViewController.newInstance(post: ShortVideoPost.myProfile())
        self.navigationController?.pushViewController(controller3, animated: false)
        controller3.tabBarItem.image = UIImage(systemName: "person.fill")

        viewControllers = [UINavigationController(rootViewController: controller),
                           UINavigationController(rootViewController: controller2),
                           UINavigationController(rootViewController: controller3)]
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
