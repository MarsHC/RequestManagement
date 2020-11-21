//
//  RMHistoryPresenter.swift
//  RequestMgmt
//
//  Created by 黄超 on 2020/11/20.
//  Copyright © 2020 黄超. All rights reserved.
//

import UIKit
import MBProgressHUD

class RMHistoryPresenter: NSObject,UITableViewDataSource,UITableViewDelegate {
    var controller : UIViewController?
    var requestRecordArray : [RequestRecord]?

    private lazy var tableView : UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.backgroundColor = UIColor.white;
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

//加载数据源
extension RMHistoryPresenter {
    @objc func loadData() {
        requestRecordArray = PlistHelper.loadModelArray(fileName: REQUEST_RECORD_FILE_NAME) ?? [RequestRecord]()
        tableView.reloadData()
        tableView.mj_header?.endRefreshing()
    }
}

//下拉刷新
extension RMHistoryPresenter {
     func setupHeader() {
        tableView.mj_header = MJRefreshNormalHeader()
        tableView.mj_header?.setRefreshingTarget(self, refreshingAction: #selector(self.loadData))
    }
}

extension RMHistoryPresenter {
    func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(newRequestSuccessHandle), name: NSNotification.Name(rawValue: NEW_REQUEST_SUCCESS_NOTIFY), object: nil)
    }
    
    @objc private func newRequestSuccessHandle(_ notify: NSNotification) {
        let hud = MBProgressHUD.showAdded(to: (controller?.view)!, animated: true)
        hud.detailsLabel.text = "产生了一个新的调用，下拉可以加载新数据"
        hud.mode = MBProgressHUDMode.text;
        hud.hide(animated: true, afterDelay: 2)
    }
    
    func removeNotification() {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK:- UITableViewDataSource,UITableViewDelegate
extension RMHistoryPresenter {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.requestRecordArray!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "requestRecordCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        }
    
        let rr = requestRecordArray![indexPath.row]
        cell?.textLabel?.text = indexPath.row == 0 ? "Latest Request:\(rr.requestTime!)" : rr.requestTime
        cell?.backgroundColor = indexPath.row == 0 ? UIColor.orange : UIColor.white
        return cell!
    }
}

