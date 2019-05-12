//
//  MapViewModelTests.swift
//  routerTests
//
//  Created by Johnson Ejezie on 12/05/2019.
//  Copyright © 2019 Guestlogix. All rights reserved.
//

import XCTest
@testable import router

class MapViewModelTests: XCTestCase {

    var viewModel: MapViewModel!
    let airports = [
        Airport(name: "Queen Alia International Airport", city: "Amman", iata: "AMM", latitude: "31.72260094", longitude: "35.99319839", country: "Jordan"),
        Airport(name: "Krasnodar Pashkovsky International Airport", city: "Krasnodar", iata: "KRR", latitude: "45.03469849", longitude: "39.17050171", country: "Russia"),
        Airport(name: "Shimojishima Airport", city: "Shimojishima", iata: "SHI", latitude: "24.82670021", longitude: "125.1449966", country: "Japan"),
        Airport(name: "Murtala Muhammed International Airport", city: "Lagos", iata: "LOS", latitude: "6.577370167", longitude: "3.321160078", country: "Nigeria"),
        Airport(name: "San Francisco International Airport", city: "San Francisco", iata: "SFO", latitude: "37.61899948", longitude: "-122.375", country: "United States"),
        Airport(name: "Abu Dhabi International Airport", city: "Abu Dhabi", iata: "AUH", latitude: "24.43300056", longitude: "54.65110016", country: "United Arab Emirates"),
        Airport(name: "Lester B. Pearson International Airport", city: "Toronto", iata: "YYZ", latitude: "43.67720032", longitude: "-79.63059998", country: "Canada"),
        Airport(name: "George Bush Intercontinental Houston Airport", city: "Houston", iata: "IAH", latitude: "29.9843998", longitude: "-95.34140015", country: "United States")
    ]

    var routes = [
        Route(airlineID: "UA", origin: "LOS", destination: "IAH"),
        Route(airlineID: "UA", origin: "IAH", destination: "SFO"),
        Route(airlineID: "AC", origin: "YYZ", destination: "AUH"),
        Route(airlineID: "AC", origin: "BKK", destination: "ICN"),
        Route(airlineID: "UA", origin: "AOO", destination: "IAD"),
        Route(airlineID: "CZ", origin: "TSN", destination: "HGH"),
        Route(airlineID: "AC", origin: "GDN", destination: "CPH"),
        Route(airlineID: "AC", origin: "FRA", destination: "VNO")

    ]

    override func setUp() {
        viewModel = MapViewModel()
        viewModel.airports.value = airports
        viewModel.routes = routes
    }

    override func tearDown() { }

    func testInputs() {
        let inputs = viewModel.inputs
        XCTAssertNotNil(inputs)
    }

    func testOutputs() {
        let outputs = viewModel.outputs
        XCTAssertNotNil(outputs)
    }

    func testAllVertexIsPopulated() {
        viewModel.inputs.createVertexForAllAirport()
        XCTAssertFalse(viewModel.allVertex.isEmpty)
    }

    func testPathIsEmptyForTwoUnconnectedAirports() {
        viewModel.inputs.createVertexForAllAirport()
        viewModel.addEdgesToAllVertex()
        let origin = viewModel.allVertex.first(where: { $0.data.iata.lowercased() == "los" })
        let destination = viewModel.allVertex.first(where: { $0.data.iata.lowercased() == "auh" })
        let path = viewModel.paths(from: origin!, to: destination!)
        XCTAssertTrue(path.isEmpty)
    }

    func testPathIsNotEmptyForTwoConnectedAirports() {
        viewModel.inputs.createVertexForAllAirport()
        viewModel.addEdgesToAllVertex()
        let origin = viewModel.allVertex.first(where: { $0.data.iata.lowercased() == "yyz" })
        let destination = viewModel.allVertex.first(where: { $0.data.iata.lowercased() == "auh" })
        let path = viewModel.paths(from: origin!, to: destination!)
        XCTAssertFalse(path.isEmpty)
    }

    func testPathsIsAccurate() {
        viewModel.inputs.createVertexForAllAirport()
        viewModel.addEdgesToAllVertex()
        let origin = viewModel.allVertex.first(where: { $0.data.iata.lowercased() == "los" })
        let destination = viewModel.allVertex.first(where: { $0.data.iata.lowercased() == "sfo" })
        let path = viewModel.paths(from: origin!, to: destination!)
        XCTAssertEqual(path.count, 2)
    }

}
