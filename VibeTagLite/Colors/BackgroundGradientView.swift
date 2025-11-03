//
//  BackgroundGradientView.swift
//  VibeTagLite
//
//  Created by Zeth Thomas on 5/5/25.
//

import SwiftUI

struct BackgroundGradientView: View {
    var body: some View {
        RadialGradient(gradient: Gradient(colors: [Color.white, Color.purple]),
                       center: .center,
                       startRadius: 100,
                       endRadius: 500)
    }
}

#Preview {
    BackgroundGradientView()
}


