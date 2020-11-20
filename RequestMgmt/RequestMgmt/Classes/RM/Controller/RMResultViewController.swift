//
//  RMResultViewController.swift
//  RequestMgmt
//
//  Created by 黄超 on 2020/11/19.
//  Copyright © 2020 黄超. All rights reserved.
//

import UIKit
import KakaJSON

class RMResultViewController: UIViewController {
    private lazy var rmResultPresenter = RMResultPresenter()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white;
        navigationItem.title = "Request Result"
        
        rmResultPresenter.controller = self
        rmResultPresenter.setupUI()
        rmResultPresenter.setup()
        rmResultPresenter.setupTimer()
    }
    
}
