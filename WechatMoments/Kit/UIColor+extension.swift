
//
//  UIColor+extension.swift
//  WechatMoments
//
//  Created by Matthew on 2019/12/14.
//  Copyright © 2019 Matthew. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    class func hexColor(_ hexString: String) -> UIColor {
        let hex = discardPrefix(hexString)
        
        guard hex.count == 8 else {
            return UIColor.white
        }
        
        let nums = hex.map { (char) -> Int in
            switch "\(char)" {
            case "a", "A":
                return 10
            case "b", "B":
                return 11
            case "c", "C":
                return 12
            case "d", "D":
                return 13
            case "e", "E":
                return 14
            case "f", "F":
                return 15
            default:
                break
            }
            return Int("\(char)") ?? 0
        }
        
        let red = nums[0] * 16 + nums[1]
        let green = nums[2] * 16 + nums[3]
        let blue = nums[4] * 16 + nums[5]
        let alpha = nums[6] * 16 + nums[7]
        return UIColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: CGFloat(alpha)/255.0)
    }

    private class func discardPrefix(_ str: String) -> String {
        var hex = str
        if hex.hasPrefix("#") {
            hex = String(str.suffix(from: str.index(str.startIndex, offsetBy: 1)))
        }
        if hex.hasPrefix("0x") {
            hex = String(str.suffix(from: str.index(str.startIndex, offsetBy: 2)))
        }
        
        if hex.count == 3 {
            hex = hex.reduce("", { (result, char) -> String in
                return result + "\(char)\(char)"
            })
            hex += "ff"
        } else if hex.count == 4 {
            hex = hex.reduce("", { (result, char) -> String in
                return result + "\(char)\(char)"
            })
        } else if hex.count == 6 {
            hex += "ff"
        }
        return hex
    }
}
