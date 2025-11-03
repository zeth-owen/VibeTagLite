//
//  AppTabView.swift
//  VibeTagLite
//
//  Created by Zeth Thomas on 5/5/25.
//

import SwiftUI

struct AppTabView: View {
    
    @StateObject private var viewModel = AppTabViewModel()
    @Environment(VibeManager.self) var vibeManager
    @Environment(UserManager.self) var userManager
    
    var body: some View {
        TabView {
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.circle.fill")
                }
            if viewModel.isLoading {
                LoadingView()
                    .tabItem {
                        Label("Map", systemImage: "map")
                    }
            } else {
                VibeMapView()
                    .tabItem {
                        Label("Map", systemImage: "map")
                    }
            }
            if viewModel.isLoading {
                LoadingView()
                    .tabItem {
                        Label("Vibe Menu", systemImage: "bolt.horizontal")
                    }
            } else {
                VibeListView()
                    .tabItem {
                        Label("Vibe Menu", systemImage: "bolt.horizontal")
                    }
            }
            
            ScannerView()
                .tabItem {
                    Label("Scanner", systemImage: "barcode.viewfinder")
                }
            if userManager.isBusinessOwner {
                Analytics()
                    .tabItem {
                        Label ("Analytics", systemImage: "chart.bar.fill")
                    }
            }
        }
        .onAppear {
            viewModel.checkIfHasSeenOnboard()
            if vibeManager.locations.isEmpty {
                viewModel.isLoading = true
                Task {
                    await viewModel.getLocations(for: vibeManager)
                    viewModel.isLoading = false
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .cloudKitSubscriptionReceived)) { notification in
            viewModel.alertItem = AlertContext.scanComplete
            Task {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                await viewModel.getCompletedVibes(for: userManager)
            }
        }
        
        .sheet (isPresented: $viewModel.isShowingOnboardView) {
            OnboardView()
        }
        .alert(item: $viewModel.alertItem, content: { $0.alert })
    }
}

#Preview {
    AppTabView().environment(VibeManager()).environment(UserManager())
}
