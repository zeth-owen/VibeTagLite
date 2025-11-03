//
//  VibeAnnotation.swift
//  VibeTagLite
//
//  Created by Zeth Thomas on 5/10/25.
//

import SwiftUI

struct VibeAnnotation: View {
    
    var location: VibeLocation
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .fill(Color.brandPrimary.gradient)
                    .frame(width: 40, height: 40)
                
                Image(uiImage: location.squareImage)
                    .resizable()
                    .frame(width: 30, height: 30)
                    .clipShape(Circle())
            }
            
            Text(location.name)
                .font(.caption)
                .fontWeight(.semibold)
        }
        .accessibilityLabel(Text("Map Pin \(location.name)"))
    }
}

#Preview {
    VibeAnnotation(location: VibeLocation(record: MockData.location))
}
