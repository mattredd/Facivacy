//
//  DetectedFacesView.swift
//  Facivacy
//
//  Created by Matthew Reddin on 08/06/2020.
//  Copyright © 2020 Matthew Reddin. All rights reserved.
//

import SwiftUI

struct BlurredFacesList: View {
    
    @EnvironmentObject var viewModel: AppViewModel
    
    var body: some View {
        List {
            Section(header: Text("Detected Faces")) {
                ForEach(viewModel.detectedFaces.filter(\.detected), id: \.self) { face in
                    FaceListCell(face: face)
                        .environmentObject(viewModel)
                }
            }
            Section(header: Text("Manually Added Faces")) {
                ForEach(viewModel.detectedFaces.filter{ !$0.detected }, id: \.self) { face in
                    FaceListCell(face: face)
                        .environmentObject(viewModel)
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                withAnimation(.spring()) {
                                    viewModel.deleteManuallyAddedFace(id: face.id)
                                }
                            } label: {
                                Text("Delete")
                            }
                        }
                }
            }
        }
    }
}
