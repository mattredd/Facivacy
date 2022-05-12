//
//  BlurViewModel.swift
//  Facivacy
//
//  Created by Matthew Reddin on 05/06/2020.
//  Copyright © 2020 Matthew Reddin. All rights reserved.
//

import SwiftUI
import Combine
import Vision

class AppViewModel: ObservableObject {
    
    @Published var imageProcessorIsWorking = false
    @AppStorage("confidenceFacialDetection") var shouldUseHighConfidenceForAutomaticFacialDetection = false
    @AppStorage("faceCoveringMethod") var faceCoveringMethod: Int = 0
    private var faceProcessor: ImageProcessor
    var unsupportedImageFormat = false
    var imageOrientation: UIImage.Orientation?
    var observers: [AnyCancellable] = []
    var sourceImg: UIImage? {
        get {
            if let sourceImg = faceProcessor.originalImage {
                return UIImage(cgImage: sourceImg)
            } else { return nil}
        }
        set {
            faceProcessor.originalImage = newValue?.cgImage
        }
    }
    
    init() {
        faceProcessor = ImageProcessor(faceCoverMethod: .blur, shouldUseHighConfidenceForAutomaticFacialDetection: false)
        faceProcessor.faceCoverMethod = FaceCoveringMethod(rawValue: faceCoveringMethod) ?? .blur
        faceProcessor.shouldUseHighConfidenceForAutomaticFacialDetection = shouldUseHighConfidenceForAutomaticFacialDetection
        NotificationCenter.default.publisher(for: .blurredFaces).receive(on: DispatchQueue.main).sink(receiveValue: { [weak self] _ in
            guard let self = self else { return }
            self.objectWillChange.send()
            self.imageProcessorIsWorking = false
        }).store(in: &observers)
    }
    
    deinit {
        observers.forEach { $0.cancel() }
    }
    
    // MARK:- Access to model
    
    var processedImage: CGImage? {
        return faceProcessor.processedImage ?? faceProcessor.scaledImage
    }
    
    var detectedFaces: [ImageFace] {
        Array(faceProcessor.choosenFaces.values)
    }
    
    func image(for face: ImageFace) -> CGImage? {
        self.faceProcessor.imageBeforeBlur(for: face, scaled: true)
    }
    
    // MARK:- UI Intents
    
    func findAndDetectFaces() {
        imageProcessorIsWorking = true
        faceProcessor.detectAndCoverFaces()
    }
    
    func newImage(img: UIImage) {
        unsupportedImageFormat = false
        guard let cgImg = img.cgImage else { unsupportedImageFormat = true; return }
        faceProcessor.originalImage = cgImg
        imageOrientation = img.imageOrientation
        if faceProcessor.scaledImage == nil {
            unsupportedImageFormat = true
        }
    }
    
    func addFace(rect: CGRect, imageSize: CGSize) {
        imageProcessorIsWorking = true
        var normalisedRect = CGRect(x: rect.origin.x / imageSize.width, y: (rect.origin.y + rect.size.height) / imageSize.height, width: rect.size.width / imageSize.width, height: rect.size.height / imageSize.height)
        normalisedRect.origin.y = 1 - normalisedRect.origin.y
        faceProcessor.addFace(normalisedRect: normalisedRect)
    }
    
    func toggleBlur(for face: ImageFace) {
        objectWillChange.send()
        self.faceProcessor.choosenFaces[face.id]?.isBlurred.toggle()
    }
    
    func updateImage() {
        objectWillChange.send()
        faceProcessor.shouldUseHighConfidenceForAutomaticFacialDetection = shouldUseHighConfidenceForAutomaticFacialDetection
        faceProcessor.faceCoverMethod = FaceCoveringMethod(rawValue: faceCoveringMethod) ?? .blur
        imageProcessorIsWorking = true
        faceProcessor.processedImage = self.faceProcessor.createImage(scaled: true)
    }
    
    func deleteManuallyAddedFace(id: UUID) {
        objectWillChange.send()
        faceProcessor.choosenFaces.removeValue(forKey: id)
    }
    
    func imageForSharing() -> UIImage? {
        if let shareImage = faceProcessor.createImage(scaled: false) {
            return UIImage(cgImage: shareImage)
        } else {
            return nil
        }
    }
}
