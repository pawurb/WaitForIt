//
//  ExecutionsTest.swift
//  WaitForIt
//
//  Created by Paweł Urbanek on 24/09/2017.
//  Copyright © 2017 PabloWeb. All rights reserved.
//

import Foundation

import XCTest
@testable import WaitForIt

struct ExecuteOnceTest: ScenarioProtocol {
    static var maxExecutionsPermitted: Int? = 1
}

struct ExecuteThreeTimesTest: ScenarioProtocol {
    static var maxExecutionsPermitted: Int? = 3
}

class ExecutionsTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        ExecuteOnceTest.reset()
        ExecuteThreeTimesTest.reset()
    }
    
    func testBasicDate() {
//        let scenario = BasicDurationTest.self
//        scenario.triggerEvent()
//        sleep(2)
//        scenario.execute { shouldExecute in
//            XCTAssertTrue(shouldExecute)
//        }
    }
}
