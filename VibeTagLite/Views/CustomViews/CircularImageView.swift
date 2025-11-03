//
//  CircularImageView.swift
//  VibeTagLite
//
//  Created by Zeth Thomas on 6/7/25.
//

import SwiftUI

struct CircularImageView: View {
    var imageName: String
    var size: CGFloat
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            Circle()
                .strokeBorder(.white, lineWidth: 6)
                .frame(width: size * 1.05,  height: size * 1.05)
                .scaleEffect(isAnimating ? 1.05 : 0.95)
                .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: isAnimating)
                .onAppear {
                    isAnimating = true
                }
            
            Circle()
                .strokeBorder(.white, lineWidth: 6)
                .frame(width: size * 1.2,  height: size * 1.2)
                .scaleEffect(isAnimating ? 1.05 : 0.95)
                .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: isAnimating)
                .onAppear {
                    isAnimating = true
                }
            Circle()
                .strokeBorder(.white, lineWidth: 6)
                .frame(width: size * 1.4,  height: size * 1.4)
                .scaleEffect(isAnimating ? 1.05 : 0.95)
                .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: isAnimating)
                .onAppear {
                    isAnimating = true
                }
            Circle()
                .strokeBorder(.white, lineWidth: 6)
                .frame(width: size * 1.6,  height: size * 1.6)
                .scaleEffect(isAnimating ? 1.05 : 0.95)
                .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: isAnimating)
                .onAppear {
                    isAnimating = true
                }

            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: size, height: size)
                .clipShape(Circle())
                .scaleEffect(isAnimating ? 1.05 : 0.95)
                .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: isAnimating)
                .onAppear {
                    isAnimating = true
                }
        }
      
    }
}


#Preview {
    CircularImageView(imageName: "Single", size: 100)
}
