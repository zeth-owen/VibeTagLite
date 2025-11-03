//
//  ProfileCompletionView.swift
//  VibeTagLite
//
//  Created by Zeth Thomas on 5/8/25.
//

import SwiftUI

struct ProfileCompletionView: View {
    
    @Bindable var viewModel: ProfileViewModel
    @Environment(VibeManager.self) var vibeManager
    @Environment(UserManager.self) var userManager
    
    
    
    var body: some View {
        @Bindable var vibeManager = vibeManager
        
        VStack() {
            SCurveHeader(title: "VibeCompletion")
                .frame(height: 125)
            
            Text(" Welcome \(viewModel.firstName) \(viewModel.lastName)!")
                .font(.title2)
                .fontWeight(.semibold)
            
            
            List {
                ForEach(vibeManager.groupedLocations.keys.sorted(), id: \.self) { category in
                    Section(header:
                                HStack {
                        Text(category)
                        
                        Spacer()
                        
                        Text(completionPercentageStatus(for: category))
                    }
                    )   {
                        ForEach(vibeManager.groupedLocations[category] ?? [], id: \.id) { category in
                            HStack {
                                Text(category.name)
                                    .foregroundStyle(.secondary)
                                Spacer()
                                if userManager.completedVibes[category.id] != nil {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                }
                            }
                        }
                    }
                }
             
            }
            Button("Delete Account") {
                // Delete action here
            }
            .frame(width: 120, height: 20)
            .padding()
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(8)
            .padding()
        }
        .onAppear {
            viewModel.getCompletedVibes(for: userManager)
        }
        .refreshable { viewModel.getCompletedVibes(for: userManager) }
        .alert(item: $viewModel.alertItem, content: { $0.alert })
    }
    
    
    func completionPercentageStatus(for category: String) -> String {
        guard let locationsInCategory = vibeManager.groupedLocations[category] else {
            return "0% completed"
        }
        
        let total = locationsInCategory.count
        let completed = locationsInCategory.filter { userManager.completedVibes[$0.id] != nil }.count
        
        guard total > 0 else { return "0% completed" }
        
        let percentage = (Double(completed) / Double(total)) * 100
        return String(format: "%.0f%% completed", percentage)
    }
    
}


#Preview {
    ProfileCompletionView(viewModel: ProfileViewModel())
        .environment(VibeManager())
        .environment(UserManager())
}

