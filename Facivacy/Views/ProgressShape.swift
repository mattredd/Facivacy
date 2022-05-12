//
//  ProgressShape.swift
//  Facivacy
//
//  Created by Matthew Reddin on 02/05/2022.
//  Copyright © 2022 Matthew Reddin. All rights reserved.
//

import SwiftUI

struct ProgressShape: Shape {
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let radiusFraction = 0.85
        let radius = min(rect.width / 2, rect.height / 2) * radiusFraction
        let inset = min(rect.width / 2, rect.height / 2) * (1.0 - radiusFraction)
        for i in stride(from: 0, to: 2 * Double.pi, by: 2 * Double.pi / 10) {
            let xVal = radius * cos(i) + rect.midX
            let yVal = radius * sin(i) + rect.midY
            path.addEllipse(in: CGRect(origin: CGPoint(x: xVal - inset, y: yVal - inset), size: CGSize(width: inset * 2, height: inset * 2)))
        }
        return path
    }
}

struct ProgessCircularView: View {
    
    @State private var maskAngle = Angle(radians: 0)
    let size = 50.0
    
    var body: some View {
        ZStack {
            ProgressShape().path(in: CGRect(origin: .zero, size: CGSize(width: size, height: size))).stroke(.indigo)
            ProgressShape().path(in: CGRect(origin: .zero, size: CGSize(width: size, height: size))).fill(.indigo)
                .mask {
                    AngularGradient(colors: [.black, .white, .black], center: .center, angle: maskAngle)
                        .luminanceToAlpha()
                }
                .onAppear {
                    withAnimation(.linear(duration: 1.0).repeatForever(autoreverses: false)) {
                        maskAngle = Angle(radians: 2.0 * .pi)
                    }
                }
        }
        .frame(width: size, height: size, alignment: .center)
        .padding(UIConstants.systemSpacing)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 10))
    }
    
}

struct ProgrssCircularView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
        ProgessCircularView()
            .previewLayout(.fixed(width: 50, height: 50))
        }
    }
}

