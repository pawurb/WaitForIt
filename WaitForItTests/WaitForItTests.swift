//
//  WaitForItTests.swift
//  WaitForItTests
//
//  Created by Paweł Urbanek on 23/09/2017.
//  Copyright © 2017 PabloWeb. All rights reserved.
//

import XCTest
@testable import WaitForIt

enum MyScenario {
    case minEventsTest
    case maxEventsTest
    case minMaxEventsTest
    case nilEventsTest
}

extension MyScenario: ScenarioProtocol {
    var minEventsCount: Int? {
        switch self {
        case .minEventsTest:
            return nil
        case .maxEventsTest:
            return nil
        case .minMaxEventsTest:
            return 2
        case .nilEventsTest:
            return nil
        }
    }
    
    var maxEventsCount: Int? {
        switch self {
        case .minEventsTest:
            return nil
        case .maxEventsTest:
            return 2
        case .minMaxEventsTest:
            return 2
        case .nilEventsTest:
            return nil
        }
    }
}

class WaitForItTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testMinRequired() {
        let scenarioHandler = WaitForIt(scenario: MyScenario.minEventsTest)
        scenarioHandler.triggerEvent()
        
        scenarioHandler.fulfill { conditionsMet in
            XCTAssertTrue(conditionsMet)
        }
    }
    
    func testMaxRequired() {
        
    }
    
    func textMinMaxRequired() {
        
    }
    
    func textNilRequired() {
        
    }
}
