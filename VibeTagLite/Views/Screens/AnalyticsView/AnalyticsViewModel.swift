//
//  AnalyticsViewModel.swift
//  VibeTagLite
//
//  Created by Zeth Thomas on 6/27/25.
//

import CloudKit
import Foundation

enum ScanIncrement {
    case daily, weekly, monthly, total
}

@MainActor
final class AnalyticsViewModel: ObservableObject {
    
    @Published var scanCount: Int = 0
    @Published var alertItem: AlertItem?
    var locations: [VibeLocation] = []
    @Published var businesses: [VibeLocation] = []
    @Published var isLoading = false
    @Published var scanCountsByBusiness: [CKRecord.ID: [ScanIncrement: Int]] = [:]
    
    func displayBusinesses() {
        guard let profileRecordID = CloudKitManager.shared.profileRecordID else {
            self.alertItem = AlertContext.retrieveProfileFailure
            return
        }
        
        showLoadingView()
        
        Task {
            do {
                let record = try await CloudKitManager.shared.fetchRecord(with: profileRecordID)
                if let businessReferences = record[VibeProfile.kBusiness] as? [CKRecord.Reference] {
                    let businessIDs = businessReferences.map { $0.recordID }
                    let matchedBusinesses = locations.filter { businessIDs.contains($0.id) }
                    self.businesses = matchedBusinesses
                    self.scanCountsByBusiness = [:] 
                    await self.getCount(for: matchedBusinesses.map { $0.id })
                
                    hideLoadingView()
                }
            } catch {
                self.alertItem = AlertContext.unableToGetProfile
                hideLoadingView()
            }
        }
    }
    
   
    func getCount(for businessIDs: [CKRecord.ID]) async {
        let increments: [ScanIncrement] = [.daily, .weekly, .monthly, .total]
        
        for id in businessIDs {
            
            var counts: [ScanIncrement: Int] = [:]
    
            
            for increment in increments {
                do {
                    let count = try await CloudKitManager.shared.getBusinessLogCount(for: id, increment: increment)
                    counts[increment] = count
                } catch {
                    counts[increment] = 0
                }
            }
            
            self.scanCountsByBusiness[id] = counts
        }
    }

    
    private func showLoadingView() { isLoading = true }
    private func hideLoadingView() { isLoading = false }
}
