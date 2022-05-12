//
//  CoreGraphics+Scaling.swift
//  Facivacy
//
//  Created by Matthew Reddin on 07/06/2020.
//  Copyright © 2020 Matthew Reddin. All rights reserved.
//

import Foundation
import CoreGraphics
import CoreImage
import CoreImage.CIFilterBuiltins

extension CGImage {
    func scaleImage(maxSide: CGFloat) -> CGImage? {
        let ratio = CGFloat(self.height) / CGFloat(self.width)
        let height: CGFloat
        let width: CGFloat
        if self.height > self.width {
            height = min(maxSide, CGFloat(self.height))
            width = height / ratio
        } else {
            width = min(maxSide, CGFloat(self.width))
            height = width * ratio
        }
        let ctxt = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: self.bitsPerComponent, bytesPerRow: 0, space: colorSpace ?? CGColorSpaceCreateDeviceRGB(), bitmapInfo: self.bitmapInfo.rawValue)
        ctxt?.interpolationQuality = .high
        ctxt?.draw(self, in: CGRect(origin: .zero, size: .init(width: width, height: height)))
        return ctxt?.makeImage()
    }
    
    func blur(in rect: CGRect, with context: CIContext) -> CGImage? {
        let clamp = CIFilter.affineClamp()
        clamp.inputImage = CIImage(cgImage: self)
        clamp.transform = .init(scaleX: 1.0, y: 1.0)
        let filter = CIFilter.gaussianBlur()
        filter.inputImage = clamp.outputImage!
        filter.radius = 40
        if let outputImage = filter.outputImage, let renderedImage = context.createCGImage(outputImage, from: rect) {
            return renderedImage.ellipseMask()
        } else {
            return nil
        }
    }
    
    func crystallize(in rect: CGRect, with context: CIContext) -> CGImage? {
        let crystallizeFilter = CIFilter.crystallize()
        crystallizeFilter.inputImage = CIImage(cgImage: self)
        crystallizeFilter.radius = 25
        if let outputImage = crystallizeFilter.outputImage, let renderedImage = context.createCGImage(outputImage, from: rect) {
            return renderedImage.ellipseMask()
        } else {
            return nil
        }
    }
    
    func pixellate(in rect: CGRect, with context: CIContext) -> CGImage? {
        let pixellateFilter = CIFilter.pixellate()
        pixellateFilter.inputImage = CIImage(cgImage: self)
        pixellateFilter.scale = 25
        if let outputImage = pixellateFilter.outputImage, let renderedImage = context.createCGImage(outputImage, from: rect) {
            return renderedImage.ellipseMask()
        } else {
            return nil
        }
    }
    
    func ellipseMask() -> CGImage? {
        let maskedContext = CGMutablePath()
        maskedContext.addEllipse(in: .init(origin: .zero, size: .init(width: width, height: height)))
        let imgCtxt = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: 0, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
        imgCtxt?.addPath(maskedContext)
        imgCtxt?.clip()
        imgCtxt?.draw(self, in: .init(origin: .zero, size: .init(width: width, height: height)))
        return imgCtxt?.makeImage()
    }
}
