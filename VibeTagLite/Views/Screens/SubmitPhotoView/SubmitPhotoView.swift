//
//  SubmitPhotoView.swift
//  VibeTagLite
//
//  Created by Zeth Thomas on 5/8/25.
//

import CloudKit
import SwiftUI


struct SubmitPhotoView: View {
    
    @EnvironmentObject private var photoLocationManager: PhotoLocationManager
    @Environment(VibeManager.self) var vibeManager
    @StateObject var viewModel: SubmitPhotoViewModel
    @Environment(UserManager.self) var userManager 
   
    
    
    init(location: VibeLocation, userManager: UserManager) {
        _viewModel = StateObject(wrappedValue: SubmitPhotoViewModel(location: location, userManager: userManager))
    }
        
        var body: some View {
            ZStack {
                BackgroundLinearView()
                
                VStack {
                    Text("\(viewModel.location.name) Photo Vibes")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(.white.shadow(.drop(color: .black.opacity(0.8), radius: 3)))
                        .padding(.bottom)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                    
                    
                    
                    InstructionsView(locationName: viewModel.location.name)
                    
                    ZStack {
                        if let photos = photoLocationManager.photoSpots[viewModel.location.name] {
                            PhotoSpotsView(photos: photos)
                        }
                        if viewModel.isLoading {
                            photoLoadingView()
                        }
                    }
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .strokeBorder(Color.white.opacity(0.7), lineWidth: 4)
                            .background(RoundedRectangle(cornerRadius: 20).fill(Color.black.opacity(0.2)))
                            .shadow(color: .purple.opacity(0.4), radius: 6, x: 0, y: 4)
                            .frame(width: 200, height: 200)
                        
                        UploadImageView(viewModel: viewModel, image: viewModel.selectedImage, size: 180)
                            .onTapGesture { viewModel.userVerification() }
                        
                    }
                    .padding()
                    
                    
                    Button {
                        viewModel.userVerification()
                    } label: {
                        if viewModel.completionStatus == .incomplete {
                            Label("Upload a Screen Shot", systemImage: "photo")
                        } else {
                            Label("Complete", systemImage: "bolt")
                        }
                    }
                    .buttonStyle(UploadButtonStyle())
                    .disabled(viewModel.completionStatus == .complete)
                    
                    if let resetDate = viewModel.resetDate {
                        Text("This vibe resets on \(resetDate.formatted(date: .long, time: .complete))")
                            .font(.footnote)
                            .foregroundColor(.white)
                            .padding(.bottom, 8)
                    }
                    
                    if viewModel.selectedImage != nil {
                        Button("Submit", systemImage: "bolt.horizontal") {
                            viewModel.submitPhoto()
                            viewModel.selectedImage = viewModel.barcode
                        }
                        .frame(width: 300, height: 50)
                        .font(.headline)
                        .background(Color.brandPrimary.gradient)
                        .cornerRadius(10)
                        .foregroundColor(.white)
                    }
                    
                }
            }
            .onAppear {
                viewModel.getPhotoSpots(for: photoLocationManager)
                viewModel.updateResetDate()
                if viewModel.hasSubscribed { return }
                viewModel.subscribeToNotifications()
            
            }
            .onReceive(NotificationCenter.default.publisher(for: .cloudKitSubscriptionReceived)) { notification in
                viewModel.alertItem = AlertContext.scanComplete
                Task {
                    try? await Task.sleep(nanoseconds: 1_000_000_000)
                           await viewModel.getCompletedVibes(for: userManager)
                  }
            }
            .onChange(of: userManager.completedVibes) {
                viewModel.updateResetDate()
            }
        
            .sheet(isPresented: $viewModel.isShowingPhotoPicker) {
                PhotoPicker(image: $viewModel.selectedImage)
            }
            .disabled(viewModel.completionStatus == .complete)
            .alert(item: $viewModel.alertItem, content: { $0.alert })
        }
    }
    
    //#Preview {
    //    let mockLocation = VibeLocation(record: MockData.location)
    //    SubmitPhotoView(location: mockLocation).environmentObject(PhotoLocationManager())
    //}
    
    
    fileprivate struct BackgroundLinearView: View {
        var body: some View {
            LinearGradient(
                gradient: Gradient(colors: [Color.white, Color.purple]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.top)
        }
    }
    
    fileprivate struct InstructionsView: View {
        
        let locationName: String
        
        var body: some View {
            Text("Upload a screenshot at one of these vibes. Use \(locationName) as the location & @vibetag_us to unlock your QR.")
                .font(.headline)
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemBackground).opacity(0.6))
                        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 6)
                )
                .padding()
        }
        
    }
    
    
    fileprivate struct PhotoSpotsView: View {
        
        let photos: [VibePhoto]
        
        var body: some View {
            HStack(spacing: 16) {
                ForEach(photos) { photo in
                    VStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(.systemBackground).opacity(0.6))
                                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 6)
                            
                            VStack {
                                Image(uiImage: photo.squareImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                
                                Text(photo.location)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                        }
                    }
                    .frame(width: 120, height: 120)
                }
            }
            .padding()
        }
    }
    
    fileprivate struct UploadButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .padding()
                .frame(width: 280, height: 40)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .strokeBorder(Color.white.opacity(0.7), lineWidth: 2)
                        .background(RoundedRectangle(cornerRadius: 25).fill(Color.black.opacity(0.2)))
                        .shadow(color: .purple.opacity(0.4), radius: 6, x: 0, y: 4)
                )
                .foregroundStyle(.white.shadow(.drop(color: .black.opacity(0.2), radius: 3)))
            
        }
    }
    
    
    
    fileprivate struct photoLoadingView: View {
        
        var body: some View {
            ZStack {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .brandPrimary))
                    .scaleEffect(2)
                    .offset(y: -40)
            }
        }
    }
    
    fileprivate struct UploadImageView: View {
        
        @StateObject var viewModel: SubmitPhotoViewModel
        
        var image: UIImage?
        var size: CGFloat
        
        var body: some View {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: size, height: size)
                
            } else if viewModel.completionStatus == .incomplete {
                Image(systemName: "photo.badge.plus")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.white.shadow(.drop(color: .black.opacity(0.2), radius: 3)))
                    .opacity(0.75)
                    .frame(width: size, height: size)
                    .offset(x: 10)
            } else {
                Image(systemName: "bolt.badge.checkmark.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.white.shadow(.drop(color: .black.opacity(0.2), radius: 3)))
                    .opacity(0.75)
                    .frame(width: size, height: size)
                    .offset(x: 10)
            }
            
        }
    }

