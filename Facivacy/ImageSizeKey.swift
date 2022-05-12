//
//  ImageSizeKey.swift
//  Facivacy
//
//  Created by Matthew Reddin on 12/05/2022.
//  Copyright © 2022 Matthew Reddin. All rights reserved.
//

import SwiftUI

struct ImageSizeKey: PreferenceKey {
    
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
    
    static var defaultValue: CGSize = .zero
}
