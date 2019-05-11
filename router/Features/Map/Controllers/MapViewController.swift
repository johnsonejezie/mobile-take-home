//
//  MapViewController.swift
//  router
//
//  Created by Johnson Ejezie on 11/05/2019.
//  Copyright © 2019 Guestlogix. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet var mapView: MKMapView!
    @IBOutlet var searchButton: UIButton!

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showRouteCollectionView()
    }

    private func showRouteCollectionView() {
        let controller = storyboard?.instantiateViewController(withIdentifier: RouteCollectionViewController.storyboardID) as! RouteCollectionViewController
        let VM = RouteCollectionViewModel()
        controller.viewModel = VM
        controller.delegate = self
        controller.definesPresentationContext = true
        controller.modalPresentationStyle = .overFullScreen
        controller.providesPresentationContextTransitionStyle = true
        present(controller, animated: true, completion: nil)
        searchButton.isHidden = true
    }

    @IBAction func showOrDismissSearchView(_ sender: Any) {
        showRouteCollectionView()
    }

}

extension MapViewController: RouteCollectionViewControllerDelegate {
    func routeCollectionViewControllerDidCancel() {
        searchButton.isHidden = false
    }

    func routeCollectionViewController(controller: RouteCollectionViewController, didSelectArrival arrAirport: Airport, andDeparture departure: Airport) {
        searchButton.isHidden = false
    }
}
