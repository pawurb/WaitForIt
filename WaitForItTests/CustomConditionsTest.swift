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
    static func config() {
        customConditions = { return true }
    }
}

struct CustomConditionB: ScenarioProtocol {
    static func config() {
        customConditions = { return false }
    }
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
