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

