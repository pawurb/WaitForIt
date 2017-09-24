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
}

struct MaxEventsTest: ScenarioProtocol {
    static var maxEventsPermitted: Int? = 2
}

struct MinMaxEventsTest: ScenarioProtocol {
    static var minEventsRequired: Int? = 2
    static var maxEventsPermitted: Int? = 3
}

struct NoConditionsTest: ScenarioProtocol {}

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
        
        scenario.fulfill { shouldFulfill in
            XCTAssertFalse(shouldFulfill)
        }
        
        scenario.triggerEvent()
        
        scenario.fulfill { shouldFulfill in
            XCTAssertFalse(shouldFulfill)
        }
        
        scenario.triggerEvent()
        
        scenario.fulfill { shouldFulfill in
            XCTAssertTrue(shouldFulfill)
        }
    }
    
    func testMaxPermitted() {
        let scenario = MaxEventsTest.self
        
        scenario.fulfill { shouldFulfill in
            XCTAssertTrue(shouldFulfill)
        }
        
        scenario.triggerEvent()
        
        scenario.fulfill { shouldFulfill in
            XCTAssertTrue(shouldFulfill)
        }
        
        scenario.triggerEvent()
        
        scenario.fulfill { shouldFulfill in
            XCTAssertTrue(shouldFulfill)
        }
        
        scenario.triggerEvent()
        
        scenario.fulfill { shouldFulfill in
            XCTAssertFalse(shouldFulfill)
        }
    }

    func textMinMaxRequired() {
        let scenario = MinMaxEventsTest.self
        
        scenario.fulfill { shouldFulfill in
            XCTAssertFalse(shouldFulfill)
        }
        
        scenario.triggerEvent()
        
        scenario.fulfill { shouldFulfill in
            XCTAssertFalse(shouldFulfill)
        }
        
        scenario.triggerEvent()
        
        scenario.fulfill { shouldFulfill in
            XCTAssertTrue(shouldFulfill)
        }
        
        scenario.triggerEvent()
        
        scenario.fulfill { shouldFulfill in
            XCTAssertFalse(shouldFulfill)
        }
    }

    func textNoConditions() {
        let scenario = NoConditionsTest.self
        
        scenario.fulfill { shouldFulfill in
            XCTAssertTrue(shouldFulfill)
        }
        
        scenario.triggerEvent()
        
        scenario.fulfill { shouldFulfill in
            XCTAssertTrue(shouldFulfill)
        }
    }
}
