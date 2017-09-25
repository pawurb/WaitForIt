//
//  MixedTests.swift
//  WaitForIt
//
//  Created by Paweł Urbanek on 24/09/2017.
//  Copyright © 2017 PabloWeb. All rights reserved.
//

import Foundation
import XCTest
@testable import WaitForIt

struct MixedTestA: ScenarioProtocol {
    static var maxExecutionsPermitted: Int? = 1
    static var minEventsRequired: Int? = 2
    
    static var minSecondsBetweenExecutions: TimeInterval? = nil
    static var maxEventsPermitted: Int? = nil
    static var minSecondsSinceFirstEvent: TimeInterval? = nil
    static var minSecondsSinceLastEvent: TimeInterval? = nil
    static var customConditions: (() -> Bool)? = nil
}

struct MixedTestB: ScenarioProtocol {
    static var minSecondsBetweenExecutions: TimeInterval? = 1
    static var maxExecutionsPermitted: Int? = nil
    static var minEventsRequired: Int? = nil
    static var maxEventsPermitted: Int? = 0
    static var minSecondsSinceFirstEvent: TimeInterval? = nil
    static var minSecondsSinceLastEvent: TimeInterval? = nil
    static var customConditions: (() -> Bool)? = nil
}

class MixedTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        MixedTestA.reset()
        MixedTestB.reset()
    }
    
    func testMixedA() {
        let scenario = MixedTestA.self
        scenario.tryToExecute { didExecute in
            XCTAssertFalse(didExecute)
        }
        
        scenario.triggerEvent()
        scenario.triggerEvent()
        
        scenario.tryToExecute { didExecute in
            XCTAssertTrue(didExecute)
        }
        
        scenario.tryToExecute { didExecute in
            XCTAssertFalse(didExecute)
        }
    }
    
    func testMixedB() {
        let scenario = MixedTestB.self
        
        scenario.tryToExecute { didExecute in
            XCTAssertTrue(didExecute)
        }
        
        scenario.tryToExecute { didExecute in
            XCTAssertFalse(didExecute)
        }
        
        sleep(1)
        
        scenario.triggerEvent()
        
        scenario.tryToExecute { didExecute in
            XCTAssertFalse(didExecute)
        }
    }
}
