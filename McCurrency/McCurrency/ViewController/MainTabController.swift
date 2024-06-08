//
//  MainTabController.swift
//  McCurrency
//
//  Created by 임재현 on 6/3/24.
//

import UIKit


class MainTabController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.backgroundColor
        configureViewControllers()
        configureTabBarAppearance()
        if let tabBarController = self.tabBarController {
            tabBarController.configureTabBarAppearance()
        }
    }
    
    
    
    func templateNavigationController(image:UIImage?,rootViewController: UIViewController) -> UINavigationController {
        
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = image
        nav.navigationBar.barTintColor = .white
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        nav.navigationBar.standardAppearance = appearance
        nav.navigationBar.scrollEdgeAppearance = nav.navigationBar.standardAppearance
        
        return nav
    }
    
    
    func configureViewControllers() {
        
        let firstVC = FirstViewController()
        let secondVC = SecondViewController()
        
        let nav1 = templateNavigationController(image: UIImage(systemName: "banknote"), rootViewController: firstVC)
        let nav2 = templateNavigationController(image:  UIImage(systemName: "capsule.fill"), rootViewController: secondVC)
        
        nav1.tabBarItem.title = "Currency"
        nav2.tabBarItem.title = "Index"
        
        viewControllers = [nav1, nav2]
        
    }
    
    
    
}
