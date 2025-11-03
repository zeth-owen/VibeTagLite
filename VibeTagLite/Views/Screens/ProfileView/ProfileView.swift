//
//  ProfileView.swift
//  VibeTagLite
//
//  Created by Zeth Thomas on 5/5/25.
//

import CloudKit
import AuthenticationServices

import SwiftUI

struct ProfileView: View {
    
    @Environment(UserManager.self) var userManager
    @State private var viewModel = ProfileViewModel()
    
    @State private var isFetchingRecord = true
    
    
    
    var body: some View {
        
        if viewModel.isShowingProfileCompletionView {
            ProfileCompletionView(viewModel: viewModel)
        } else {
            ZStack{
                BackgroundGradientView()
                    .edgesIgnoringSafeArea(.top)
                
                GeometryReader { geo in
                    VStack  {
                        
                        TopLogoView(title: "VibeTag")
                            .stackStyle()
                            .padding(.bottom)
                        
                        Spacer()
                        
                        CircularImageView(imageName: "GNC-69", size: geo.size.width * 0.70)
                        
                        Spacer()
                        
                        Text("What's your Vibe?")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        
                     
                            SignInWithAppleButton(
                                .continue,
                                onRequest: { request in
                                    request.requestedScopes = [.fullName]
                                },
                                onCompletion: viewModel.handleSignInWithApple
                            )
                            .signInWithAppleButtonStyle(.black)
                            .frame(width: geo.size.width * 0.75, height: 50)
                            .disabled(isFetchingRecord)
                            .opacity(isFetchingRecord ? 0.5 : 1)
                            
                        Spacer()
                    }
                    .frame(width: geo.size.width, height: geo.size.height)
                }
            }
            .task {
                try? await CloudKitManager.shared.getUserRecord()
                isFetchingRecord = false
                if CloudKitManager.shared.userRecord != nil {
                    viewModel.getProfile(for: userManager)
                }
            }
            .alert(item: $viewModel.alertItem, content: { $0.alert })
        }
    }
}

#Preview {
    ProfileView()
}





