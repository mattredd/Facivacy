//
//  ImagePlaceholderShape.swift
//  Facivacy
//
//  Created by Matthew Reddin on 23/01/2022.
//

import SwiftUI

struct ImagePlaceholderShape: Shape {
    
    let squareSize: Double
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let numberOfSquares = CGFloat(Int(rect.width / squareSize))
        let remainingSquareSize = rect.width - (numberOfSquares * squareSize)
        var startingPoint = remainingSquareSize / 2.0
        path.move(to: CGPoint(x: startingPoint, y: 0))
        while startingPoint <= rect.width {
            path.addLine(to: CGPoint(x: startingPoint, y: rect.height))
            startingPoint += squareSize
            path.move(to: CGPoint(x: startingPoint, y: 0))
        }
        let numberOfVerticalSqaures = CGFloat(Int(rect.height / squareSize))
        let remaingVerticalSquare = rect.height - (numberOfVerticalSqaures * squareSize)
        var verticalStartingPoint = remaingVerticalSquare / 2
        path.move(to: CGPoint(x: 0, y: verticalStartingPoint))
        while verticalStartingPoint <= rect.height {
            path.addLine(to: CGPoint(x: rect.width, y: verticalStartingPoint))
            verticalStartingPoint += squareSize
            path.move(to: CGPoint(x: 0, y: verticalStartingPoint))
        }
        return path
    }
}

struct ImagePlaceholderView: View {
    
    let squareSize: Double
    
    var body: some View {
        ImagePlaceholderShape(squareSize: squareSize)
            .stroke(.white, style: .init(lineWidth: 1, dash: [10, 3]))
            .background(.linearGradient(colors: [.blue.opacity(0.7), .blue.opacity(0.4)], startPoint: .topLeading, endPoint: .bottomTrailing))
    }
}
