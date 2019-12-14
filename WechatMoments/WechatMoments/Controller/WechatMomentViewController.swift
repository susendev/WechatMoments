//
//  WechatMomentViewController.swift
//  WechatMoments
//
//  Created by Matthew on 2019/12/11.
//  Copyright © 2019 Matthew. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import MJRefresh

private let cellIdentifier = "WechatMomentTableViewCell"

class WechatMomentViewController: UIViewController {

    private let tableView = UITableView.init(frame: .zero, style: .plain)
    private let disposeBag = DisposeBag()
    private let viewModel = WechatMomentViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        bindData()

    }
    
    private func setUI() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(WechatMomentTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        let refreshFooter = MJRefreshAutoNormalFooter.init(refreshingBlock: {
            let nextPage = self.viewModel.page.value + 1
            self.viewModel.page.accept(nextPage)
        })
        refreshFooter.setTitle("正在加载...", for: .refreshing)
        tableView.mj_footer = refreshFooter

    }
    
    private func bindData() {
        viewModel.momentsDriver.drive(tableView.rx.items){ (tableView, row, model)  -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: IndexPath.init(row: row, section: 0)) as! WechatMomentTableViewCell
            cell.model = model
            return cell
        }.disposed(by: disposeBag)
        
        viewModel.refreshState.asDriver().drive(onNext: { [weak self](state) in
            self?.tableView.mj_footer?.state = state
        }).disposed(by: disposeBag)

    }
 
}
