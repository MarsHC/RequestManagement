//
//  PlistHelper.swift
//  RequestMgmt
//
//  Created by 黄超 on 2020/11/20.
//  Copyright © 2020 黄超. All rights reserved.
//

import UIKit

class PlistHelper: NSObject {
    static func saveModelArrayToPlist(modelArray : [RequestRecord], fileName: String) -> Bool {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentsDirectory = paths.object(at: 0) as! NSString
        let path = documentsDirectory.appendingPathComponent(fileName)
        
        let dictArray = NSMutableArray()

        for rr in modelArray {
            let dict = rr.kj.JSONObject()
            dictArray.add(dict)
        }
        //写入数据到RequestRecord.plist
        return dictArray.write(toFile: path, atomically: false)
    }
    
    static func loadModelArray(fileName: String) -> [RequestRecord]? {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentsDirectory = paths.object(at: 0) as! NSString
        let path = documentsDirectory.appendingPathComponent(fileName)
        let fileManager = FileManager.init()
        var modelArray = Array<RequestRecord>()

        if(!fileManager.fileExists(atPath: path)) {
            //文件不存在
            return nil;
        }else{
            guard let resultDictArray = NSArray(contentsOfFile: path) else {return nil}
             
            for dict in resultDictArray {
                let d = dict as! NSDictionary
                let rr = d.kj.model(RequestRecord.self)!
                modelArray.append(rr)
            }
            return modelArray
        }
    }
    
}
