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
    static func config() {
        minSecondsSinceFirstEvent = 1
    }
}

struct MockedFirstDateTest: ScenarioProtocol {
    static func config() {
        minSecondsSinceFirstEvent = 1500
    }
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
