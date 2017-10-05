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
    static func config() {
        maxExecutionsPermitted = 1
    }
}

struct ExecuteThreeTimesTest: ScenarioProtocol {
    static func config() {
        maxExecutionsPermitted = 3
    }
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
    
    func testExecuteOnce() {
        let scenario = ExecuteOnceTest.self
        scenario.tryToExecute { didExecute in
            XCTAssertTrue(didExecute)
        }
        
        scenario.tryToExecute { didExecute in
            XCTAssertFalse(didExecute)
        }
    }
    
    func testExecuteThreeTimes() {
        let scenario = ExecuteThreeTimesTest.self
        scenario.tryToExecute { didExecute in
            XCTAssertTrue(didExecute)
        }
        
        scenario.tryToExecute { didExecute in
            XCTAssertTrue(didExecute)
        }
        
        scenario.tryToExecute { didExecute in
            XCTAssertTrue(didExecute)
        }
        
        scenario.tryToExecute { didExecute in
            XCTAssertFalse(didExecute)
        }
    }
}
