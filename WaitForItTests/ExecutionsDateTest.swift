//
//  ExecutionsDateTest.swift
//  WaitForIt
//
//  Created by Paweł Urbanek on 24/09/2017.
//  Copyright © 2017 PabloWeb. All rights reserved.
//

import Foundation
import XCTest
@testable import WaitForIt

struct ExecuteEverySecondTest: ScenarioProtocol {
    static func config() {
        minSecondsBetweenExecutions = 1
    }
}

struct MockedExecutionDateTest: ScenarioProtocol {
    static func config() {
        minSecondsBetweenExecutions = 1000
    }
}

class ExecutionsDateTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        ExecuteEverySecondTest.reset()
        MockedExecutionDateTest.reset()
    }
    
    func testExecuteEverySecond() {
        let scenario = ExecuteEverySecondTest.self
        
        scenario.tryToExecute { didExecute in
            XCTAssertTrue(didExecute)
        }
        
        scenario.tryToExecute { didExecute in
            XCTAssertFalse(didExecute)
        }
        
        sleep(1)
        
        scenario.tryToExecute { didExecute in
            XCTAssertTrue(didExecute)
        }
        
        scenario.tryToExecute { didExecute in
            XCTAssertFalse(didExecute)
        }
    }
    
    func testMockedExecutionDate() {
        let scenario = MockedExecutionDateTest.self
        let fakeNow = Date().addingTimeInterval(-2000)
        
        scenario.tryToExecute(timeNow: fakeNow, completion: { didExecute in
            XCTAssertTrue(didExecute)
        })
        
        let fakeNotMuchLater = Date().addingTimeInterval(-1500)
        scenario.tryToExecute(timeNow: fakeNotMuchLater, completion: { didExecute in
            XCTAssertFalse(didExecute)
        })
        
        let fakeMuchLater = Date().addingTimeInterval(1500)
        scenario.tryToExecute(timeNow: fakeMuchLater, completion: { didExecute in
            XCTAssertTrue(didExecute)
        })
    }
}
