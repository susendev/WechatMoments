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
    var refreshHeaderState = BehaviorRelay.init(value: MJRefreshState.idle)
    var refreshFooterState = BehaviorRelay.init(value: MJRefreshState.idle)
    private var moments = [WechatMomentModel]()
    var momentsDriver: Driver<[WechatMomentModel]> {
        return self.page.asObservable().flatMapLatest(self.getDatas).asDriver(onErrorJustReturn: moments)
    }

    func getDatas(_ page: Int) -> Observable<[WechatMomentModel]>  {
        if page != 0 {
            guard let allMoments = self.cache.object(forKey: self.cacheKey) as? [WechatMomentModel] else {
                self.refreshFooterState.accept(MJRefreshState.idle)
                return Observable<[WechatMomentModel]>.just(self.moments)
            }
            if allMoments.count < page * self.pageSize {
                self.refreshFooterState.accept(MJRefreshState.noMoreData)
                return Observable<[WechatMomentModel]>.just(self.moments)
            }
//            self.refreshFooterState.accept(MJRefreshState.refreshing)
            let moment = allMoments.suffix(from: page * self.pageSize)
                .prefix(self.pageSize)
                .filter { (model) -> Bool in
                return !((model.content?.isEmpty ?? true) && (model.images?.isEmpty ?? true))
            }
            self.refreshFooterState.accept(MJRefreshState.idle)

            return Observable<[WechatMomentModel]>
                .just(moment)
                .scan(self.moments) { (old, new) -> [WechatMomentModel] in
                    self.moments = old + new
                return old + new
            }
        }
        guard let url = URL.init(string: "https://thoughtworks-mobile-2018.herokuapp.com/user/jsmith/tweets") else {
            self.refreshHeaderState.accept(MJRefreshState.idle)
            self.refreshFooterState.accept(MJRefreshState.idle)
            return Observable<[WechatMomentModel]>.just(self.moments)
        }
//        self.refreshHeaderState.accept(MJRefreshState.refreshing)
        let request = URLRequest.init(url: url, cachePolicy: .returnCacheDataElseLoad)
        return URLSession.shared.rx.data(request: request)
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .map({ (data) -> [WechatMomentModel] in
                self.refreshHeaderState.accept(MJRefreshState.idle)
                self.refreshFooterState.accept(MJRefreshState.idle)
                if let models = try? JSONDecoder().decode([WechatMomentModel].self, from: data)  {
                    return models.filter({ (model) -> Bool in
                        return model.error == nil && model.unknownerror == nil
                    })
                }
                return []
            }).scan(self.moments) { (old, new) -> [WechatMomentModel] in
                self.cache.setObject(new as AnyObject, forKey: self.cacheKey)
                self.moments = new.prefix(self.pageSize).filter({ (model) -> Bool in
                    return !((model.content?.isEmpty ?? true) && (model.images?.isEmpty ?? true))
                })
                return self.moments
        }
    }
}


