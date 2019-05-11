//
//  RouteCollectionViewModel.swift
//  router
//
//  Created by Johnson Ejezie on 11/05/2019.
//  Copyright © 2019 Guestlogix. All rights reserved.
//

import Foundation

protocol RouteCollectionViewModelInputs {
    func search(text: String, completion: @escaping (() -> Void))
    func set(airport: Airport)
    func viewDidload()
}

protocol RouteCollectionViewModelOutputs {
    var airports: Observable<[Airport]> { get }
    var editingTextField: EditingTextField { get }
    var departureAirport: Airport? { get }
    var arrivalAirport: Airport? { get }
}

protocol RouteCollectionViewModelType {
    var inputs: RouteCollectionViewModelInputs { get }
    var outputs: RouteCollectionViewModelOutputs { get }
}

final class RouteCollectionViewModel: RouteCollectionViewModelType, RouteCollectionViewModelInputs, RouteCollectionViewModelOutputs {

    private var allAirports: [Airport] = []

    func viewDidload() {
        getAllAirports()
    }

    private func getAllAirports() {
        Airport.parseCSV { (airports) in
            self.allAirports = airports
        }
    }

    func search(text: String, completion: @escaping (() -> Void)) {
        if allAirports.isEmpty {
            Airport.parseCSV { (airports) in
                self.allAirports = airports
                self.airports.value = self.allAirports.filter{ $0.city.lowercased().contains(text.lowercased()) }
                completion()
            }
        } else {
            airports.value = allAirports.filter{ $0.city.lowercased().contains(text.lowercased()) }
            completion()
        }
    }

    func set(airport: Airport) {
        switch editingTextField {
        case .arrival:
            arrivalAirport = airport
        case .departure:
            departureAirport = airport
        default:
            break
        }
    }

    var arrivalAirport: Airport?

    var airports: Observable<[Airport]> = Observable([])

    var editingTextField: EditingTextField = .none

    var departureAirport: Airport?

    var inputs: RouteCollectionViewModelInputs { return self }

    var outputs: RouteCollectionViewModelOutputs { return self }


}

enum EditingTextField {
    case none
    case departure
    case arrival
}
