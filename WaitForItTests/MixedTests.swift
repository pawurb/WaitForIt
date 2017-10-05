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
    static func config() {
        maxExecutionsPermitted = 1
        minEventsRequired = 2
    }
}

struct MixedTestB: ScenarioProtocol {
    static func config() {
        minSecondsBetweenExecutions = 1
        maxEventsPermitted = 0
    }
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

