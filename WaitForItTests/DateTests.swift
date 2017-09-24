//
//  DateTests.swift
//  WaitForIt
//
//  Created by Paweł Urbanek on 24/09/2017.
//  Copyright © 2017 PabloWeb. All rights reserved.
//

import Foundation

import XCTest
@testable import WaitForIt

struct BasicDurationTest: ScenarioProtocol {
    static var minSecondsSinceFirstEvent: TimeInterval? = 1
}

class DateTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        BasicDurationTest.reset()
    }
    
    func testBasicDate() {
        let scenario = BasicDurationTest.self
        scenario.triggerEvent()
        scenario.fulfill { shouldFulfill in
            XCTAssertTrue(shouldFulfill)
        }
    }
}
