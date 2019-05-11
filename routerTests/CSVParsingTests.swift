//
//  CSVParsingTests.swift
//  routerTests
//
//  Created by Johnson Ejezie on 11/05/2019.
//  Copyright © 2019 Guestlogix. All rights reserved.
//

import XCTest
@testable import router

class CSVParsingTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testParsingRoutesCSVToRoutesClass() {
        let expectation = self.expectation(description: "Parsing Routes CSV")
        Route.parseCSV {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(!Route.routes.isEmpty, "routes is not empty")
        let route = Route.routes.first
        XCTAssert(route != nil)
        XCTAssert(route?.airlineID != nil)
        XCTAssert(route?.origin != nil)
        XCTAssert(route?.destination != nil)
    }

    func testParsingAirlinesCSVToAirlineClass() {
        let expectation = self.expectation(description: "Parsing Airline CSV")
        Airline.parseCSV {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(!Airline.airlines.isEmpty, "airlines is not empty")
        let airline = Airline.airlines.first
        XCTAssert(airline != nil)
        XCTAssert(airline?.name != nil)
        XCTAssert(airline?.twoDigitCode != nil)
        XCTAssert(airline?.threeDigitCode != nil)
        XCTAssert(airline?.country != nil)
    }


}
