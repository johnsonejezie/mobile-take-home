//
//  RouteCollectionViewController.swift
//  router
//
//  Created by Johnson Ejezie on 11/05/2019.
//  Copyright © 2019 Guestlogix. All rights reserved.
//

import UIKit

protocol RouteCollectionViewControllerDelegate: class {
    func routeCollectionViewController(controller: RouteCollectionViewController, didSelectArrival arrAirport: Airport, andDeparture departure: Airport)
    func routeCollectionViewControllerDidCancel()
}

class RouteCollectionViewController: UIViewController {

    @IBOutlet var arrivalLabel: UILabel!
    @IBOutlet var departureLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var searchButton: UIButton!
    @IBOutlet var contentView: UIView!
    @IBOutlet var arrivalTextField: UITextField!
    @IBOutlet var departureTextField: UITextField!

    weak var delegate: RouteCollectionViewControllerDelegate?
    var viewModel: RouteCollectionViewModel!
    private let dropDown = DropDown()
    private var disposeBag = Disposal()

    static var storyboardID: String {
        return String(describing: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setTexts()
        setupDropDown()
        bindToViewModel()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchButton.layer.cornerRadius = searchButton.bounds.height/2
        searchButton.layer.masksToBounds = true
        searchButton.layer.borderWidth = 1
        searchButton.layer.borderColor = searchButton.titleLabel!.textColor.cgColor
    }

    private func setTexts() {
        titleLabel.text = TEXTS.selectDepartureAndArrival
        departureLabel.text = TEXTS.departureAirport
        arrivalLabel.text = TEXTS.arrivalAirport
        searchButton.setTitle(TEXTS.search, for: .normal)
        arrivalTextField.placeholder = TEXTS.arrival
        departureTextField.placeholder = TEXTS.departure
    }

    private func setupDropDown() {
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.viewModel.inputs.selectedAirport(with: item)
            if self.viewModel.editingTextField == .arrival {
                self.arrivalTextField.text = item
            } else {
                self.departureTextField.text = item
            }
        }
        dropDown.width = arrivalTextField.bounds.width
        dropDown.direction = .top
    }

    private func bindToViewModel() {
        viewModel.airports.observe { [weak self] (airports) in
            self?.dropDown.dataSource = airports.map{ $0.name }
        }.add(to: &disposeBag)

        viewModel.isSearchButtonEnabled.observe { [weak self] (isEnabled) in
            self?.searchButton.isEnabled = isEnabled
        }.add(to: &disposeBag)
    }

    @IBAction func textFieldDidChange(_ sender: UITextField) {
        dropDown.show()
        if sender == arrivalTextField {
            dropDown.anchorView = arrivalLabel
            viewModel.editingTextField = .arrival
        } else {
            dropDown.anchorView = departureLabel
            viewModel.editingTextField = .departure
        }
        guard let text = sender.text, !text.isEmpty else {
            viewModel.isSearchButtonEnabled.value = false
            return
        }
        viewModel.search(text: text)
    }

    @IBAction func closeTapped(_ sender: Any) {
        delegate?.routeCollectionViewControllerDidCancel()
        dismiss(animated: true, completion: nil)
    }

    @IBAction func searchTapped(_ sender: Any) {
        guard let arrival = viewModel.arrivalAirport else {
            showAlert(message: "Arrival location you entered is not in our database")
            return
        }
        guard let departure = viewModel.departureAirport else {
            showAlert(message: "Departure location you entered is not in our database")
            return
        }
        delegate?.routeCollectionViewController(controller: self, didSelectArrival: arrival, andDeparture: departure)
        dismiss(animated: true, completion: nil)
    }
}
