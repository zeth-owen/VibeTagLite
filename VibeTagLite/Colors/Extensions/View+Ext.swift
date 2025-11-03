//
//  View+Ext.swift
//  VibeTagLite
//
//  Created by Zeth Thomas on 5/7/25.
//

import SwiftUI

extension View {
    func stackStyle() -> some View {
        self.modifier(Stack())
    }
}
