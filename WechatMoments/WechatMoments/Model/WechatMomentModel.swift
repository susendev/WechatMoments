
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
    
    enum CodingKeys: String, CodingKey {
        case comments = "comments"
        case content = "content"
        case error = "error"
        case images = "images"
        case sender = "sender"
        case unknownerror = "unknownerror"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        comments = try values.decodeIfPresent([Comment].self, forKey: .comments)
        content = try values.decodeIfPresent(String.self, forKey: .content)
        error = try values.decodeIfPresent(String.self, forKey: .error)
        images = try values.decodeIfPresent([Image].self, forKey: .images)
        sender = try values.decodeIfPresent(Sender.self, forKey: .sender)
        unknownerror = try values.decodeIfPresent(String.self, forKey: .unknownerror)
    }

    struct Comment : Codable {
        
        let content : String?
        let sender : Sender?
        
        enum CodingKeys: String, CodingKey {
            case content = "content"
            case sender
        }
        
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            content = try values.decodeIfPresent(String.self, forKey: .content)
            sender = try values.decodeIfPresent(Sender.self, forKey: .sender)
        }
        
    }
    
    struct Sender : Codable {
        
        let avatar : String?
        let nick : String?
        let username : String?
        
        enum CodingKeys: String, CodingKey {
            case avatar = "avatar"
            case nick = "nick"
            case username = "username"
        }
        
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            avatar = try values.decodeIfPresent(String.self, forKey: .avatar)
            nick = try values.decodeIfPresent(String.self, forKey: .nick)
            username = try values.decodeIfPresent(String.self, forKey: .username)
        }
        
    }

    struct Image : Codable {
        
        let url : String?
        
        enum CodingKeys: String, CodingKey {
            case url = "url"
        }
        
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            url = try values.decodeIfPresent(String.self, forKey: .url)
        }
        
    }
    
}
