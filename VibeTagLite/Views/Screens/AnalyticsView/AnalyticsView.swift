//
//  Analytics.swift
//  VibeTagLite
//
//  Created by Zeth Thomas on 6/27/25.
//

import SwiftUI


struct Analytics: View {
    
    @Environment(VibeManager.self) var vibeManager
    @StateObject private var viewModel = AnalyticsViewModel()
    @Environment(UserManager.self) var userManager
    
    
    var body: some View {
        ZStack {
            VStack {
                Text("\(userManager.firstName) \(userManager.lastName) Analytics ")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding()
                    List {
                        ForEach(viewModel.businesses) { business in
                            VStack {
                                HStack(spacing: 15) {
                                    Text(business.name)
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .frame(width: 100, alignment: .leading)
                                    VStack {
                                        Text("24 Hour")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                        Text("\(viewModel.scanCountsByBusiness[business.id]?[.daily] ?? 0)")
                                            .font(.caption)
                                    }
                                    VStack {
                                        Text("Weekly")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                        Text("\(viewModel.scanCountsByBusiness[business.id]?[.weekly] ?? 0)")
                                            .font(.caption)
                                    }
                                    VStack {
                                        Text("Monthly")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                        Text("\(viewModel.scanCountsByBusiness[business.id]?[.monthly] ?? 0)")
                                            .font(.caption)
                                    }
                                    VStack {
                                        Text("Total")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                        Text("\(viewModel.scanCountsByBusiness[business.id]?[.total] ?? 0)")
                                            .font(.caption)
                                    }
                                }
                            }
                        }
                    }
                }
            
            if viewModel.isLoading {
                LoadingView()
            }
        }
        
        .task {
            viewModel.locations = vibeManager.locations
            viewModel.displayBusinesses()
        }
        .refreshable {
            viewModel.displayBusinesses()
        }
    }
}

#Preview {
    Analytics().environment(VibeManager())
}
