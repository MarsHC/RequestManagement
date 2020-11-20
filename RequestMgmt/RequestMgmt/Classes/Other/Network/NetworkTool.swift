//
//  NetworkTool.swift
//  RequestMgmt
//
//  Created by 黄超 on 2020/11/19.
//  Copyright © 2020 黄超. All rights reserved.
//

import Foundation
import Alamofire

class NetworkTool {
    class func get(url: String, params: Dictionary<String, Any>?,finishedCallback: @escaping (_ result : Any?) -> ()) {
        AF.request(url, method: .get, parameters: params).responseJSON { response in
            guard let result = response.value else {
                print(response.error!)
                return
            }
            finishedCallback(result)
        }
    }
}
