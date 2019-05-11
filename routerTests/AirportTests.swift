//
//  AirportTests.swift
//  routerTests
//
//  Created by Johnson Ejezie on 11/05/2019.
//  Copyright © 2019 Guestlogix. All rights reserved.
//

import XCTest
@testable import router

class AirportTests: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
    }

    func testParsingAirportCSVToAirportClass() {
        let expectation = self.expectation(description: "Parsing Airport CSV")
        var airports: [Airport] = []
        Airport.parseCSV { (ports) in
            airports = ports
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(!airports.isEmpty, "airports is not empty")
        let airport = airports.first
        XCTAssert(airport != nil)
        XCTAssert(airport?.name != nil)
        XCTAssert(airport?.city != nil)
        XCTAssert(airport?.longitude != nil)
        XCTAssert(airport?.latitude != nil)
        XCTAssert(airport?.country != nil)
    }

}
