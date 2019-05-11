//
//  Route.swift
//  router
//
//  Created by Johnson Ejezie on 11/05/2019.
//  Copyright © 2019 Guestlogix. All rights reserved.
//

import Foundation

class Route: Equatable {
    static func == (lhs: Route, rhs: Route) -> Bool {
        return lhs.airlineID == rhs.airlineID && lhs.origin == rhs.origin && lhs.destination == rhs.destination
    }

    let airlineID: String
    let origin: String
    let destination: String

    init(airlineID: String, origin: String, destination: String) {
        self.airlineID = airlineID
        self.origin = origin
        self.destination = destination
    }


    static func parseCSV(_ completion: @escaping (([Route]) -> Void)) {
        let path = Bundle.main.path(forResource: "routes", ofType: "csv")!
        let routeImporter = CSVImporter<Route>(path: path)
        routeImporter.startImportingRecords(structure: { (headerValues) in
            print(headerValues)
        }) { (recordValues) -> Route in
            return Route(airlineID: recordValues["Airline Id"]!, origin: recordValues["Origin"]!, destination: recordValues["Destination"]!)
            }.onFinish { (routes) -> Void in
                completion(routes)
        }
    }

}
