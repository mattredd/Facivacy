//
//  FaceListCell.swift
//  Facivacy
//
//  Created by Matthew Reddin on 12/05/2022.
//  Copyright © 2022 Matthew Reddin. All rights reserved.
//

import SwiftUI

struct FaceListCell: View {
    
    @EnvironmentObject var viewModel: AppViewModel
    @Environment(\.displayScale) var displayScale
    let face: ImageFace
    let cellSize = 80.0
    
    var body: some View {
        HStack {
            Spacer()
            if let image = viewModel.image(for: face) {
                Image(uiImage: UIImage(cgImage: image, scale: displayScale, orientation: viewModel.imageOrientation ?? .up))
                    .resizable()
                    .cornerRadius(UIConstants.cornerRadius)
                    .frame(width: cellSize, height: cellSize)
            } else {
                Color.red
                    .cornerRadius(UIConstants.cornerRadius)
                    .frame(width: cellSize, height: cellSize)
            }
            Spacer()
            Button {
                viewModel.toggleBlur(for: face)
            } label: {
                ZStack {
                    Text("Covered")
                        .opacity(face.isBlurred ? 1 : 0)
                    Text("Uncovered")
                        .opacity(face.isBlurred ? 0 : 1)
                }
            }
            .buttonStyle(.bordered)
            .contentShape(Rectangle())
            Spacer()
        }
    }
}
