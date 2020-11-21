//
//  RMResultPresenterTests.swift
//  RequestMgmtTests
//
//  Created by 黄超 on 2020/11/21.
//  Copyright © 2020 黄超. All rights reserved.
//

import XCTest
@testable import RequestMgmt

class RMResultPresenterTests: XCTestCase {
    let rmResultPresenter = RMResultPresenter()
    
    override func setUp() {
        super.setUp()
        
    }
    
    override class func tearDown()  {
        super.tearDown()
    }


    func testDictToString() throws {
        let dict = ["url":"http://www.baidu.com",
                    "address":"四川省成都市"]
        let str = rmResultPresenter.dictToString(dict)
        XCTAssertTrue(str!.contains("baidu"))
        XCTAssertTrue(str!.contains("address"))
    }
}

