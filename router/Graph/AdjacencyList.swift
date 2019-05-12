//
//  AdjacencyList.swift
//  router
//
//  Created by Johnson Ejezie on 12/05/2019.
//  Copyright © 2019 Guestlogix. All rights reserved.
//

import Foundation

final class AdjacencyList<T: Hashable>: Graph {

    private var adjacencies: [Vertex<T>: [Edge<T>]] = [:]

    init() {}

    func createVertex(data: T) -> Vertex<T> {
        let vertex = Vertex(index: adjacencies.count, data: data)
        adjacencies[vertex] = []
        return vertex
    }

    func addDirectedEdge(from source: Vertex<T>, to destination: Vertex<T>, weight: Int?) {
        let edge = Edge(source: source, destination: destination, weight: weight)
        adjacencies[source]?.append(edge)
    }

    func edges(from source: Vertex<T>) -> [Edge<T>] {
        return adjacencies[source] ?? []
    }

    func weight(from source: Vertex<T>, to destination: Vertex<T>) -> Int? {
        return edges(from: source).first { $0.destination == destination }?.weight
    }
}
