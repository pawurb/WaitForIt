//
//  EventsCountTests.swift
//  WaitForItTests
//
//  Created by Paweł Urbanek on 23/09/2017.
//  Copyright © 2017 PabloWeb. All rights reserved.
//

import Foundation
import XCTest
@testable import WaitForIt

struct MinEventsTest: ScenarioProtocol {
    static var minEventsRequired: Int? = 2
    
    static var maxExecutionsPermitted: Int? = nil
    static var maxEventsPermitted: Int? = nil
    static var minSecondsSinceFirstEvent: TimeInterval? = nil
    static var minSecondsSinceLastEvent: TimeInterval? = nil
    static var minSecondsBetweenExecutions: TimeInterval? = nil
    static var customConditions: (() -> Bool)? = nil
}

struct MaxEventsTest: ScenarioProtocol {
    static var maxEventsPermitted: Int? = 2
    
    static var maxExecutionsPermitted: Int? = nil
    static var minEventsRequired: Int? = nil
    static var minSecondsSinceFirstEvent: TimeInterval? = nil
    static var minSecondsSinceLastEvent: TimeInterval? = nil
    static var minSecondsBetweenExecutions: TimeInterval? = nil
    static var customConditions: (() -> Bool)? = nil
}

struct MinMaxEventsTest: ScenarioProtocol {
    static var minEventsRequired: Int? = 2
    static var maxEventsPermitted: Int? = 3
    
    static var maxExecutionsPermitted: Int? = nil
    static var minSecondsSinceFirstEvent: TimeInterval? = nil
    static var minSecondsSinceLastEvent: TimeInterval? = nil
    static var minSecondsBetweenExecutions: TimeInterval? = nil
    static var customConditions: (() -> Bool)? = nil
}

struct NoConditionsTest: ScenarioProtocol {
    static var minEventsRequired: Int? = nil
    static var maxEventsPermitted: Int? = nil
    static var maxExecutionsPermitted: Int? = nil
    static var minSecondsSinceFirstEvent: TimeInterval? = nil
    static var minSecondsSinceLastEvent: TimeInterval? = nil
    static var minSecondsBetweenExecutions: TimeInterval? = nil
    static var customConditions: (() -> Bool)? = nil
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
        
        scenario.tryToExecute { didExecute in
            XCTAssertFalse(didExecute)
        }
        
        scenario.triggerEvent()
        
        scenario.tryToExecute { didExecute in
            XCTAssertFalse(didExecute)
        }
        
        scenario.triggerEvent()
        
        scenario.tryToExecute { didExecute in
            XCTAssertTrue(didExecute)
        }
    }
    
    func testMaxPermitted() {
        let scenario = MaxEventsTest.self
        
        scenario.tryToExecute { didExecute in
            XCTAssertTrue(didExecute)
        }
        
        scenario.triggerEvent()
        
        scenario.tryToExecute { didExecute in
            XCTAssertTrue(didExecute)
        }
        
        scenario.triggerEvent()
        
        scenario.tryToExecute { didExecute in
            XCTAssertTrue(didExecute)
        }
        
        scenario.triggerEvent()
        
        scenario.tryToExecute { didExecute in
            XCTAssertFalse(didExecute)
        }
    }

    func textMinMaxRequired() {
        let scenario = MinMaxEventsTest.self
        
        scenario.tryToExecute { didExecute in
            XCTAssertFalse(didExecute)
        }
        
        scenario.triggerEvent()
        
        scenario.tryToExecute { didExecute in
            XCTAssertFalse(didExecute)
        }
        
        scenario.triggerEvent()
        
        scenario.tryToExecute { didExecute in
            XCTAssertTrue(didExecute)
        }
        
        scenario.triggerEvent()
        
        scenario.tryToExecute { didExecute in
            XCTAssertFalse(didExecute)
        }
    }

    func textNoConditions() {
        let scenario = NoConditionsTest.self
        
        scenario.tryToExecute { didExecute in
            XCTAssertTrue(didExecute)
        }
        
        scenario.triggerEvent()
        
        scenario.tryToExecute { didExecute in
            XCTAssertTrue(didExecute)
        }
    }
}
