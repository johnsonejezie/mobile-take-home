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
    let airports = [
        Airport(name: "Queen Alia International Airport", city: "Amman", iata: "AMM", latitude: "31.72260094", longitude: "35.99319839", country: "Jordan"),
        Airport(name: "Krasnodar Pashkovsky International Airport", city: "Krasnodar", iata: "KRR", latitude: "45.03469849", longitude: "39.17050171", country: "Russia"),
        Airport(name: "Shimojishima Airport", city: "Shimojishima", iata: "SHI", latitude: "24.82670021", longitude: "125.1449966", country: "Japan")
    ]

    override func setUp() {
        viewModel = RouteCollectionViewModel(allAirport: airports)
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
        let iata = "SHI"
        viewModel.inputs.search(text: iata)
        XCTAssertFalse(viewModel.outputs.airports.value.isEmpty)
    }

    func testSearchAirportReturnsEmptyForCityNotInCSV() {
        let iata = "qqqq"
        viewModel.inputs.search(text: iata)
        XCTAssertTrue(viewModel.outputs.airports.value.isEmpty)
    }

    func testSearchIsAccurate() {
        let iata = "SHI"
        viewModel.inputs.search(text: iata)
        guard let airport = viewModel.outputs.airports.value.first else {
            XCTFail()
            return
        }
        XCTAssertTrue(airport.city.lowercased().contains(iata.lowercased()))
    }

    func testSettingAirport() {
        viewModel.editingTextField = .arrival
        let airport = Airport(name: "Krasnodar Pashkovsky International Airport", city: "Krasnodar", iata: "KRR", latitude: "45.03469849", longitude: "39.17050171", country: "Russia")
        XCTAssertNotEqual(viewModel.outputs.arrivalAirport, airport)
        viewModel.inputs.selectedAirport(with: airport.name)
        XCTAssertEqual(viewModel.outputs.arrivalAirport, airport)
    }
}
