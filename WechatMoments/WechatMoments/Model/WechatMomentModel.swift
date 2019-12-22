
//
//  WechatMomentModel.swift
//  WechatMoments
//
//  Created by Matthew on 2019/12/11.
//  Copyright © 2019 Matthew. All rights reserved.
//

import Foundation

struct WechatMomentModel : Codable {
    
    let comments : [Comment]?
    let content : String?
    let error : String?
    let images : [Image]?
    let sender : Sender?
    let unknownerror : String?

    struct Comment : Codable {
        
        let content : String?
        let sender : Sender?
        
    }
    
    struct Sender : Codable {
        
        let avatar : String?
        let nick : String?
        let username : String?
        
    }

    struct Image : Codable {
        
        let url : String?
        
    }
    
}
