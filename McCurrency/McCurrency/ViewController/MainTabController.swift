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
        configureViewControllers()
        tabBar.backgroundColor = .mainColor
        
        
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
        
        let nav1 = templateNavigationController(image: UIImage(systemName: "person.fill"), rootViewController: firstVC)
        let nav2 = templateNavigationController(image:  UIImage(systemName: "pencil"), rootViewController: secondVC)
 
        nav1.tabBarItem.title = "프로필"
        nav2.tabBarItem.title = "연필"

        viewControllers = [nav1, nav2]
        
    }
    
    
    
}
