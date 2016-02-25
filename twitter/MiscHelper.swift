//
//  MiscHelper.swift
//  twitter
//
//  Created by Zachary Matthews on 2/24/16.
//  Copyright © 2016 zskyfly productions. All rights reserved.
//

import Foundation
import UIKit


class MiscHelper {
    static let twitterBlue = [CGFloat(85.0), CGFloat(172.0), CGFloat(238.0)]
    static let twitterBlack = [CGFloat(41.0), CGFloat(47.0), CGFloat(51.0)]
    static let twitterDarkGrey = [CGFloat(102.0), CGFloat(117.0), CGFloat(127.0)]
    static let twitterMediumGrey = [CGFloat(204.0), CGFloat(214.0), CGFloat(221.0)]
    static let twitterLightGrey = [CGFloat(225.0), CGFloat(232.0), CGFloat(237.0)]
    static let twitterWhite = [CGFloat(255.0), CGFloat(255.0), CGFloat(255.0)]

    final class func getCGColor(rgbValue: [CGFloat]) {
        MiscHelper.getCGColor(rgbValue)
    }

    final class func getCGColor(rgbValue: [CGFloat], alphaDefault: CGFloat = 1.0) -> CGColor {
        let red = rgbValue[0] / 255.0
        let green = rgbValue[1] / 255.0
        let blue = rgbValue[2] / 255.0
        return UIColor(red: red, green: green, blue: blue, alpha: alphaDefault).CGColor
    }

    final class func getUIColor(rgbValue: [CGFloat], alphaDefault: CGFloat = 1.0) -> UIColor {
        let red = rgbValue[0] / 255.0
        let green = rgbValue[1] / 255.0
        let blue = rgbValue[2] / 255.0
        return UIColor(red: red, green: green, blue: blue, alpha: alphaDefault)
    }
}
