//
//  CustomConditionsTest.swift
//  WaitForIt
//
//  Created by Paweł Urbanek on 25/09/2017.
//  Copyright © 2017 PabloWeb. All rights reserved.
//

import Foundation


import Foundation
import XCTest
@testable import WaitForIt

struct CustomConditionA: ScenarioProtocol {
    static var customConditions: (() -> Bool)? = {
        return true
    }
    
    static var maxExecutionsPermitted: Int? = nil
    static var minEventsRequired: Int? = nil
    static var minSecondsBetweenExecutions: TimeInterval? = nil
    static var maxEventsPermitted: Int? = nil
    static var minSecondsSinceFirstEvent: TimeInterval? = nil
    static var minSecondsSinceLastEvent: TimeInterval? = nil
}

struct CustomConditionB: ScenarioProtocol {
    static var customConditions: (() -> Bool)? = {
        return false
    }
    
    static var maxExecutionsPermitted: Int? = nil
    static var minEventsRequired: Int? = nil
    static var minSecondsBetweenExecutions: TimeInterval? = nil
    static var maxEventsPermitted: Int? = nil
    static var minSecondsSinceFirstEvent: TimeInterval? = nil
    static var minSecondsSinceLastEvent: TimeInterval? = nil
}

class CustomConditionsTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        CustomConditionA.reset()
        CustomConditionB.reset()
    }
    
    func testCustomConditionTrue() {
        let scenario = CustomConditionA.self
        scenario.tryToExecute { didExecute in
            XCTAssertTrue(didExecute)
        }
        
    }
    
    func testCustomConditionFalse() {
        let scenario = CustomConditionB.self
        scenario.tryToExecute { didExecute in
            XCTAssertFalse(didExecute)
        }
    }
}
