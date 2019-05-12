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

    let viewModel = MapViewModel()
    private var disposeBag = Disposal()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.inputs.viewDidLoad()
        bindToViewModel()
        mapView.delegate = self
    }

    private func bindToViewModel() {
        viewModel.airports.observe { [weak self] (airports) in
            if !airports.isEmpty {
                self?.showRouteCollectionView()
            }
        }.add(to: &disposeBag)

        viewModel.path.observe { [weak self] (path) in
            if path.isEmpty {
                self?.showAlert(message: TEXTS.noRouteFound)
            } else {
                self?.updateMapView(path)
            }
        }.add(to: &disposeBag)

        viewModel.showLoader.observe { [weak self] (yes) in
            if yes {
                self?.showLoader()
            } else {
                self?.removeLoader()
            }
        }.add(to: &disposeBag)
    }

    private func showRouteCollectionView() {
        let controller = storyboard?.instantiateViewController(withIdentifier: RouteCollectionViewController.storyboardID) as! RouteCollectionViewController
        let VM = RouteCollectionViewModel(allAirport: viewModel.outputs.airports.value)
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

    private func updateMapView(_ paths: [Edge<Airport>]) {
        var annotations: [Pin] = []
        var coordinates = [CLLocationCoordinate2D]()
        let overlays = mapView.overlays
        mapView.removeOverlays(overlays)
        mapView.removeAnnotations(mapView.annotations)
        for edge in paths {
            let source = edge.source.data
            let destination = edge.destination.data
            let sourcePin = Pin(title: source.name, coordinate: source.coordinates, subtitle: source.city)
            let destinationPin = Pin(title: destination.name, coordinate: destination.coordinates, subtitle: destination.city)
            coordinates.append(edge.source.data.coordinates)
            coordinates.append(edge.destination.data.coordinates)
            annotations.append(sourcePin)
            annotations.append(destinationPin)
        }
        let polygon = MKPolygon(coordinates: coordinates, count: coordinates.count)
        mapView.addOverlay(polygon)
        mapView.showAnnotations(annotations, animated: true)
    }

    private func showLoader() {
        let controller = storyboard?.instantiateViewController(withIdentifier: LoaderViewController.storyboardID) as! LoaderViewController
        add(controller)
    }

    private func removeLoader() {
        remove()
    }

}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 5.0
        return renderer
    }
}

extension MapViewController: RouteCollectionViewControllerDelegate {
    func routeCollectionViewControllerDidCancel() {
        searchButton.isHidden = false
    }

    func routeCollectionViewController(controller: RouteCollectionViewController, didSelectArrival arrAirport: Airport, andDeparture departure: Airport) {
        viewModel.inputs.set(arrAirport: arrAirport, departureAirport: departure)
        searchButton.isHidden = false
    }
}


class Pin: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    let title: String?
    let subtitle: String?

    init(title: String, coordinate: CLLocationCoordinate2D, subtitle: String) {
        self.title = title
        self.coordinate = coordinate
        self.subtitle = subtitle
    }
}
