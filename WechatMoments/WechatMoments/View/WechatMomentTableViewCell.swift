//
//  WechatMomentTableViewCell.swift
//  WechatMoments
//
//  Created by Matthew on 2019/12/12.
//  Copyright © 2019 Matthew. All rights reserved.
//

import UIKit

class WechatMomentTableViewCell: UITableViewCell {

    var model: WechatMomentModel? {
        willSet {
            senderAvatarImageView.setWebImage(newValue?.sender?.avatar ?? "", cornerRadius: 5)
            senderNameLabel.text = newValue?.sender?.nick
            senderContentLabel.text = newValue?.content
            imageViews.images = newValue?.images
            commentView.comments = newValue?.comments
        }
    }
    
    private let senderAvatarImageView = UIImageView()
    private let senderNameLabel = UILabel()
    private let senderContentLabel = UILabel()
    private let imageViews = WechatMomentImageView()
    private let commentView = WechatMomentCommentView()
    private let lineView = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        
        contentView.addSubview(senderAvatarImageView)
        contentView.addSubview(senderNameLabel)
        contentView.addSubview(senderContentLabel)
        contentView.addSubview(imageViews)
        contentView.addSubview(commentView)
        contentView.addSubview(lineView)
        
        senderAvatarImageView.roundedRect(cornerRadius: 10)
        senderNameLabel.font = UIFont.systemFont(ofSize: 16)
        senderNameLabel.textColor = UIColor.hexColor("#576d92")

        senderContentLabel.numberOfLines = 0
        senderContentLabel.font = UIFont.systemFont(ofSize: 16)

        lineView.backgroundColor = UIColor.hexColor("#eaeaea")

        senderAvatarImageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(12)
            make.top.equalToSuperview().offset(15)
            make.width.height.equalTo(42)
        }
        senderNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(senderAvatarImageView.snp.right).offset(15)
            make.top.equalTo(senderAvatarImageView)
            make.height.equalTo(senderAvatarImageView).dividedBy(2)
            make.right.equalToSuperview().offset(-20)
        }
        senderContentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(senderNameLabel)
            make.top.equalTo(senderNameLabel.snp.bottom)
            make.right.equalToSuperview().offset(-20)
        }
        imageViews.snp.makeConstraints { (make) in
            make.left.equalTo(senderNameLabel)
            make.top.equalTo(senderContentLabel.snp.bottom).offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        commentView.snp.makeConstraints { (make) in
            make.left.equalTo(senderNameLabel)
            make.top.equalTo(imageViews.snp.bottom).offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        lineView.snp.remakeConstraints { (make) in
            make.top.equalTo(commentView.snp.bottom).offset(10)
            make.height.equalTo(1)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

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
