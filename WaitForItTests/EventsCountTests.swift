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
    static func config() {
        minEventsRequired = 2
    }
}

struct MaxEventsTest: ScenarioProtocol {
    static func config() {
        maxEventsPermitted = 2
    }
}

struct MinMaxEventsTest: ScenarioProtocol {
    static func config() {
        minEventsRequired = 2
        maxEventsPermitted = 3
    }
}

struct NoConditionsTest: ScenarioProtocol {
    static func config() {}
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
