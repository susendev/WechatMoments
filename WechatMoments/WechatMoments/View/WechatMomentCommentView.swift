//
//  WechatMomentCommentView.swift
//  WechatMoments
//
//  Created by Matthew on 2019/12/22.
//  Copyright © 2019 Matthew. All rights reserved.
//

import Foundation
import UIKit

class WechatMomentCommentView: UIView {
    
    private var labels = [UILabel]()
    var comments: [WechatMomentModel.Comment]? {
        willSet {
            for view in labels {
                view.isHidden = true
                view.snp.removeConstraints()
            }
            guard let newValue = newValue else { return }
            guard newValue.count != 0 else { return }
            var lastView: UIView = self
            if newValue.count > labels.count {
                for _ in 0..<(newValue.count - labels.count) {
                    let label = UILabel()
                    label.numberOfLines = 0
                    addSubview(label)
                    labels.append(label)
                }
            }
            for i in 0..<newValue.count {
                let value = newValue[i]
                let label = labels[i]
                label.isHidden = false
                let senderNick = value.sender?.nick ?? ""
                let content = value.content ?? ""
                let attr = NSMutableAttributedString.init(string: "\(senderNick)：\(content)", attributes: [.font : UIFont.systemFont(ofSize: 14),.foregroundColor : UIColor.hexColor("#000000")])
                attr.addAttribute(.foregroundColor, value: UIColor.hexColor("#576d92"), range: NSRange(location: 0, length: senderNick.count))
                label.attributedText = attr
                label.snp.remakeConstraints { (make) in
                    if i == 0 {
                        make.top.equalToSuperview().offset(2)
                    } else {
                        make.top.equalTo(lastView.snp.bottom).offset(2)
                    }
                    make.left.equalToSuperview().offset(10)
                    make.right.equalToSuperview().offset(-10)
                }
                lastView = label
            }
            lastView.snp.makeConstraints { (make) in
                make.bottom.equalToSuperview().offset(-2)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.hexColor("#F7F7F7")
        
        for _ in 0..<5 {
            let label = UILabel()
            label.numberOfLines = 0
            addSubview(label)
            labels.append(label)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

