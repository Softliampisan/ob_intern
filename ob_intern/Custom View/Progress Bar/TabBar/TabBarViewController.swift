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
        if let index = tabBar.items?.firstIndex(of: item), index == 1 {
            ShortVideoManager.myProfile = true
        } else {
            ShortVideoManager.myProfile = false
        }
    }
    
    func setupTabBar(){
        
        self.tabBar.tintColor = .red
        self.tabBar.backgroundColor = .white
        self.tabBar.isHidden = false
        

        let shortVdoPostVC = ShortVideoPostViewController.newInstance()
        self.navigationController?.pushViewController(shortVdoPostVC, animated: false)
        shortVdoPostVC.tabBarItem.image = UIImage(systemName: "house.fill")

        let shortVdoListVC = ShortVideoListViewController.newInstance(post: ShortVideoPost.myProfile())
        self.navigationController?.pushViewController(shortVdoListVC, animated: false)
        shortVdoListVC.tabBarItem.image = UIImage(systemName: "person.fill")

        viewControllers = [shortVdoPostVC, shortVdoListVC]
        
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
