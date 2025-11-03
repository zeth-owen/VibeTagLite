//
//  AppTabViewModel.swift
//  VibeTagLite
//
//  Created by Zeth Thomas on 5/10/25.
//

import CloudKit
import SwiftUI

extension AppTabView {
    
    @MainActor final class AppTabViewModel: ObservableObject {
        @Published  var alertItem: AlertItem?
        @Published var isShowingOnboardView = false
        @AppStorage("hasSeenOnBoardView") private var hasSeenOnBoardView = false
        @Published var isLoading = false
      
        
        
        func checkIfHasSeenOnboard()  { if !hasSeenOnBoardView {  isShowingOnboardView = true
            hasSeenOnBoardView = true   } }
        
        func getLocations(for vibeManager: VibeManager) async {
            showLoadingView()
            Task {
                do {
                    vibeManager.locations = try await CloudKitManager.shared.getLocations()
                    hideLoadingView()
                } catch {
                    alertItem = AlertContext.unableToGetLocations
                    hideLoadingView()                }
            }
        }
        
        func getCompletedVibes(for userManager: UserManager) async {
            guard let profileReference = CloudKitManager.shared.profileRecordID else {
                self.alertItem = AlertContext.retrieveProfileFailure
                return
            }
            showLoadingView()
            Task {
                do {
                    let records = try await CloudKitManager.shared.getCompletedVibes(for: profileReference)
                    var progressMap: [CKRecord.ID: Date] = [:]
                    
                    for record in records {
                        if let vibeRef = record[UserVibeProgress.kVibeReference] as? CKRecord.Reference,
                           let createdAt = record[UserVibeProgress.kCreatedTimeStamp] as? Date {

                            if let existingDate = progressMap[vibeRef.recordID] {
                                if createdAt > existingDate {
                                    progressMap[vibeRef.recordID] = createdAt
                                }
                            } else {
                                progressMap[vibeRef.recordID] = createdAt
                            }
                        }
                    }
                    
                    DispatchQueue.main.async {
                        userManager.completedVibes = progressMap
                        userManager.cleanExpiredVibes()
                    }
                    hideLoadingView()
                } catch {
                    DispatchQueue.main.async {
                        self.alertItem = AlertContext.unableToGetCompletedVibes
                    }
                    hideLoadingView()
                }
            }
        }
        
 
        
        private func showLoadingView() { isLoading = true }
        private func hideLoadingView() { isLoading = false }
    }
}

