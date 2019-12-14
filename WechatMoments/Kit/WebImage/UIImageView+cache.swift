
//
//  UIImageView+cache.swift
//  WechatMoments
//
//  Created by Matthew on 2019/12/14.
//  Copyright © 2019 Matthew. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    func setWebImage(_ urlString: String, cornerRadius: CGFloat? = nil, default: UIImage? = nil) {
        if let identifier = identifier {
            WSSImageDownloader.shared.cancel(identifier: identifier)
        }
        identifier = UUID().description
        WSSImageDownloader.shared.downlodeImageBy(url: urlString, identifier: identifier!) { (result, data, error) in
            if result {
                if let data = data {
                    self.image = UIImage(data: data)
                }
                if let cornerRadius = cornerRadius {
                    self.roundedRect(cornerRadius: cornerRadius)
                }
            }
        }
    }
   
}

extension UIImageView {
    func roundedRect(cornerRadius: CGFloat) {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)
        let bezierPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        bezierPath.addClip()
        draw(bounds)
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext()
    }
}


extension UIImageView {
    private struct AssociatedKeys {
        static var identifier = "identifier"
    }
    private var identifier: String? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.identifier) as? String
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.identifier, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

}
