//
//  PlistHelperTests.swift
//  RequestMgmtTests
//
//  Created by 黄超 on 2020/11/21.
//  Copyright © 2020 黄超. All rights reserved.
//

import XCTest
@testable import RequestMgmt

class PlistHelperTests: XCTestCase {
    var modelArray = [RequestRecord]()
    let testFileName = "Test.plist"

    override func setUp() {
        super.setUp()
    }
    
    override class func tearDown()  {
        super.tearDown()
    }

    func testSaveModelArrayToPlist() throws {
        var rr1 = RequestRecord()
        rr1.requestTime = "rr1_RequestTime"
        rr1.requestResult = "rr1_requestResult"
        
        var rr2 = RequestRecord()
        rr2.requestTime = "rr2_RequestTime"
        rr2.requestResult = "rr2_requestResult"
        
        modelArray.append(rr1)
        modelArray.append(rr2)
        
        PlistHelper.saveModelArrayToPlist(modelArray: modelArray, fileName: testFileName)
        let fileManager = FileManager.init()

        XCTAssert(fileManager.fileExists(atPath: filePath()), "创建\(testFileName)失败")
    }

    func testLoadModelArray() throws {
        let resultDictArray = NSArray(contentsOfFile: filePath())
        XCTAssertTrue(resultDictArray!.count == 2)
    }

    private func filePath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentsDirectory = paths.object(at: 0) as! NSString
        let path = documentsDirectory.appendingPathComponent(testFileName)
        return path
    }
}
