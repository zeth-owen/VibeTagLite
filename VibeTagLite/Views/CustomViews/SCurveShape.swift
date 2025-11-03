//
//  SCurveShape.swift
//  VibeTagLite
//
//  Created by Zeth Thomas on 5/13/25.
//

import SwiftUI

struct SCurveShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: 0, y: rect.height*0.75))
        path.addCurve(to: CGPoint(x: rect.width, y: rect.height),
                      control1: CGPoint(x: rect.width*0.25, y: rect.height*0.55),
                      control2: CGPoint(x: rect.width*0.75, y: rect.height*0.95))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        return path
    }
}


#Preview {
    SCurveShape()
}
