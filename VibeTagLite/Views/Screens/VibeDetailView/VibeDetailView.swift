//
//  VibeDetailView.swift
//  VibeTagLite
//
//  Created by Zeth Thomas on 5/5/25.
//

import SwiftUI

struct VibeDetailView: View {
    
    @Environment(VibeManager.self) var vibeManager
    @Bindable var viewModel: VibeDetailViewModel
    @Environment(UserManager.self) var userManager
    @EnvironmentObject private var featuredPhotoManager: FeaturedPhotoManager
    
    var body: some View {
        ZStack {
            VStack(spacing: 2) {
                BannerImageView(image: viewModel.location.bannerImage)
                
                LabelHStackView(address: viewModel.location.address, viewModel: viewModel)
                
                DescriptionView(text: viewModel.location.description)
                
                HStack{
                    Text("Completion Status:")
                        .fontWeight(.bold)
                    
                    Text(viewModel.completionStatusText)
                }
                
                ActionButtonsView(viewModel: viewModel)
                
                
                Text("Feel the vibe")
                    .bold()
                    .font(.title2)
                
                Text("Featured Photos")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                ZStack {
                    if let photos = featuredPhotoManager.featuredPhoto[viewModel.location.name] {
                        ScrollView {
                            LazyVGrid(columns: viewModel.columns) {
                                ForEach(photos) { photo in
                                    FeaturePhotoView(igHandle: photo.igHandle, size: 100, featuredImage: photo.createSquareImage())
                                        .onTapGesture {
                                            viewModel.isShowingFeaturedPhoto = true
                                            viewModel.selectedFeaturedPhoto = photo
                                        }
                                }
                            }
                        }
                    }
                    if viewModel.isLoading {
                        LoadingView()
                    }
                }
            }
            if viewModel.isShowingFeaturedPhoto, let selected = viewModel.selectedFeaturedPhoto {
                withAnimation(.easeOut) {
                    Color(.systemBackground)
                        .ignoresSafeArea()
                        .opacity(0.9)
                        .transition(AnyTransition.opacity.animation(.easeOut(duration: 0.35)))
                        .zIndex(1)
                }
              
                withAnimation(.easeOut) {
                    PhotoModalView(isShowingFeaturedPhoto: $viewModel.isShowingFeaturedPhoto, featuredPhoto: selected)
                        .transition(.opacity.combined(with: .slide))
                        .zIndex(2)
                }
             
            }
        }
 
        .onAppear {
            viewModel.getFeaturedPhotos(for: featuredPhotoManager)
            
        }
        .alert(item: $viewModel.alertItem, content: { $0.alert })
        .navigationTitle(viewModel.location.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        VibeDetailView(viewModel: VibeDetailViewModel(location: VibeLocation(record: MockData.location), completedVibes: [:]))
            .environmentObject(FeaturedPhotoManager())
            .environment(UserManager())
            .environment(VibeManager())
    }
}


fileprivate struct LocationActionButton: View {
    
    var color: Color
    var imageName: String
    
    var body: some View {
        ZStack {
            Circle()
                .fill(color.gradient.shadow(.drop(color: .black.opacity(0.2), radius: 3)))
                .frame(width: 60, height: 60)
            
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .foregroundColor(.white)
                .frame(width: 22, height: 22)
        }
    }
}

fileprivate struct BannerImageView: View {
    
    var image: UIImage
    
    var body: some View {
        Image(uiImage: image  )
            .resizable()
            .scaledToFill()
            .frame(height: 120)
            .accessibilityHidden(true)
    }
}

fileprivate struct LabelHStackView: View {
    
    var address: String
    var viewModel: VibeDetailViewModel
    @Environment(UserManager.self) var userManager
    
    var body: some View {
        HStack {
            Label(address, systemImage: "mappin.and.ellipse")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.horizontal, 8)
            
            Spacer()
            
            NavigationLink(destination: SubmitPhotoView(location: viewModel.location, userManager: userManager)) {
                HStack {
                    Text("Photo Spots")
                        .font(.caption)
                        .bold()
                        .foregroundStyle(.white.shadow(.drop(color: .black.opacity(0.2), radius: 3)))
                    
                    
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundStyle(.white.shadow(.drop(color: .black.opacity(0.2), radius: 3)))
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(.brandPrimary.gradient.shadow(.drop(color: .black.opacity(0.2), radius: 3)))
                .cornerRadius(8)
                
            }
            .padding(.horizontal, 8)
            .padding(.top, 5)
        }
        
    }
}

fileprivate struct DescriptionView: View {
    
    var text: String
    
    var body: some View {
        
        Text(text)
            .lineLimit(3)
            .minimumScaleFactor(0.75)
            .frame(height: 80)
            .padding(.horizontal)
    }
}

fileprivate struct ActionButtonsView: View {
    
    @Bindable var viewModel: VibeDetailViewModel
    
    var body: some View {
        HStack(spacing: 20) {
            Button {
                viewModel.getDirectionsToLocation()
            } label: {
                LocationActionButton(color: .brandPrimary, imageName: "location.fill")
                    .accessibilityLabel(Text("Get directions"))
            }
            Link(destination: URL(string: viewModel.location.websiteURL)!, label: {
                LocationActionButton(color: .brandPrimary, imageName: "network")
                    .accessibilityLabel(Text("Go to website"))
            })
            Button {
                viewModel.callLocation()
            } label: {
                LocationActionButton(color: .brandPrimary, imageName: "phone.fill")
                    .accessibilityLabel(Text("Call location"))
            }
            
            LocationActionButton(color: viewModel.buttonColor, imageName: viewModel.imageName)
                .accessibilityLabel(Text("Completion status: \(viewModel.completionStatusText)"))
            
        }
        .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
        .background(Color(.secondarySystemBackground))
        .clipShape(Capsule())
    }
}

