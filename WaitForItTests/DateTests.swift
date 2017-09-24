//
//  DateTests.swift
//  WaitForIt
//
//  Created by Paweł Urbanek on 24/09/2017.
//  Copyright © 2017 PabloWeb. All rights reserved.
//

import Foundation

import XCTest
@testable import WaitForIt

struct BasicDateTest: ScenarioProtocol {
    static var minSecondsSinceFirstEvent: TimeInterval? = 1
    
    static var minEventsRequired: Int? = nil
    static var maxEventsPermitted: Int? = nil
    static var maxExecutionsPermitted: Int? = nil
}

struct MockedDateTest: ScenarioProtocol {
    static var minSecondsSinceFirstEvent: TimeInterval? = 1500
    
    static var minEventsRequired: Int? = nil
    static var maxEventsPermitted: Int? = nil
    static var maxExecutionsPermitted: Int? = nil
}

class DateTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        BasicDateTest.reset()
        MockedDateTest.reset()
    }
    
    func testBasicDate() {
        let scenario = BasicDateTest.self
        scenario.triggerEvent()
        sleep(2)
        scenario.execute { shouldExecute in
            XCTAssertTrue(shouldExecute)
        }
    }
    
    func testMockedDate() {
        let fakeNow = Date().addingTimeInterval(-2000)
        let scenario = MockedDateTest.self
        scenario.triggerEvent(timeNow: fakeNow)
        
        scenario.execute { shouldExecute in
            XCTAssertTrue(shouldExecute)
        }
        
        scenario.execute(timeNow: fakeNow, completion: { shouldExecute in
            XCTAssertFalse(shouldExecute)
        })
    }
}
