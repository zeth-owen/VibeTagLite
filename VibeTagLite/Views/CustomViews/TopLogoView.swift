//
//  TopLogoView.swift
//  VibeTagLite
//
//  Created by Zeth Thomas on 5/7/25.
//

import SwiftUI

struct TopLogoView: View {
    
    var title: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Image(systemName: "bolt.horizontal")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
    }
}


#Preview {
    TopLogoView(title: "VibeTag")
}
