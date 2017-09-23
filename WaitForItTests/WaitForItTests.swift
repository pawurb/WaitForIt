//
//  WaitForItTests.swift
//  WaitForItTests
//
//  Created by Paweł Urbanek on 23/09/2017.
//  Copyright © 2017 PabloWeb. All rights reserved.
//

import XCTest
@testable import WaitForIt

class WaitForItTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testExample() {
        let scenarioHandler = WaitForIt()
        XCTAssertEqual(scenarioHandler.hello, "there")
    }
    
    func testPerformanceExample() {
    }
}
