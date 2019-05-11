//
//  Airport.swift
//  router
//
//  Created by Johnson Ejezie on 11/05/2019.
//  Copyright © 2019 Guestlogix. All rights reserved.
//

import Foundation
import MapKit

class Airport: Equatable {
    static func == (lhs: Airport, rhs: Airport) -> Bool {
        return lhs.name.lowercased() == rhs.name.lowercased()
    }

    let name: String
    let city: String
    let iata: String?
    let country: String
    let latitude: Double
    let longitude: Double

    var coordinates: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    init(name: String, city: String, iata: String?, latitude: String, longitude: String, country: String) {
        self.name = name
        self.iata = iata
        self.city = city
        self.latitude = Double(latitude) ?? 0.0
        self.longitude = Double(longitude) ?? 0.0
        self.country = country
    }

    static var airports: [Airport] = []

    static func parseCSV(_ completion: @escaping (() -> Void)) {
        let path = Bundle.main.path(forResource: "airports", ofType: "csv")!
        let routeImporter = CSVImporter<Airport>(path: path)
        routeImporter.startImportingRecords(structure: { (headerValues) in
            print(headerValues)
        }) { (recordValues) -> Airport in
            return Airport(name: recordValues["Name"]!, city: recordValues["City"]!, iata: recordValues["IATA 3"]!, latitude: recordValues["Latitute "]!, longitude: recordValues["Longitude"]!, country: recordValues["Country"]!)
            }.onFinish { (importedRecords) -> Void in
                airports = importedRecords
                completion()
        }
    }

}
