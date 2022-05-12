//
//  FaceProcessor.swift
//  Facivacy
//
//  Created by Matthew Reddin on 05/06/2020.
//  Copyright © 2020 Matthew Reddin. All rights reserved.
//

import Foundation
import Vision
import ImageIO
import CoreImage
import CoreImage.CIFilterBuiltins

extension NSNotification.Name {

    static let blurredFaces = NSNotification.Name("blurredFaces")
}

class ImageProcessor {
    
    private let processorQueue = DispatchQueue(label: "com.mattredd.imageprocessor", qos: .userInitiated, attributes: .concurrent)
    private(set) var scaledImage: CGImage?
    var faceCoverMethod: FaceCoveringMethod
    var shouldUseHighConfidenceForAutomaticFacialDetection: Bool
    var choosenFaces: [UUID : ImageFace] = [:]
    var processedImage: CGImage? {
        willSet {
            NotificationCenter.default.post(.init(name: .blurredFaces))
        }
    }
    var originalImage: CGImage? {
        didSet {
            scaledImage = originalImage?.scaleImage(maxSide: 1000)
            processedImage = nil
            choosenFaces.removeAll()
        }
    }
    
    init(faceCoverMethod: FaceCoveringMethod, shouldUseHighConfidenceForAutomaticFacialDetection: Bool) {
        self.faceCoverMethod = faceCoverMethod
        self.shouldUseHighConfidenceForAutomaticFacialDetection = shouldUseHighConfidenceForAutomaticFacialDetection
    }

    func detectAndCoverFaces() {
        guard let scaledImage = scaledImage else {
            return
        }
        findFaces(with: scaledImage) { [weak self] in
            guard let self = self else { return }
            for value in self.choosenFaces.values {
                if value.detected {
                    self.choosenFaces.removeValue(forKey: value.id)
                }
            }
            switch $0 {
            case .success(let faces):
                for i in faces {
                    let newFace = ImageFace(normalisedBoundingRect: i.boundingBox, detected: true)
                    self.choosenFaces[newFace.id] = newFace
                }
                self.processedImage = self.createImage(scaled: true)
            case .failure(_):
                break
            }
        }
    }
    
    func imageBeforeBlur(for face: ImageFace, insets: CGFloat = 0, scaled: Bool) -> CGImage? {
        guard let scaledImage = scaledImage, let originalImage = originalImage else {
            return nil
        }
        let imgSize = CGSize(width: scaled ? scaledImage.width : originalImage.width, height: scaled ? scaledImage.height : originalImage.height)
        var imgRect = VNImageRectForNormalizedRect(face.normalisedBoundingRect, Int(imgSize.width), Int(imgSize.height))
        imgRect.origin.y = abs(imgRect.origin.y - imgSize.height) - imgRect.height
        imgRect = imgRect.inset(by: .init(top: -insets, left: -insets, bottom: -insets, right: -insets))
        return scaled ? scaledImage.cropping(to: imgRect) : originalImage.cropping(to: imgRect)
    }
    
    func addFace(normalisedRect: CGRect) {
        let face = ImageFace(normalisedBoundingRect: normalisedRect, detected: false)
        choosenFaces[face.id] = face
        processedImage = createImage(scaled: true)
    }
    
    func createImage(scaled: Bool) -> CGImage? {
        guard let originalImage = originalImage, let scaledImage = scaledImage else {
            return nil
        }
        let imgSize = scaled ? CGSize(width: scaledImage.width, height: scaledImage.height) : CGSize(width: originalImage.width, height: originalImage.height)
        let ctxt = CGContext(data: nil, width: Int(imgSize.width), height: Int(imgSize.height), bitsPerComponent: originalImage.bitsPerComponent, bytesPerRow: 0, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: scaledImage.alphaInfo.rawValue)
        ctxt?.draw(scaled ? scaledImage : originalImage, in: CGRect(origin: .zero, size: imgSize))
        let ciContext = CIContext()
        for i in choosenFaces.values.filter(\.isBlurred) {
            let inset: CGFloat = i.detected ? Double(max(imgSize.width, imgSize.height)) * 0.05 : 0
            let rect = VNImageRectForNormalizedRect(i.normalisedBoundingRect, Int(imgSize.width), Int(imgSize.height)).insetBy(dx: -inset, dy: -inset)
            guard let faceImage = imageBeforeBlur(for: i, insets: inset, scaled: scaled) else { return nil }
            let coveredImage: CGImage?
            switch faceCoverMethod {
            case .blur:
                coveredImage = faceImage.blur(in: CGRect(origin: .zero, size: CGSize(width: rect.size.width, height: rect.size.height)), with: ciContext)
            case .crystallize:
                coveredImage = faceImage.crystallize(in: CGRect(origin: .zero, size: CGSize(width: rect.size.width, height: rect.size.height)), with: ciContext)
            case .pixellate:
                coveredImage = faceImage.pixellate(in: CGRect(origin: .zero, size: CGSize(width: rect.size.width, height: rect.size.height)), with: ciContext)
            }
            guard let blurredImg = coveredImage else {
                return nil
            }
            ctxt?.draw(blurredImg, in: CGRect(origin: rect.origin, size: .init(width: blurredImg.width, height: blurredImg.height)))
        }
        return ctxt?.makeImage()
    }
}

// Face Detection Method
extension ImageProcessor {
    
    private func findFaces(with img: CGImage, completion: @escaping (Result<[VNFaceObservation], Error>) -> ()) {
        let faceRequest = VNDetectFaceRectanglesRequest { req, err in
            guard err == nil else { completion(.failure(err!)); return }
            let results = (req.results as! [VNFaceObservation]).filter( { $0.confidence >= (self.shouldUseHighConfidenceForAutomaticFacialDetection ? 0.8 : 0.4) })
            completion(.success(results))
        }
        let handler = VNImageRequestHandler(cgImage: img)
        processorQueue.async {
            do {
                try handler.perform([faceRequest])
            } catch {
                completion(.failure(error))
            }
        }
    }
}
