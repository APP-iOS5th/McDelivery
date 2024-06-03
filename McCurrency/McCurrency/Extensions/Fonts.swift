//
//  Fonts.swift
//  McCurrency
//
//  Created by 임재현 on 6/3/24.
//

import UIKit

struct AppFontName {

    static let interBlack = "Inter-Black"
    static let interBold = "Inter-Bold"
    static let interSemiBold = "Inter-SemiBold"
    static let interExtraBold = "Inter-ExtraBold"
    static let interExtraLight = "Inter-ExtraLight"
    static let interLight = "Inter-Light"
    static let interMedium = "Inter-Medium"
    static let interRegular = "Inter-Regular"
    static let interThin = "Inter-Thin"
}

extension UIFont {
    class func interBlackFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.interBlack, size: size)!
    }

    class func interBoldFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.interBold, size: size)!
    }

    class func interSemiBoldFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.interSemiBold, size: size)!
    }

    class func interExtraBoldFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.interExtraBold, size: size)!
    }

    class func interExtraLightFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.interExtraLight, size: size)!
    }

    class func interLightFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.interLight, size: size)!
    }

    class func interMediumFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.interMedium, size: size)!
    }

    class func interRegularFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.interRegular, size: size)!
    }

    class func interThinFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.interThin, size: size)!
    }
}
