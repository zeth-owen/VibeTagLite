//
//  VibeListView.swift
//  VibeTagLite
//
//  Created by Zeth Thomas on 5/5/25.
//

import SwiftUI

struct VibeListView: View {
    @Environment(VibeManager.self) var vibeManager
    @Environment(UserManager.self) var userManager
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                
                SCurveHeader(title: "VibeMenu")
                    .frame(height: 125)
                
                ScrollView {
                    VStack(spacing: 16) {
                        
                        ForEach(vibeManager.locations) { location in
                            NavigationLink(value: location) {
                                LocationCell(location: location)
                                    .padding(.horizontal)
                            }
                        }
                    }
                }
            }
            .navigationDestination(for: VibeLocation.self, destination:  { location in
                VibeDetailView(viewModel: VibeDetailViewModel(location: location, completedVibes: userManager.completedVibes))
            })
        }
    }
}



#Preview {
    VibeListView().environment(VibeManager())
}


