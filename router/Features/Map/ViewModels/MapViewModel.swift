//
//  MapViewModel.swift
//  router
//
//  Created by Johnson Ejezie on 12/05/2019.
//  Copyright © 2019 Guestlogix. All rights reserved.
//

import Foundation

protocol MapViewModelInputs {
    func set(arrAirport: Airport, departureAirport: Airport)
    func viewDidLoad()
    func createVertexForAllAirport()
    func addEdgesToAllVertex()
}

protocol MapViewModelOutputs {
    var path: Observable<[Edge<Airport>]> { get }
    var airports: Observable<[Airport]> { get }
    var showLoader: Observable<Bool> { get }
}

protocol MapViewModelType  {
    var inputs: MapViewModelInputs { get }
    var outputs: MapViewModelOutputs { get }
}

final class MapViewModel: MapViewModelType, MapViewModelOutputs, MapViewModelInputs {
    
    var airports: Observable<[Airport]> = Observable([])

    var inputs: MapViewModelInputs { return self }

    var outputs: MapViewModelOutputs { return self }

    var path: Observable<[Edge<Airport>]> = Observable([])

    var routes: [Route] = []

    var showLoader: Observable<Bool> = Observable(true)

    let graph = AdjacencyList<Airport>()
    var allVertex: [Vertex<Airport>] = []


    func viewDidLoad() {
        fetchData()
    }

    func set(arrAirport: Airport, departureAirport: Airport) {
        showLoader.value = true
        guard let sourceVertex = allVertex.first(where: { $0.data == arrAirport }),
            let destinationVertex = allVertex.first(where: { $0.data == departureAirport }) else { return }
        path.value = paths(from: sourceVertex, to: destinationVertex)
        showLoader.value = false
    }

    func fetchData() {
        Route.parseCSV { (routes) in
            self.routes = routes
            Airport.parseCSV { (airports) in
                self.airports.value = airports
                self.createVertexForAllAirport()
                self.addEdgesToAllVertex()
            }
        }
    }

    func createVertexForAllAirport() {
        allVertex = airports.value.compactMap{ graph.createVertex(data: $0) }
    }

    func addEdgesToAllVertex() {
        for vertex in allVertex {
            let adjacentVertices = airportsAdjacent(to: vertex)
            if !adjacentVertices.isEmpty {
                addEdges(from: vertex, to: adjacentVertices)
            }
        }
        self.showLoader.value = false
    }

    func airportsAdjacent(to vertex: Vertex<Airport>) -> [Vertex<Airport>] {
        let routes = self.routes.filter{ $0.origin == vertex.data.iata }
        let iatas = routes.map{ $0.destination }
        var vertices = [Vertex<Airport>]()
        for aVertex in self.allVertex {
            if iatas.contains(aVertex.data.iata) {
                vertices.append(aVertex)
            }
        }
        return vertices
    }

    func addEdges(from vertex: Vertex<Airport>, to vertices: [Vertex<Airport>]) {
        for aVertex in vertices {
            graph.add(edge: .directed, from: vertex, to: aVertex, weight: 1)
        }

    }

    func paths(from origin: Vertex<Airport>, to destination: Vertex<Airport>) -> [Edge<Airport>] {
        let dijkstra = Dijkstra(graph: graph)
        let pathsFromOrigin = dijkstra.shortestPath(from: origin)
        let path = dijkstra.shortestPath(to: destination, paths: pathsFromOrigin)
        for edge in path {
            print("\(edge.source) --|\(edge.weight ?? 0)|--> \(edge.destination)")
        }
        return path
    }
}
