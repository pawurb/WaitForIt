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
    static var minSecondsBetweenExecutions: TimeInterval? = 1
    
    static var maxExecutionsPermitted: Int? = nil
    static var minEventsRequired: Int? = nil
    static var maxEventsPermitted: Int? = nil
    static var minSecondsSinceFirstEvent: TimeInterval? = nil
}

struct MockedExecutionDateTest: ScenarioProtocol {
    static var minSecondsBetweenExecutions: TimeInterval? = 1000
    
    static var maxExecutionsPermitted: Int? = nil
    static var minEventsRequired: Int? = nil
    static var maxEventsPermitted: Int? = nil
    static var minSecondsSinceFirstEvent: TimeInterval? = nil
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
        
        scenario.execute { shouldExecute in
            XCTAssertTrue(shouldExecute)
        }
        
        scenario.execute { shouldExecute in
            XCTAssertFalse(shouldExecute)
        }
        
        sleep(1)
        
        scenario.execute { shouldExecute in
            XCTAssertTrue(shouldExecute)
        }
        
        scenario.execute { shouldExecute in
            XCTAssertFalse(shouldExecute)
        }
    }
    
    func testMockedExecutionDate() {
        let scenario = MockedExecutionDateTest.self
        let fakeNow = Date().addingTimeInterval(-2000)
        
        scenario.execute(timeNow: fakeNow, completion: { shouldExecute in
            XCTAssertTrue(shouldExecute)
        })
        
        let fakeNotMuchLater = Date().addingTimeInterval(-1500)
        scenario.execute(timeNow: fakeNotMuchLater, completion: { shouldExecute in
            XCTAssertFalse(shouldExecute)
        })
        
        let fakeMuchLater = Date().addingTimeInterval(1500)
        scenario.execute(timeNow: fakeMuchLater, completion: { shouldExecute in
            XCTAssertTrue(shouldExecute)
        })
    }
}
