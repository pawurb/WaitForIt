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
    
    static var minEventsRequired: Int? = nil
    static var maxEventsPermitted: Int? = nil
    static var minSecondsSinceFirstEvent: TimeInterval? = nil
    static var minSecondsBetweenExecutions: TimeInterval? = nil
}

struct ExecuteThreeTimesTest: ScenarioProtocol {
    static var maxExecutionsPermitted: Int? = 3
    
    static var minEventsRequired: Int? = nil
    static var maxEventsPermitted: Int? = nil
    static var minSecondsSinceFirstEvent: TimeInterval? = nil
    static var minSecondsBetweenExecutions: TimeInterval? = nil
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
        scenario.execute { shouldExecute in
            XCTAssertTrue(shouldExecute)
        }
        
        scenario.execute { shouldExecute in
            XCTAssertFalse(shouldExecute)
        }
    }
    
    func testExecuteThreeTimes() {
        let scenario = ExecuteThreeTimesTest.self
        scenario.execute { shouldExecute in
            XCTAssertTrue(shouldExecute)
        }
        
        scenario.execute { shouldExecute in
            XCTAssertTrue(shouldExecute)
        }
        
        scenario.execute { shouldExecute in
            XCTAssertTrue(shouldExecute)
        }
        
        scenario.execute { shouldExecute in
            XCTAssertFalse(shouldExecute)
        }
    }
}
