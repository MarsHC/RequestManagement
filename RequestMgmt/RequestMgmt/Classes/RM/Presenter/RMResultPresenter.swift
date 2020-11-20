//
//  RMResultPresenter.swift
//  RequestMgmt
//
//  Created by 黄超 on 2020/11/19.
//  Copyright © 2020 黄超. All rights reserved.
//

import UIKit
import SnapKit

class RMResultPresenter: NSObject {
    var controller : UIViewController?

    private lazy var resultTV : UITextView = {
           let resultTV = UITextView()
           resultTV.textColor = UIColor.black
           resultTV.backgroundColor = UIColor.green
           resultTV.isEditable = false
           controller!.view.addSubview(resultTV);
           return resultTV
       }()
}

// MARK:- 设置UI
extension RMResultPresenter {
     func setupUI() {
        resultTV.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(NAV_BAR_HEIGHT)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-100)
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
                    self.resultTV.text = self.dictToString(dict)
                    
                    
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
     func writeToFile() {
        
     }
    
     func readFromFile() {
       
     }
}
    

