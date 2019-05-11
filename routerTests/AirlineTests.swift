//
//  AirlineTests.swift
//  routerTests
//
//  Created by Johnson Ejezie on 11/05/2019.
//  Copyright © 2019 Guestlogix. All rights reserved.
//

import XCTest
@testable import router

class AirlineTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testParsingAirlinesCSVToAirlineClass() {
        let expectation = self.expectation(description: "Parsing Airline CSV")
        var airlines: [Airline] = []
        Airline.parseCSV({ (result) in
            airlines = result
            expectation.fulfill()
        })
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(!airlines.isEmpty, "airlines is not empty")
        let airline = airlines.first
        XCTAssert(airline != nil)
        XCTAssert(airline?.name != nil)
        XCTAssert(airline?.twoDigitCode != nil)
        XCTAssert(airline?.threeDigitCode != nil)
        XCTAssert(airline?.country != nil)
    }

}
