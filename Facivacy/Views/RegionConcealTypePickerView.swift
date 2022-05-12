//
//  RegionConcealTypePickerView.swift
//  Facivacy
//
//  Created by Matthew Reddin on 12/05/2022.
//  Copyright © 2022 Matthew Reddin. All rights reserved.
//

import SwiftUI
struct ConcealTypePickerView: View {
    
    @Environment(\.colorScheme) var colourScheme
    @Binding var faceCoveringMethod: Int
    let cellSize = 75.0
    let minimumTextScaleFactor = 0.8
    
    var body: some View {
        VStack {
            Text("Face Cover Method")
                .bold()
            HStack {
                let img = UIImage(named: "exampleImage")!.cgImage!
                let context = CIContext()
                Spacer()
                VStack {
                    Image(uiImage: UIImage(cgImage: img.blur(in: CGRect(origin: .zero, size: CGSize(width: img.width, height: img.width)), with: context)!))
                        .resizable()
                        .frame(width: cellSize, height: cellSize)
                        .clipShape(Circle())
                    Text("Blur")
                        .bold()
                        .minimumScaleFactor(minimumTextScaleFactor)
                }
                .padding(UIConstants.systemSpacing)
                .background(RoundedRectangle(cornerRadius: UIConstants.cornerRadius).fill(Color(uiColor: colourScheme != .dark ? .systemGray5 : .systemGray3)).opacity(faceCoveringMethod == 0 ? 1 : 0).shadow(radius: UIConstants.cornerRadius))
                .onTapGesture {
                    withAnimation(.spring()) {
                        faceCoveringMethod = 0
                    }
                }
                Spacer()
                VStack {
                    Image(uiImage: UIImage(cgImage: img.crystallize(in: CGRect(origin: .zero, size: CGSize(width: img.width, height: img.width)), with: context)!))
                        .resizable()
                        .frame(width: cellSize, height: cellSize)
                        .clipShape(Circle())
                    Text("Crystallise")
                        .bold()
                        .minimumScaleFactor(minimumTextScaleFactor)
                }
                .padding(UIConstants.systemSpacing)
                .background(RoundedRectangle(cornerRadius: UIConstants.cornerRadius).fill(Color(uiColor: colourScheme != .dark ? .systemGray5 : .systemGray3)).opacity(faceCoveringMethod == 1 ? 1 : 0).shadow(radius: UIConstants.cornerRadius))
                .onTapGesture {
                    withAnimation(.spring()) {
                        faceCoveringMethod = 1
                    }
                }
                Spacer()
                VStack {
                    Image(uiImage: UIImage(cgImage: img.pixellate(in: CGRect(origin: .zero, size: CGSize(width: img.width, height: img.width)), with: context)!))
                        .resizable()
                        .frame(width: cellSize, height: cellSize)
                        .clipShape(Circle())
                    Text("Pixellate")
                        .bold()
                        .minimumScaleFactor(minimumTextScaleFactor)
                }
                .padding(UIConstants.systemSpacing)
                .background(RoundedRectangle(cornerRadius: UIConstants.cornerRadius).fill(Color(uiColor: colourScheme != .dark ? .systemGray5 : .systemGray3)).opacity(faceCoveringMethod == 2 ? 1 : 0).shadow(radius: UIConstants.cornerRadius))
                .onTapGesture {
                    withAnimation(.spring()) {
                        faceCoveringMethod = 2
                    }
                }
                Spacer()
            }
        }
    }
}
