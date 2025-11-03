//
//  SCurveHeader.swift
//  VibeTagLite
//
//  Created by Zeth Thomas on 5/13/25.
//

import SwiftUI

struct SCurveHeader: View {
    var title: String
  
    
    var body: some View {
        ZStack() {
            SCurveShape()
                .fill( RadialGradient(gradient: Gradient(colors: [Color.white, Color.purple]),
                                      center: .center,
                                      startRadius: 400,
                                      endRadius: 0))
              
            Text(title)
                .font(.largeTitle)
                .bold()
                .foregroundStyle(.white.shadow(.drop(color: .black.opacity(0.5), radius: 3)))
                
        }
        .edgesIgnoringSafeArea(.top)
    }
}

#Preview {
    SCurveHeader(title: "Sample")
}
