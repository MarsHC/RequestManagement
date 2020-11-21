//
//  RMResultPresenter.swift
//  RequestMgmt
//
//  Created by 黄超 on 2020/11/19.
//  Copyright © 2020 黄超. All rights reserved.
//

import UIKit
import SnapKit
import KakaJSON

class RMResultPresenter: NSObject {
    weak var controller : UIViewController?
    //存储请求记录的数组
    var requestRecordArray : [RequestRecord]?

    private lazy var resultTV : UITextView = {
           let resultTV = UITextView()
           resultTV.textColor = UIColor.black
           resultTV.backgroundColor = UIColor.green
           resultTV.isEditable = false
           controller!.view.addSubview(resultTV);
           return resultTV
    }()
    
    private lazy var requestTimeLabel : UILabel = {
           let requestTimeLabel = UILabel()
           requestTimeLabel.textColor = UIColor.black
           requestTimeLabel.backgroundColor = UIColor.red
           controller!.view.addSubview(requestTimeLabel);
           return requestTimeLabel
    }()
    
    private lazy var gotoHistoryBtn : UIButton = {
           let gotoHistoryBtn = UIButton(type: UIButton.ButtonType.system)
           gotoHistoryBtn.setTitle("Go To History List", for: UIControl.State.normal)
           gotoHistoryBtn.addTarget(self, action: #selector(gotoHistoryBtn(btn:)), for: .touchUpInside)
           controller!.view.addSubview(gotoHistoryBtn);
           return gotoHistoryBtn
    }()
}

// MARK:- 设置UI
extension RMResultPresenter {
     func setupUI() {
        requestTimeLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(NAV_BAR_HEIGHT)
            make.centerX.equalToSuperview()
        }
        
        resultTV.snp.makeConstraints { (make) in
            make.top.equalTo(requestTimeLabel.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-100)
        }
        
        gotoHistoryBtn.snp.makeConstraints { (make) in
            make.top.equalTo(resultTV.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
    }
    
    
}

//加载数据
extension RMResultPresenter {
    func loadData() {
        requestRecordArray = PlistHelper.loadModelArray(fileName: REQUEST_RECORD_FILE_NAME) ?? [RequestRecord]()
        
        if requestRecordArray!.count > 0 {
            let rr = requestRecordArray!.first! as RequestRecord
            self.requestTimeLabel.text = rr.requestTime
            self.resultTV.text = rr.requestResult
        }
    }
}

// MARK:- 5s开启定时器
extension RMResultPresenter {
     func setupTimer() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(AFTER_TIME_SECONDS)) {
            let timer = Timer.init(timeInterval: TimeInterval(TIMER_INTERVAL), repeats:true) { (kTimer) in
                print("定时器执行")
                NetworkTool.get(url: RequestUrl.githubApiUrl, params: nil) { (result) in
                    guard let dict = result as! [String : String]? else { return }

                    var rr = RequestRecord()
                    rr.requestTime = DateUtil.nowDateTimeToStr(format: DATE_TIME_FORMATTER)
                    rr.requestResult = self.dictToString(dict)
                    self.requestRecordArray!.append(rr)
                   
                    if( PlistHelper.saveModelArrayToPlist(modelArray: self.requestRecordArray!, fileName: REQUEST_RECORD_FILE_NAME) == true) {
                        self.loadData()
                    }
                    
                    //发送新成功调用产生通知
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: NEW_REQUEST_SUCCESS_NOTIFY), object: nil, userInfo: nil)

                }
            }
            RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
            timer.fire()
        }
    }
    
    // MARK: 字典转字符串
    private func dictToString(_ dic:[String : Any]) -> String?{
        let data = try? JSONSerialization.data(withJSONObject: dic, options: [])
        let str = String(data: data!, encoding: String.Encoding.utf8)
        return str?.replacingOccurrences(of: "\\/", with: "/");
     }
}

// MARK:- 事件监听
extension RMResultPresenter {
    @objc private func gotoHistoryBtn(btn: UIButton) {
        let rmHistoryVC = RMHistoryViewController()
        self.controller?.navigationController?.pushViewController(rmHistoryVC, animated: true)
    }
}
    

