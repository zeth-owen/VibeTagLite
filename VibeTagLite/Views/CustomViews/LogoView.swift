//
//  LogoView.swift
//  VibeTagLite
//
//  Created by Zeth Thomas on 5/8/25.
//

import SwiftUI

struct LogoView: View {
    
    var frameWidth: CGFloat
    
    var body: some View {
        Image(decorative: "vibe-map-logo")
            .resizable()
            .scaledToFit()
            .frame(width: frameWidth)
        
    }
}

#Preview {
    LogoView(frameWidth: 250)
}
