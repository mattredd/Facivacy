//
//  ContentView.swift
//  Facivacy
//
//  Created by Matthew Reddin on 05/06/2020.
//  Copyright © 2020 Matthew Reddin. All rights reserved.
//

import SwiftUI

struct MainView: View {
    
    @StateObject var blurViewModel: BlurViewModel = BlurViewModel()
    @State private var manageFaces = false
    @State private var showFaceChooser = false
    @State private var imageSize: CGSize = .zero
    @State private var facePickerStartingLocation = CGSize.zero
    @State private var facePickerRect: CGRect?
    @State private var facePickerOffset = CGSize.zero
    @State private var showShareSheet = false
    @State private var showImagePicker = false
    @Environment(\.verticalSizeClass) var sizeClass
    @Environment(\.displayScale) var displayScale
    
    var body: some View {
        NavigationView {
            VStack {
                if blurViewModel.processedImage != nil {
                    ZStack {
                        if let img = blurViewModel.processedImage {
                            Image(uiImage: UIImage(cgImage: img, scale: displayScale, orientation: blurViewModel.imageOrientation ?? .up))
                                .resizable()
                                .cornerRadius(UIConstants.largeCornerRadius)
                                .shadow(radius: UIConstants.cornerRadius)
                                .aspectRatio(contentMode: .fit)
                                .overlay(GeometryReader { geo in
                                    Color.clear.preference(key: ImageSizeKey.self, value: geo.size)
                                })
                                .onPreferenceChange(ImageSizeKey.self) { val in
                                    showFaceChooser = false
                                    imageSize = val
                                }
                                .overlay(
                                    Group {
                                        if self.showFaceChooser {
                                            ManualRegionSelectionView(offset: $facePickerOffset, facePickerRect: $facePickerRect, imageSize: imageSize) {
                                                withAnimation {
                                                    showFaceChooser = false
                                                }
                                            } blur: {
                                                showFaceChooser = false
                                                blurViewModel.addFace(rect: facePickerRect ?? .zero, imageSize: imageSize)
                                            }
                                        }
                                    })
                                .gesture(facePickerTapGesture)
                            if blurViewModel.imageProcessorIsWorking {
                                ProgessCircularView()
                            }
                        }
                    }
                    .coordinateSpace(name: "imageCoordinate")
                    .padding()
                } else { placeholderView }
            }
            .toolbar {toolbarItems }
            .sheet(isPresented: $manageFaces) { OptionsList(showNewPictureView: $showImagePicker, shoudUseHighConfidenceForFaceDetection: $blurViewModel.shouldUseHighConfidenceForAutomaticFacialDetection, faceCoveringMethod: $blurViewModel.faceCoveringMethod).environmentObject(blurViewModel).onDisappear(perform: self.blurViewModel.updateImage) }
            .sheet(isPresented: $showImagePicker) {
                ImagePickerView(show: $showImagePicker, image: $blurViewModel.sourceImg)
            }
            .navigationBarTitle("Facivacy", displayMode: .inline)
        }
    }
    
    @ToolbarContentBuilder
    var toolbarItems: some ToolbarContent {
        ToolbarItem(placement: ToolbarItemPlacement.navigationBarLeading) {
            if showFaceChooser {
                Button(action: { showFaceChooser = false }) {
                    withAnimation(.spring()) {
                        Text("Cancel")
                    }
                }
                .buttonStyle(.borderedProminent)
                .transition(.opacity.animation(.linear))
            } else {
                Button(action: { manageFaces = true }) {
                    Text("Manage")
                }
                .transition(.opacity.animation(.linear))
            }
        }
        ToolbarItem(placement: ToolbarItemPlacement.navigationBarTrailing) {
            HStack {
                Button(action: { showShareSheet.toggle() }) {
                    Image(systemName: "square.and.arrow.up")
                }
                .popover(isPresented: $showShareSheet) {
                    if let img = blurViewModel.imageForSharing()?.jpegData(compressionQuality: 0.8) {
                        ShareSheetView(showShareSheet: $showShareSheet, finalImage:  img)
                    }
                }
                Button(action: { blurViewModel.findAndDetectFaces() }) {
                    Image(systemName: "wand.and.stars")
                }
            }
            .disabled(blurViewModel.sourceImg == nil)
        }
    }
    
    var placeholderView: some View {
        ZStack {
            ImagePlaceholderView(squareSize: 90)
            VStack {
                Button {
                    showImagePicker.toggle()
                } label: {
                    Text("Add an image")
                }
                .padding(UIConstants.systemSpacing)
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: UIConstants.cornerRadius))
            }
        }
        .overlay(
            Text("To manually cover a portion of the image, tap on the part of the image you wish to conceal.")
                .font(.footnote.weight(.semibold))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(UIConstants.systemSpacing)
                .frame(maxWidth: .infinity)
                .background(.thinMaterial)
            , alignment: .bottom)
        .aspectRatio(1, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: UIConstants.largeCornerRadius))
        .padding()
    }
    
    var facePickerTapGesture: some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .local).onEnded { value in
            withAnimation(.spring()) {
                let location = value.location
                facePickerOffset = CGSize(width: location.x - (imageSize.width / 2), height: location.y - (imageSize.height / 2))
                facePickerStartingLocation = CGSize(width: location.x - (imageSize.width / 2), height: location.y - (imageSize.height / 2))
                showFaceChooser = true
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
