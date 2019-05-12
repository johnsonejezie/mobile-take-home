//
//  Graph.swift
//  router
//
//  Created by Johnson Ejezie on 12/05/2019.
//  Copyright © 2019 Guestlogix. All rights reserved.
//

import Foundation


protocol Graph {
    
    associatedtype Element

    func createVertex(data: Element) -> Vertex<Element>
    func addDirectedEdge(from source: Vertex<Element>, to destination: Vertex<Element>, weight: Int?)
    func addUndirectedEdge(between source: Vertex<Element>, and destination: Vertex<Element>, weight: Int?)
    func add(edge: EdgeType, from source: Vertex<Element>, to destination: Vertex<Element>, weight: Int?)
    func edges(from source: Vertex<Element>) -> [Edge<Element>]
    func weight(from source: Vertex<Element>, to destination: Vertex<Element>) -> Int?
}

extension Graph {

    func addUndirectedEdge(between source: Vertex<Element>, and destination: Vertex<Element>, weight: Int?) {
        addDirectedEdge(from: source, to: destination, weight: weight)
        addDirectedEdge(from: destination, to: source, weight: weight)
    }

    func add(edge: EdgeType, from source: Vertex<Element>, to destination: Vertex<Element>, weight: Int?) {
        switch edge {
        case .directed:
            addDirectedEdge(from: source, to: destination, weight: weight)
        case .undirected:
            addUndirectedEdge(between: source, and: destination, weight: weight)
        }
    }
}

enum EdgeType {
    case directed
    case undirected
}
