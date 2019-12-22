//
//  WechatMomentImageView.swift
//  WechatMoments
//
//  Created by Matthew on 2019/12/22.
//  Copyright © 2019 Matthew. All rights reserved.
//

import Foundation
import UIKit

class WechatMomentImageView: UIView {
    
    private var imageViews = [UIImageView]()
    var images: [WechatMomentModel.Image]? {
        willSet {
            for view in imageViews {
                view.isHidden = true
                view.snp.removeConstraints()
            }
            guard let newValue = newValue else { return }
            guard newValue.count != 0 else { return }
            var lastView: UIView = self
            for i in 0..<newValue.count {
                if i > 8 {
                    break
                }
                let value = newValue[i]
                let imageView = imageViews[i]
                imageView.setWebImage(value.url ?? "")
                imageView.backgroundColor = UIColor.hexColor("#eaeaea")
                imageView.isHidden = false
                imageView.snp.remakeConstraints { (make) in
                    if i % 3 == 0 {
                        if i == 0 {
                            make.top.equalToSuperview()
                        } else {
                            make.top.equalTo(lastView.snp.bottom).offset(10)
                        }
                        make.left.equalToSuperview()
                    } else if i % 3 == 2 {
                        make.right.equalToSuperview()
                        make.top.equalTo(lastView)
                    } else {
                        make.centerX.equalToSuperview()
                        make.top.equalTo(lastView)
                    }
                    make.width.equalToSuperview().multipliedBy(0.3)
                    make.height.equalTo(imageView.snp.width)
                }
                lastView = imageView
            }
            lastView.snp.makeConstraints { (make) in
                make.bottom.equalToSuperview()
            }
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        for _ in 0..<9 {
            let imageView = UIImageView()
            addSubview(imageView)
            imageViews.append(imageView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
