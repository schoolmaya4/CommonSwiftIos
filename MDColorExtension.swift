//
//  MDColorExtension.swift
//
//  Created by Shiv on 03/05/19.
//  Copyright © 2019 MVD. All rights reserved.
//

import Foundation
import UIKit

struct ThemColorSet {
    var main_color: UIColor
    var top_color: UIColor
}

enum DayName: Int {
    case  Main = 0, SubMain
}

extension UIColor {
    
    class func backgroud_color() -> UIColor {return UIColor.init(hex: "0e0f19")}
    class func up_backgroud_color() -> UIColor { return UIColor.init(hex: "151823") }
    //e22b7d, 6cb8bd, eace4a,
    //8955d3, ba3da2, 5da9c3, eda130
    // 782a6d, 781944, 5174d8, c4704b
    // 007dd9,
    
    class func fill_box_border_color() -> UIColor { return UIColor.init(hex:"6cb8bd") }
    class func unfill_box_border_color() -> UIColor { return UIColor.init(hex: "eace4a") }
    
    class func select_color() -> UIColor { return UIColor.init(hex: "3EA73E")}
    class func unselect_color() -> UIColor { return UIColor.init(hex: "AAAAAA")}
    
    class func FixTextColor()-> UIColor { return UIColor.init(hex: "FFFFFF")}
    class func FixBGColor()-> UIColor {return UIColor.init(hex: "FFFFFF")}
    class func BoxBoardColor()-> UIColor { return UIColor.init(hex: "ffffff")}
    
    class func PadButtonBGColor()-> UIColor { return UIColor.init(hex: "9248E8") }
    
    
    class func getThemColor(_ day: DayName) -> ThemColorSet {
        switch day {
        case .Main:
            return ThemColorSet(main_color: UIColor.init(hex: "1b5e20" ), top_color: UIColor.init(hex: "43a047"))
        case .SubMain:
            return ThemColorSet(main_color: UIColor.init(hex: "1b5e20"), top_color: UIColor.init(hex: "43a047"))
        default:
            return ThemColorSet(main_color: UIColor.init(hex: "000000"), top_color: UIColor.init(hex: "444444"))
        }
    }
    
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        
        var hexString = ""
        
        if hex.hasPrefix("#") {
            let nsHex = hex as NSString
            hexString = nsHex.substring(from: 1)
        } else {
            hexString = hex
        }
        
        let scanner = Scanner(string: hexString)
        var hexValue: CUnsignedLongLong = 0
        if scanner.scanHexInt64(&hexValue) {
            switch (hexString.count) {
            case 3:
                red = CGFloat((hexValue & 0xF00) >> 8)       / 15.0
                green = CGFloat((hexValue & 0x0F0) >> 4)       / 15.0
                blue = CGFloat(hexValue & 0x00F)              / 15.0
            case 6:
                red = CGFloat((hexValue & 0xFF0000) >> 16)   / 255.0
                green = CGFloat((hexValue & 0x00FF00) >> 8)    / 255.0
                blue = CGFloat(hexValue & 0x0000FF)           / 255.0
            default:
                print("Invalid HEX string, number of characters after '#' should be either 3, 6")
            }
        } else {
            //MQALogger.log("Scan hex error")
        }
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    
}


