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
    
    func setup() {
        requestRecordArray = self.loadRequestData() ?? [RequestRecord]()
        
        if requestRecordArray!.count > 0 {
            let rr = requestRecordArray!.last! as RequestRecord
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
                print("定时器启动了")
                NetworkTool.get(url: RequestUrl.githubApiUrl, params: nil) { (result) in
                    guard let dict = result as! [String : String]? else { return }
                    
                    var rr = RequestRecord.init()
                    let now = Date()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let dateStr = dateFormatter.string(from: now)
                    rr.requestTime = dateStr
                    rr.requestResult = self.dictToString(dict)
                    self.requestRecordArray!.append(rr)
                    self.saveRequestData(modelArray: self.requestRecordArray!)
                    
                    self.setup()
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

// MARK:-
extension RMResultPresenter {
     //持久化调用结果到plist文件
    func saveRequestData(modelArray : [RequestRecord]) {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentsDirectory = paths.object(at: 0) as! NSString
        let path = documentsDirectory.appendingPathComponent(REQUEST_RECORD_FILE_NAME)
        
        let dictArray : NSMutableArray = NSMutableArray()

        for rr in modelArray {
            let dict = rr.kj.JSONObject()
            dictArray.add(dict)
        }
        
        //写入数据到RequestRecord.plist
        dictArray.write(toFile: path, atomically: false)
     }
    
     func loadRequestData() -> [RequestRecord]?  {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentsDirectory = paths.object(at: 0) as! NSString
        let path = documentsDirectory.appendingPathComponent(REQUEST_RECORD_FILE_NAME)
        let fileManager = FileManager.init()
        var modelArray : [RequestRecord] = []


        //check if file exists
        if(!fileManager.fileExists(atPath: path)) {
            //文件不存在
            return nil;
        } else {
            guard let resultDictArray = NSArray(contentsOfFile: path) else {return nil}
            
            for dict in resultDictArray {
                let d = dict as! NSDictionary
                let rr = d.kj.model(RequestRecord.self)!
                modelArray.append(rr)
            }
        }
       return modelArray
     }
}

// MARK:- 事件监听
extension RMResultPresenter {
    @objc private func gotoHistoryBtn(btn: UIButton) {
        let rmHistoryVC = RMHistoryViewController()
        self.controller?.navigationController?.pushViewController(rmHistoryVC, animated: true)
    }
    
    @objc private func nextStepBtnClick(btn: UIButton) {
        
    }
    
}
    

