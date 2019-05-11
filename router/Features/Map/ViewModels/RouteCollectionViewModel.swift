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
    func selectedAirport(with name: String)
}

protocol RouteCollectionViewModelOutputs {
    var airports: Observable<[Airport]> { get }
    var editingTextField: EditingTextField { get }
    var departureAirport: Airport? { get }
    var arrivalAirport: Airport? { get }
    var isSearchButtonEnabled: Observable<Bool> { get }
}

protocol RouteCollectionViewModelType {
    var inputs: RouteCollectionViewModelInputs { get }
    var outputs: RouteCollectionViewModelOutputs { get }
}

final class RouteCollectionViewModel: RouteCollectionViewModelType, RouteCollectionViewModelInputs, RouteCollectionViewModelOutputs {

    private var allAirports: [Airport] = []

    init() {
        getAllAirports {}
    }

    func getAllAirports(_ completion: @escaping (() -> Void)) {
        Airport.parseCSV { (airports) in
            self.allAirports = airports
            completion()
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

    func selectedAirport(with name: String) {
        let airport = allAirports.first(where: { $0.name.lowercased() == name.lowercased() })
        switch editingTextField {
        case .arrival:
            arrivalAirport = airport
        case .departure:
            departureAirport = airport
        default:
            break
        }
        guard let arrival = arrivalAirport,
            let departure = departureAirport else {
                isSearchButtonEnabled.value = false
                return
        }
        if arrival == departure {
            isSearchButtonEnabled.value = false
            return
        }

        isSearchButtonEnabled.value = true
    }

    var isSearchButtonEnabled: Observable<Bool> = Observable(false)

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
