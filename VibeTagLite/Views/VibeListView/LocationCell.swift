//
//  LocationCell.swift
//  VibeTagLite
//
//  Created by Zeth Thomas on 5/7/25.
//

import SwiftUI

struct LocationCell: View {
    
    var location: VibeLocation
    
    var body: some View {
      
            VStack(spacing: 12) {
                HStack {
                    VStack {
                        Text(location.name)
                            .font(.title2)
                            .fontWeight(.bold)
                            .lineLimit(1)
                            .foregroundStyle(.black)
                            .minimumScaleFactor(0.75)
                        
                        Image(uiImage: location.squareImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .clipped()
                            .cornerRadius(12)
                        
                        Text(location.description)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                        .font(.headline)
           
                }
           
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
            )
            .padding(.vertical, 8)
            
       

 
    }
}


#Preview {
    LocationCell(location: VibeLocation(record: MockData.location))
}
