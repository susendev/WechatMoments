
//
//  WSSImageDownloader.swift
//  WechatMoments
//
//  Created by Matthew on 2019/12/14.
//  Copyright © 2019 Matthew. All rights reserved.
//

import Foundation

class WSSImageDownloader {
    enum WSSWebImageError: Error {
        case badUrl
    }
    static let shared = WSSImageDownloader()
    private let imageCache = WSSImageCache.shared
    private var identifiers = [String: Int]()
    private let queue = DispatchQueue(label: "com.wssimage.queue", attributes: .concurrent)
//    private let downloadIng = []
    
    func cancel(identifier: String) {
        identifiers[identifier] = 1
    }
    private func add(identifier: String) {
        identifiers[identifier] = 0
    }
    private func remove(identifier: String) {
        identifiers[identifier] = 0
    }

    func downlodeImageBy(url: String, identifier: String, complete: @escaping (Bool, Data?, Error?)->()) {
        guard let url = URL(string: url) else {
            complete(false, nil, WSSWebImageError.badUrl)
            return
        }
        add(identifier: identifier)
        downlodeImageBy(url: url, identifier: identifier,complete: complete)
    }
    
    private func downlodeImageBy(url: URL, identifier: String, complete: @escaping (Bool, Data?, Error?)->()) {
        let cacheKey = url.absoluteString.MD5()
        queue.async {
            if let data = self.imageCache.searchBy(key: cacheKey){
                DispatchQueue.main.async {
                    if self.identifiers[identifier] == 0 {
                        self.remove(identifier: identifier)
                        complete(true, data as Data, nil)
                    }
                }
                return
            }

        }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data =  data {
                self.queue.async {
                    self.imageCache.setData(data, for: cacheKey)
                }
                DispatchQueue.main.async {
                    if self.identifiers[identifier] == 0 {
                        self.remove(identifier: identifier)
                        complete(true, data, nil)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    complete(false, nil, error)
                }
            }
        }.resume()

    }
}

