//
//  FeaturePhotoView.swift
//  VibeTagLite
//
//  Created by Zeth Thomas on 5/6/25.
//

import SwiftUI

struct FeaturePhotoView: View {
    
    var igHandle: String
    var size: CGFloat
    var featuredImage: UIImage
    
    var body: some View {
        VStack {
            Image(uiImage: featuredImage)
                .resizable()
                .scaledToFit()
                .frame(width: size, height: size)
            
            Text(igHandle)
                .font(.headline)
                .foregroundStyle(.secondary)
                
                
        }
    }
}


