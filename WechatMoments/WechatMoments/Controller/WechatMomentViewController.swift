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
    private var momentModels = [WechatMomentModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        bindData()

    }
    
    private func setUI() {
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(WechatMomentTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        view.addSubview(tableView)

        tableView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview()
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
        viewModel.momentsDriver.subscribe(onNext: { [weak self](models) in
            DispatchQueue.main.async {
                if self?.viewModel.page.value == 0 {
                    self?.momentModels.removeAll()
                }
                self?.momentModels.append(contentsOf: models)
                self?.tableView.reloadData()
                self?.tableView.mj_header?.endRefreshing()
                self?.tableView.mj_footer?.endRefreshing()
                if models.count == 0 {
                    self?.tableView.mj_footer?.endRefreshingWithNoMoreData()
                }
            }
        }).disposed(by: disposeBag)
    }
 
}


extension WechatMomentViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.momentModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! WechatMomentTableViewCell
        cell.model = self.momentModels[indexPath.row]
        return cell
    }
    
}
