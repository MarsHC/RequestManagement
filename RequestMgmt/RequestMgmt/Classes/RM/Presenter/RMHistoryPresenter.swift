//
//  RMHistoryPresenter.swift
//  RequestMgmt
//
//  Created by 黄超 on 2020/11/20.
//  Copyright © 2020 黄超. All rights reserved.
//

import UIKit

class RMHistoryPresenter: NSObject,UITableViewDataSource,UITableViewDelegate {
    var controller : UIViewController?

    private lazy var tableView : UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.backgroundColor = UIColor.blue;
        controller?.view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
}

// MARK:- 设置UI
extension RMHistoryPresenter {
     func setupUI() {
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

// MARK:- UITableViewDataSource,UITableViewDelegate
extension RMHistoryPresenter {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

