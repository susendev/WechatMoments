//
//  WechatMomentViewModel.swift
//  WechatMoments
//
//  Created by Matthew on 2019/12/11.
//  Copyright © 2019 Matthew. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import MJRefresh

class WechatMomentViewModel: NSObject {

    private let cache = NSCache<NSString, AnyObject>()
    private let cacheKey: NSString = "WechatMomentModels"
    private let pageSize = 5

    var page = BehaviorRelay.init(value: 0)
    var momentsDriver: Observable<[WechatMomentModel]> {
        return self.page.skip(1).asObservable().flatMapLatest(self.getDatas)
    }

    func getDatas(_ page: Int) -> Observable<[WechatMomentModel]>  {
        if page != 0 {
            sleep(1)
            guard let allMoments = self.cache.object(forKey: self.cacheKey) as? [WechatMomentModel] else {
                return Observable<[WechatMomentModel]>.just([])
            }
            if allMoments.count < page * self.pageSize {
                return Observable<[WechatMomentModel]>.just([])
            }
            let moment = allMoments.suffix(from: page * self.pageSize)
                .prefix(self.pageSize)
                .filter { (model) -> Bool in
                return !((model.content?.isEmpty ?? true) && (model.images?.isEmpty ?? true))
            }

            return Observable<[WechatMomentModel]>
                .just(moment)
        }
        guard let url = URL.init(string: "https://thoughtworks-mobile-2018.herokuapp.com/user/jsmith/tweets") else {
            return Observable<[WechatMomentModel]>.just([])
        }
        let request = URLRequest.init(url: url, cachePolicy: .returnCacheDataElseLoad)
        return URLSession.shared.rx.data(request: request)
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .map({ (data) -> [WechatMomentModel] in
                if let models = try? JSONDecoder().decode([WechatMomentModel].self, from: data)  {
                    return models.filter({ (model) -> Bool in
                        return model.error == nil && model.unknownerror == nil
                    })
                }
                return []
            }).map({ (new) -> [WechatMomentModel] in
                self.cache.setObject(new as AnyObject, forKey: self.cacheKey)
                let filter = new.prefix(self.pageSize).filter({ (model) -> Bool in
                    return !((model.content?.isEmpty ?? true) && (model.images?.isEmpty ?? true))
                })
                return filter
            })
    }
}


