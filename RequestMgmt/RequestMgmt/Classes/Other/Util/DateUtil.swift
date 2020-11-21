//
//  DateUtil.swift
//  RequestMgmt
//
//  Created by 黄超 on 2020/11/21.
//  Copyright © 2020 黄超. All rights reserved.
//

import UIKit

class DateUtil: NSObject {
    static func nowDateTimeToStr(format : String) -> String {
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: now)
    }
}
