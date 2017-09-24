//
//  EventsCountTests.swift
//  WaitForItTests
//
//  Created by Paweł Urbanek on 23/09/2017.
//  Copyright © 2017 PabloWeb. All rights reserved.
//

import XCTest
@testable import WaitForIt

struct MinEventsTest: ScenarioProtocol {
    static var minEventsRequired: Int? = 2
    
    static var maxExecutionsPermitted: Int? = nil
    static var maxEventsPermitted: Int? = nil
    static var minSecondsSinceFirstEvent: TimeInterval? = nil
    static var minSecondsBetweenExecutions: TimeInterval? = nil
}

struct MaxEventsTest: ScenarioProtocol {
    static var maxEventsPermitted: Int? = 2
    
    static var maxExecutionsPermitted: Int? = nil
    static var minEventsRequired: Int? = nil
    static var minSecondsSinceFirstEvent: TimeInterval? = nil
    static var minSecondsBetweenExecutions: TimeInterval? = nil
}

struct MinMaxEventsTest: ScenarioProtocol {
    static var minEventsRequired: Int? = 2
    static var maxEventsPermitted: Int? = 3
    
    static var maxExecutionsPermitted: Int? = nil
    static var minSecondsSinceFirstEvent: TimeInterval? = nil
    static var minSecondsBetweenExecutions: TimeInterval? = nil
}

struct NoConditionsTest: ScenarioProtocol {
    static var minEventsRequired: Int? = nil
    static var maxEventsPermitted: Int? = nil
    static var maxExecutionsPermitted: Int? = nil
    static var minSecondsSinceFirstEvent: TimeInterval? = nil
    static var minSecondsBetweenExecutions: TimeInterval? = nil
}

class EventsCountTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        MinEventsTest.reset()
        MaxEventsTest.reset()
        MinMaxEventsTest.reset()
    }
    
    func testMinRequired() {
        let scenario = MinEventsTest.self
        
        scenario.execute { shouldExecute in
            XCTAssertFalse(shouldExecute)
        }
        
        scenario.triggerEvent()
        
        scenario.execute { shouldExecute in
            XCTAssertFalse(shouldExecute)
        }
        
        scenario.triggerEvent()
        
        scenario.execute { shouldExecute in
            XCTAssertTrue(shouldExecute)
        }
    }
    
    func testMaxPermitted() {
        let scenario = MaxEventsTest.self
        
        scenario.execute { shouldExecute in
            XCTAssertTrue(shouldExecute)
        }
        
        scenario.triggerEvent()
        
        scenario.execute { shouldExecute in
            XCTAssertTrue(shouldExecute)
        }
        
        scenario.triggerEvent()
        
        scenario.execute { shouldExecute in
            XCTAssertTrue(shouldExecute)
        }
        
        scenario.triggerEvent()
        
        scenario.execute { shouldExecute in
            XCTAssertFalse(shouldExecute)
        }
    }

    func textMinMaxRequired() {
        let scenario = MinMaxEventsTest.self
        
        scenario.execute { shouldExecute in
            XCTAssertFalse(shouldExecute)
        }
        
        scenario.triggerEvent()
        
        scenario.execute { shouldExecute in
            XCTAssertFalse(shouldExecute)
        }
        
        scenario.triggerEvent()
        
        scenario.execute { shouldExecute in
            XCTAssertTrue(shouldExecute)
        }
        
        scenario.triggerEvent()
        
        scenario.execute { shouldExecute in
            XCTAssertFalse(shouldExecute)
        }
    }

    func textNoConditions() {
        let scenario = NoConditionsTest.self
        
        scenario.execute { shouldExecute in
            XCTAssertTrue(shouldExecute)
        }
        
        scenario.triggerEvent()
        
        scenario.execute { shouldExecute in
            XCTAssertTrue(shouldExecute)
        }
    }
}
