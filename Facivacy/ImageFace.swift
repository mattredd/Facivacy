//
//  ImageFace.swift
//  Facivacy
//
//  Created by Matthew Reddin on 08/06/2020.
//  Copyright © 2020 Matthew Reddin. All rights reserved.
//

import Foundation
import CoreGraphics

struct ImageFace: Hashable {
    
    let id = UUID()
    let normalisedBoundingRect: CGRect
    let detected: Bool
    var isBlurred = true

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
