//
//  FaceChooserView.swift
//  Facivacy
//
//  Created by Matthew Reddin on 09/06/2020.
//  Copyright © 2020 Matthew Reddin. All rights reserved.
//

import SwiftUI

struct ManualRegionSelectionView: View {
    
    @State private var circleRadius: Double = 0
    @State private var magnifyBy: Double = 1
    @Binding var offset: CGSize
    @State var currentOffset = CGSize.zero
    @State var buttonsHeight: Double = 0
    @Binding var facePickerRect: CGRect?
    let imageSize: CGSize
    let cancel: () -> ()
    let blur: () -> ()
    let fontSize = 14.0
    let maxCircleSize = 300.0
    let minCircleSize = 100.0
    let circleStokeLineWidth = 5.0
    
    var body: some View {
        VStack(spacing: UIConstants.systemSpacing) {
            ZStack {
                Circle()
                    .strokeBorder(Color.black, lineWidth: circleStokeLineWidth)
                Circle()
                    .fill(LinearGradient(gradient: .init(colors: [Color(.init(white: 1.0, alpha: 0.5)), Color(.init(white: 1.0, alpha: 0.1))]), startPoint: .topLeading, endPoint: .bottomTrailing))
            }
            .frame(width: max(minCircleSize, min(maxCircleSize, self.circleRadius * self.magnifyBy)), height: max(minCircleSize, min(maxCircleSize, self.circleRadius * self.magnifyBy)))
            Button {
                blur()
            } label: {
                Text("Cover")
                    .font(.system(size: fontSize))
                    .fontWeight(.semibold)
            }
            .buttonStyle(.borderedProminent)
            .tint(.red)
                .disabled(!CGRect(origin: .zero, size: imageSize).intersects(facePickerRect ?? .zero))
                .offset(x: 0, y: offset.height + currentOffset.height >= 0 ? -max(minCircleSize, min(maxCircleSize, self.circleRadius * self.magnifyBy)) - fontSize - (UIConstants.systemSpacing * 4) : 0)
        }
        .offset(CGSize(width: offset.width + currentOffset.width, height: offset.height + currentOffset.height + (fontSize + UIConstants.systemSpacing * 3) / 2))
        .gesture(viewGesture(size: imageSize))
        .onAppear {
            circleRadius = imageSize.width * 0.2
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            updateRect(imageSize: imageSize)
        }
        .transition(.scale)
    }
    
    func viewGesture(size: CGSize) -> some Gesture {
        DragGesture().onChanged({ (value) in
            currentOffset = value.translation
            updateRect(imageSize: size)
        }).onEnded( { _ in
            offset = CGSize(width: offset.width + currentOffset.width, height: offset.height + currentOffset.height)
            currentOffset = .zero
            updateRect(imageSize: size)
        }).exclusively(before: MagnificationGesture().onChanged({ val in
            updateRect(imageSize: size)
            DispatchQueue.main.async {
                magnifyBy = val
            }
        }).onEnded( {
            self.circleRadius *= $0
            updateRect(imageSize: size)
        }))
    }
    
    func updateRect(imageSize: CGSize) {
        let offset = CGSize(width: offset.width + currentOffset.width, height: offset.height + currentOffset.height + (fontSize + UIConstants.systemSpacing * 3) / 2)
        let size = CGSize(width: max(100, min(300, self.circleRadius * self.magnifyBy)), height: max(100, min(300, self.circleRadius * self.magnifyBy)))
        facePickerRect = CGRect(origin: CGPoint(x: offset.width + (imageSize.width / 2) - size.width / 2, y: offset.height + (imageSize.height / 2) - (size.height + (fontSize + UIConstants.systemSpacing * 3)) / 2) , size: size)
    }
}
