//
//  PhotoModalView.swift
//  VibeTagLite
//
//  Created by Zeth Thomas on 9/9/25.
//

import SwiftUI

struct PhotoModalView: View {
    
    @Binding var isShowingFeaturedPhoto: Bool
    var featuredPhoto: FeaturedPhoto

    var body: some View {
        ZStack {
            VStack() {
                Image(uiImage: featuredPhoto.createSquareImage())
                    .resizable()
                    .scaledToFit()
                   
                
            }
            .frame(width: 300)
            .overlay(
                Button {
                    withAnimation {
                        isShowingFeaturedPhoto = false
                    }
                } label: {
                    XDismissButton()
                }, alignment: .topTrailing
            )
          
        
           
                
        }
      
    }
}

#Preview {
    PhotoModalView(isShowingFeaturedPhoto: .constant(true),featuredPhoto: FeaturedPhoto(record: MockData.featuredPhoto))
}
