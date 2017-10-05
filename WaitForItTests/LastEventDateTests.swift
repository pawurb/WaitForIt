//
//  LastEventDateTests.swift
//  WaitForIt
//
//  Created by Paweł Urbanek on 25/09/2017.
//  Copyright © 2017 PabloWeb. All rights reserved.
//

import Foundation
import XCTest
@testable import WaitForIt

struct BasicLastDateTest: ScenarioProtocol {
    static func config() {
        minSecondsSinceLastEvent = 1
    }
}

struct MockedLastDateTest: ScenarioProtocol {
    static func config() {
        minSecondsSinceLastEvent = 500
    }
}

class LastEventDateTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        BasicLastDateTest.reset()
        MockedLastDateTest.reset()
    }
    
    func testBasicLastDate() {
        let scenario = BasicLastDateTest.self
        scenario.triggerEvent()
        sleep(1)
        scenario.tryToExecute { didExecute in
            XCTAssertTrue(didExecute)
        }
    }
    
    func testMockedLastDate() {
        let fakeNow = Date().addingTimeInterval(-2000)
        let scenario = MockedLastDateTest.self
        scenario.triggerEvent(timeNow: fakeNow)
        
        scenario.tryToExecute { didExecute in
            XCTAssertTrue(didExecute)
        }
        
        scenario.tryToExecute(timeNow: fakeNow, completion: { didExecute in
            XCTAssertFalse(didExecute)
        })
    }
}
