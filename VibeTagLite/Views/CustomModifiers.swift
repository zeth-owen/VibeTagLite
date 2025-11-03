//
//  CustomModifiers.swift
//  VibeTagLite
//
//  Created by Zeth Thomas on 5/7/25.
//

import Foundation
import SwiftUI

struct Stack: ViewModifier {
    func body(content: Content) -> some View {
        content
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
        .background(.ultraThinMaterial)
        .clipShape(Capsule())
        .shadow(color: .black.opacity(0.3), radius: 6, x: 0, y: 3)
    }
}
