//
//  Edge.swift
//  router
//
//  Created by Johnson Ejezie on 12/05/2019.
//  Copyright © 2019 Guestlogix. All rights reserved.
//

import Foundation

struct Edge<T> {
    let source: Vertex<T>
    let destination: Vertex<T>
    let weight: Int?
}
