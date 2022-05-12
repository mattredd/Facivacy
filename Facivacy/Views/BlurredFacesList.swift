//
//  DetectedFacesView.swift
//  Facivacy
//
//  Created by Matthew Reddin on 08/06/2020.
//  Copyright © 2020 Matthew Reddin. All rights reserved.
//

import SwiftUI

struct BlurredFacesList: View {
    
    @EnvironmentObject var blurModel: BlurViewModel
    
    var body: some View {
        List {
            Section(header: Text("Detected Faces")) {
                ForEach(blurModel.detectedFaces.filter(\.detected), id: \.self) { face in
                    FaceListCell(face: face)
                        .environmentObject(blurModel)
                }
            }
            Section(header: Text("Manually Added Faces")) {
                ForEach(blurModel.detectedFaces.filter{ !$0.detected }, id: \.self) { face in
                    FaceListCell(face: face)
                        .environmentObject(blurModel)
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                withAnimation(.spring()) {
                                    blurModel.deleteManuallyAddedFace(id: face.id)
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
