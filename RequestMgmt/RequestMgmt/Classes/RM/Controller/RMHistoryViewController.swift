//
//  RMHistoryViewController.swift
//  RequestMgmt
//
//  Created by 黄超 on 2020/11/19.
//  Copyright © 2020 黄超. All rights reserved.
//

import UIKit

class RMHistoryViewController: UIViewController {
    private lazy var rmHistoryPresenter = RMHistoryPresenter()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white;
        navigationItem.title = "Request History List"
        
        rmHistoryPresenter.controller = self
        rmHistoryPresenter.setupUI()
        rmHistoryPresenter.loadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    
        rmHistoryPresenter.controller = nil
    }

    deinit {
        print("RMHistoryViewController deinit")
    }
}
