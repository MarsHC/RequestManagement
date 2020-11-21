//
//  DateUtilTests.swift
//  RequestMgmtTests
//
//  Created by 黄超 on 2020/11/21.
//  Copyright © 2020 黄超. All rights reserved.
//

import XCTest
@testable import RequestMgmt

class DateUtilTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    
    override class func tearDown()  {
        super.tearDown()
    }


    func testNowDateTimeToStr() throws {
        let str = DateUtil.nowDateTimeToStr(format: "yyyy-MM-dd")
        let array = str.components(separatedBy: "-")
        
        let date = Date()
        let calendar = Calendar.current
         
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        
        XCTAssertTrue(year == Int(array[0]))
        XCTAssertTrue(month == Int(array[1]))
        XCTAssertTrue(day == Int(array[2]))

    }

}

