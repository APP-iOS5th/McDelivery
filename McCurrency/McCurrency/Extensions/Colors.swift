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
    static let backgroundColor = UIColor(hex: "363336") // 배경 컬러
    static let secondaryTextColor = UIColor(hex: "999999") // 보조 텍스트 컬러
}
