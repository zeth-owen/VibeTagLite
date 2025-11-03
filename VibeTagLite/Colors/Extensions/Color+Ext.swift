//
//  Color+Ext.swift
//  VibeTagLite
//
//  Created by Zeth Thomas on 5/7/25.
//

import SwiftUI

extension Color {
    static let vibeRed = Color(.systemPink)
}

extension View {
    func purpleGradientBackground() -> some View {
        self.background(
            RadialGradient(
                gradient: Gradient(colors: [Color.white, Color.purple]),
                center: .center,
                startRadius: 100,
                endRadius: 500
            )
        )
    }
}
