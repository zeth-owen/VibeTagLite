//
//  LoadingView.swift
//  VibeTagLite
//
//  Created by Zeth Thomas on 5/9/25.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .opacity(0.9)
                .edgesIgnoringSafeArea(.all)
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .brandPrimary))
                .scaleEffect(2)
                .offset(y: -40)
        }
    }
}

#Preview {
    LoadingView()
}
