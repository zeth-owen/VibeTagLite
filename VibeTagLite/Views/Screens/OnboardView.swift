//
//  OnboardView.swift
//  VibeTagLite
//
//  Created by Zeth Thomas on 5/8/25.
//

import SwiftUI

struct OnboardView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack() {
            HStack{
                Spacer()
                
                Button{
                   dismiss()
                } label: {
                  XDismissButton()
                }
                .padding()
            }
            
            Spacer()
            
            LogoView(frameWidth: 250)

            VStack(alignment: .leading, spacing: 32) {
                
                OnboardInfoView(imageName: "bolt.horizontal.circle", title: "Club Locations", description: "Find your vibe and explore the best of Vegas nightlife.")
                
                OnboardInfoView(imageName: "camera.circle", title: "Photo Spots", description: "Snap Instagram-worthy pics at the hottest club locations & get featured on our app.")
                
                OnboardInfoView(imageName: "checkmark.circle", title: "Completion Tracker", description: "Track your progress as you discover the clubs that match your vibe")
            }
            .padding(.horizontal, 30)
            Spacer()
                .frame(height: 150)
        }
    }
}

#Preview {
    OnboardView()
}

fileprivate struct OnboardInfoView: View {
    
    var imageName: String
    var title: String
    var description: String
    
    var body: some View {
        HStack(spacing: 26) {
            Image(systemName: imageName )
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundColor(.brandPrimary)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title).bold()
                Text(description)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.75)
            }
        }
    }
}
