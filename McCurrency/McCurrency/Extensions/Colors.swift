//
//  Colors.swift
//  McCurrency
//
//  Created by 임재현 on 6/3/24.
//

import UIKit

extension UIColor {
    
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    static let mainColor = UIColor(hex: "FFC327") // 메인 컬러
    static let backgroundColor = UIColor(hex: "232123") // 배경 컬러
    static let boxColor = UIColor(hex: "363336") // 박스 컬러
    static let slotBox = UIColor(hex: "1D1B1D")
    static let secondaryTextColor = UIColor(hex: "999999") // 보조 텍스트 컬러
    static let unselectedIcon = UIColor(hex: "3E3C3E") // 선택되지 않은 아이콘 컬러
}

// 탭바 투명도와 블러값 적용
extension UITabBarController {
    
    func configureTabBarAppearance() {
        let tabBar = self.tabBar
        
        tabBar.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = tabBar.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        tabBar.insertSubview(blurEffectView, at: 0)
       
        if #available(iOS 13.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithDefaultBackground()
            appearance.backgroundEffect = blurEffect
            
            appearance.stackedLayoutAppearance.selected.iconColor = UIColor.secondaryTextColor
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.secondaryTextColor]
            
            appearance.stackedLayoutAppearance.normal.iconColor = UIColor.unselectedIcon
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.unselectedIcon]
            
            tabBar.standardAppearance = appearance
            if #available(iOS 15.0, *) {
                tabBar.scrollEdgeAppearance = appearance
            }
        }
    }
}
