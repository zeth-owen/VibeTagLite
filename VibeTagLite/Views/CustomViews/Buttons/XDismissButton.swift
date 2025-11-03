//
//  XDismissButton.swift
//  VibeTagLite
//
//  Created by Zeth Thomas on 5/8/25.
//

import SwiftUI

struct XDismissButton: View {
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 30, height: 30)
                .foregroundColor(.brandPrimary)
            
            Image(systemName: "xmark")
                .foregroundColor(.white)
                .imageScale(.small)
                .frame(width: 44, height: 44)
        }
    }
}

#Preview {
    XDismissButton()
}
