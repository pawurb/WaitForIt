//
//  FirstEventDateTests.swift
//  WaitForIt
//
//  Created by Paweł Urbanek on 24/09/2017.
//  Copyright © 2017 PabloWeb. All rights reserved.
//

import Foundation
import XCTest
@testable import WaitForIt

struct BasicFirstDateTest: ScenarioProtocol {
    static var minSecondsSinceFirstEvent: TimeInterval? = 1
    
    static var minSecondsSinceLastEvent: TimeInterval? = nil
    static var minEventsRequired: Int? = nil
    static var maxEventsPermitted: Int? = nil
    static var maxExecutionsPermitted: Int? = nil
    static var minSecondsBetweenExecutions: TimeInterval? = nil
    static var customConditions: (() -> Bool)? = nil
}

struct MockedFirstDateTest: ScenarioProtocol {
    static var minSecondsSinceFirstEvent: TimeInterval? = 1500
    
    static var minSecondsSinceLastEvent: TimeInterval? = nil
    static var minEventsRequired: Int? = nil
    static var maxEventsPermitted: Int? = nil
    static var maxExecutionsPermitted: Int? = nil
    static var minSecondsBetweenExecutions: TimeInterval? = nil
    static var customConditions: (() -> Bool)? = nil
}

class FirstEventDateTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        BasicFirstDateTest.reset()
        MockedFirstDateTest.reset()
    }
    
    func testBasicFirstDate() {
        let scenario = BasicFirstDateTest.self
        scenario.triggerEvent()
        sleep(1)
        scenario.tryToExecute { didExecute in
            XCTAssertTrue(didExecute)
        }
    }
    
    func testMockedFirstDate() {
        let fakeNow = Date().addingTimeInterval(-2000)
        let scenario = MockedFirstDateTest.self
        scenario.triggerEvent(timeNow: fakeNow)
        
        scenario.tryToExecute { didExecute in
            XCTAssertTrue(didExecute)
        }
        
        scenario.tryToExecute(timeNow: fakeNow, completion: { didExecute in
            XCTAssertFalse(didExecute)
        })
    }
}
