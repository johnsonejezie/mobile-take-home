//
//  Airline.swift
//  router
//
//  Created by Johnson Ejezie on 11/05/2019.
//  Copyright © 2019 Guestlogix. All rights reserved.
//

import Foundation

class Airline: Equatable {
    static func == (lhs: Airline, rhs: Airline) -> Bool {
        return lhs.name.lowercased() == rhs.name.lowercased()
    }

    let name: String
    let twoDigitCode: String
    let threeDigitCode: String
    let country: String

    init(name: String, twoDigitCode: String, threeDigitCode: String, country: String) {
        self.name = name
        self.twoDigitCode = twoDigitCode
        self.threeDigitCode = threeDigitCode
        self.country = country
    }

    static var airlines: [Airline] = []

    static func parseCSV(_ completion: @escaping (() -> Void)) {
        let path = Bundle.main.path(forResource: "airlines", ofType: "csv")!
        let routeImporter = CSVImporter<Airline>(path: path)
        routeImporter.startImportingRecords(structure: { (headerValues) in
            print(headerValues)
        }) { (recordValues) -> Airline in
            return Airline(name: recordValues["Name"]!, twoDigitCode: recordValues["2 Digit Code"]!, threeDigitCode: recordValues["3 Digit Code"]!, country: recordValues["Country"]!)
            }.onFinish { (importedRecords) -> Void in
                airlines = importedRecords
                completion()
        }
    }

}
