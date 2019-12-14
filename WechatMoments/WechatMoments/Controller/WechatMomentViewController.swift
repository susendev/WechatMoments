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
        let statusBarHeight = UIScreen.main.bounds.height >= 812.0 ? 44 : 20

        tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(44 + statusBarHeight)
            make.left.right.bottom.equalToSuperview()
        }

        tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            self.viewModel.page.accept(0)
        })

        tableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
            let nextPage = self.viewModel.page.value + 1
            self.viewModel.page.accept(nextPage)
        })

        tableView.mj_header?.beginRefreshing()
    }
    
    private func bindData() {
        viewModel.momentsDriver.drive(tableView.rx.items){ (tableView, row, model)  -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: IndexPath.init(row: row, section: 0)) as! WechatMomentTableViewCell
            cell.model = model
            return cell
        }.disposed(by: disposeBag)
        
        viewModel.refreshFooterState.asDriver().drive(onNext: { [weak self](state) in
            self?.tableView.mj_footer?.state = state
        }).disposed(by: disposeBag)
        
        viewModel.refreshHeaderState.asDriver().drive(onNext: { [weak self](state) in
            self?.tableView.mj_header?.state = state
        }).disposed(by: disposeBag)

    }
 
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        let width = size.width
        let height = size.height
        var statusBarHeight = 0
        if height > width {
            statusBarHeight = height >= 812.0 ? 44 : 20
        }
        tableView.snp.remakeConstraints { (make) in
            make.top.equalToSuperview().offset(44 + statusBarHeight)
            make.left.right.bottom.equalToSuperview()
        }

    }
}
