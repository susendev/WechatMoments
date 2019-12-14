//
//  WSSImageCache.swift
//  WechatMoments
//
//  Created by Matthew on 2019/12/14.
//  Copyright © 2019 Matthew. All rights reserved.
//

import Foundation

class WSSImageCache {
    static let shared = WSSImageCache()
    private let memoryCache = NSCache<NSString, NSData>()
    private let fileManager = FileManager()
    private let diskCachePath: String

    private init() {
        let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        diskCachePath =  path!.appending("/com.wssimage.cache")
    }
    // 通过 key 在缓存中查找
    func searchBy(key: String) -> Data? {
        if let data = memoryCache.object(forKey: key as NSString) {
            return data as Data
        }
        let cachePath = URL(fileURLWithPath: diskCachePath.appending("/\(key)"))

        if let data = try? Data.init(contentsOf: cachePath) {
            memoryCache.setObject(data as NSData, forKey: key as NSString)
            return data
        }
        return nil
    }
    // 添加数据到缓存中
    func setData(_ data: Data , for key: String){
        memoryCache.setObject(data as NSData, forKey: key as NSString)
        if !fileManager.fileExists(atPath: diskCachePath) {
            try? fileManager.createDirectory(atPath: diskCachePath, withIntermediateDirectories: true, attributes: nil)
        }
        let cachePath = URL(fileURLWithPath: diskCachePath.appending("/\(key)"))
        try? data.write(to: cachePath)
    }
    
    func cleanAllCache() {
        cleanMemoryCache()
        cleandiskCache()
    }
    
    func cleanMemoryCache() {
        memoryCache.removeAllObjects()
    }
    
    func cleandiskCache() {
        try? fileManager.removeItem(at: URL(fileURLWithPath: diskCachePath))
    }
    
}
