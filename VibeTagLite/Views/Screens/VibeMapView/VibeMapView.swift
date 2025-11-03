//
//  VibeMapView.swift
//  VibeTagLite
//
//  Created by Zeth Thomas on 5/5/25.
//

import CoreLocationUI
import MapKit
import SwiftUI

struct VibeMapView: View {
    
    @Environment(VibeManager.self) var vibeManager
    @State private var viewModel = VibeMapViewModel()
    @Environment(UserManager.self) var userManager
    @EnvironmentObject private var featuredPhotoManager: FeaturedPhotoManager
    
    var body: some View {
        ZStack(alignment: .top) {
            
            Map(position: $viewModel.cameraPosition) {
                ForEach(vibeManager.locations) { location in
                    Annotation("", coordinate: location.location.coordinate) {
                        VibeAnnotation(location: location)
                            .onTapGesture {
                                vibeManager.selectedVibeLocation = location
                                viewModel.isShowingDetailView = true
                            }
                    }
                }
             
                    UserAnnotation()
             
            }
            .tint(.green)
            
            
            LogoView(frameWidth: 125)
            
        }
        .sheet (isPresented: $viewModel.isShowingDetailView) {
            NavigationStack{
                VibeDetailView(viewModel: VibeDetailViewModel(location: vibeManager.selectedVibeLocation!, completedVibes: userManager.completedVibes))
                    .toolbar {
                            Button("Dismiss") { viewModel.isShowingDetailView = false }
                    }
            }
        }
        .overlay(alignment: .bottomLeading) {
            HStack {
                LocationButton(.currentLocation) {
                   viewModel.requestLocationPermission()
                }
                .foregroundColor(.white)
                .symbolVariant(.fill)
                .labelStyle(.iconOnly)
                .clipShape(Circle())
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 40, trailing: 0))
                
            }
            .tint(.brandPrimary)
        }
        .alert(item: $viewModel.alertItem, content: { $0.alert })
    }
}



#Preview {
    VibeMapView()
        .environment(VibeManager())
        .environment(UserManager())
        .environment(FeaturedPhotoManager())
    
}


