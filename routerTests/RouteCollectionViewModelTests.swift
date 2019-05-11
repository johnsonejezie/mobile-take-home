//
//  RouteCollectionViewModelTests.swift
//  routerTests
//
//  Created by Johnson Ejezie on 11/05/2019.
//  Copyright © 2019 Guestlogix. All rights reserved.
//

import XCTest
@testable import router

class RouteCollectionViewModelTests: XCTestCase {

    var viewModel: RouteCollectionViewModel!

    override func setUp() {
        viewModel = RouteCollectionViewModel()
        viewModel.viewDidload()
    }

    override func tearDown() {}

    func testInputs() {
        let inputs = viewModel.inputs
        XCTAssertNotNil(inputs)
    }

    func testOutputs() {
        let outputs = viewModel.outputs
        XCTAssertNotNil(outputs)
    }

    func testSearchAirportReturnsDataGivenExistingCity() {
        let expectation = self.expectation(description: "Search city")
        let city = "Hofn"
        viewModel.inputs.search(text: city) {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
        XCTAssertFalse(viewModel.outputs.airports.value.isEmpty)
    }

    func testSearchAirportReturnsEmptyForCityNotInCSV() {
        let expectation = self.expectation(description: "Search city")
        let city = "qqqq"
        viewModel.inputs.search(text: city) {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
        XCTAssertTrue(viewModel.outputs.airports.value.isEmpty)
    }

    func testSearchIsAccurate() {
        let expectation = self.expectation(description: "Search city")
        let city = "Hofn"
        viewModel.inputs.search(text: city) {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
        guard let airport = viewModel.outputs.airports.value.first else {
            XCTFail()
            return
        }
        XCTAssertTrue(airport.city.lowercased().contains(city.lowercased()))
    }

    func testSettingAirport() {
        viewModel.editingTextField = .arrival
        let airport = Airport(name: "Test name", city: "Test city", iata: "YNN", latitude: "22222", longitude: "333", country: "Nigeria")
        XCTAssertNotEqual(viewModel.outputs.arrivalAirport, airport)
        viewModel.set(airport: airport)
        XCTAssertEqual(viewModel.outputs.arrivalAirport, airport)
    }
}
