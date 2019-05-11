//
//  RouteTests.swift
//  routerTests
//
//  Created by Johnson Ejezie on 11/05/2019.
//  Copyright © 2019 Guestlogix. All rights reserved.
//

import XCTest
@testable import router

class RouteTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testParsingRoutesCSVToRoutesClass() {
        let expectation = self.expectation(description: "Parsing Routes CSV")
        var routes: [Route] = []
        Route.parseCSV({ (result) in
            routes = result
            expectation.fulfill()
        })
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(!routes.isEmpty, "routes is not empty")
        let route = routes.first
        XCTAssert(route != nil)
        XCTAssert(route?.airlineID != nil)
        XCTAssert(route?.origin != nil)
        XCTAssert(route?.destination != nil)
    }
}
