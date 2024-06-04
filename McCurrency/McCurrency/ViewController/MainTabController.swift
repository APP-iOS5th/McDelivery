//
//  MainTabController.swift
//  McCurrency
//
//  Created by 임재현 on 6/3/24.
//

import UIKit


class MainTabController: UITabBarController, UITabBarControllerDelegate {
    let movingView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewControllers()
        tabBar.backgroundColor = .mainColor
        
        // 사각형 뷰 설정_배경이랑 색상이 같아서 주석처리 후 구분되게 blue로 표시해 놓음.
//        movingView.backgroundColor = UIColor(red: 245/255, green: 197/255, blue: 77/255, alpha: 1)
        movingView.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 255/255, alpha: 1)
        movingView.frame = CGRect(x: self.tabBar.center.x / 4 , y: 0, width: 100, height: 5)
        movingView.layer.cornerRadius = 5
        tabBar.addSubview(movingView)
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
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let index = self.tabBar.items?.firstIndex(of: item) else { return }
        
        let subviews = tabBar.subviews.filter({ !$0.isHidden })
        guard subviews.count > index + 1 else { return }
        
        let x = subviews[index + 1].center.x - movingView.frame.width / 2
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.movingView.frame.origin.x = x
        }
    }
    
}
