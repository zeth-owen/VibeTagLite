//
//  ScannerView.swift
//  VibeTagLite
//
//  Created by Zeth Thomas on 5/5/25.
//

import CodeScanner
import SwiftUI
import CloudKit

struct ScannerView: View {
    
    @Environment(UserManager.self) var userManager
    @State private var showBanner = false
    @State private var bannerMessage = ""
    @State private var bannerColor: Color = .green
    var alertItem: AlertItem?
    
    var body: some View {
        ZStack {
            CodeScannerView(codeTypes: [.qr], completion: handleScan)
            
            if showBanner {
                VStack {
                    Text(bannerMessage)
                        .foregroundColor(.white)
                        .padding()
                        .background(bannerColor)
                        .cornerRadius(10)
                        .padding()
                    
                    Spacer()
                }
                .transition(.move(edge: .top))
                .animation(.easeInOut, value: showBanner)
            }
            
            
        }
        
    }
    func handleScan(result: Result<ScanResult, ScanError>) {
        switch result {
        case .success(let result):
            let scannedString = result.string
            
            if let data = scannedString.data(using: .utf8),
               let json = try? JSONSerialization.jsonObject(with: data, options: []),
               let dict = json as? [String: String],
               let profileRecordIDString = dict["profileRecordID"],
               let vibeLocationIDString = dict["vibeLocationID"] {
                
                let profileRecordID = CKRecord.ID(recordName: profileRecordIDString)
                let vibeLocationID = CKRecord.ID(recordName: vibeLocationIDString)
                
                Task {
                    do {
                        let userReference = CKRecord.Reference(recordID: profileRecordID, action: .none)
                        let vibeReference = CKRecord.Reference(recordID: vibeLocationID, action: .none)

                        let predicate = NSPredicate(format: "userReference == %@ AND vibeReference == %@", userReference, vibeReference)
                        let query = CKQuery(recordType: "UserVibeProgress", predicate: predicate)
                        let (results, _) = try await CloudKitManager.shared.container.publicCloudDatabase.records(matching: query)

                    
                        let scanDates = results.compactMap { (_, result) -> Date? in
                            if let record = try? result.get(),
                               let createdAt = record[UserVibeProgress.kCreatedTimeStamp] as? Date {
                                return createdAt
                            }
                            return nil
                        }

                        if let latestScan = scanDates.max() {
                            let cutoff = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
                            if latestScan > cutoff {
                                showBannerMessage("You can only scan this vibe once every 7 days.", color: .orange)
                                return
                            }
                        }

                        let progressRecord = CKRecord(recordType: "UserVibeProgress")
                        progressRecord[UserVibeProgress.kUserReference] = userReference
                        progressRecord[UserVibeProgress.kVibeReference] = vibeReference
                        progressRecord[UserVibeProgress.kCreatedTimeStamp] = Date()

                        _ = try await CloudKitManager.shared.save(record: progressRecord)
                        showBannerMessage("Scanned successfully!", color: .green)

                    } catch {
                        showBannerMessage("Failed to save progress.", color: .red)
                    }
                }
                
            } else {
                showBannerMessage("Invalid QR code format.", color: .red)
            }
            
        case .failure:
            showBannerMessage("Scan failed. Please try again.", color: .red)
        }
    }
    
    func hasScannedVibe(vibeID: CKRecord.ID, userProfileID: CKRecord.ID) async throws -> Bool {
        let vibeRef = CKRecord.Reference(recordID: vibeID, action: .none)
        let userRef = CKRecord.Reference(recordID: userProfileID, action: .none)
        
        let predicate = NSPredicate(format: "vibeReference == %@ AND userReference == %@", vibeRef, userRef)
        let query = CKQuery(recordType: "UserVibeProgress", predicate: predicate)
        
        let (results, _) = try await CKContainer.default().publicCloudDatabase.records(matching: query)
        return !results.isEmpty
    }
    
    
    
    func showBannerMessage(_ message: String, color: Color) {
        bannerMessage = message
        bannerColor = color
        showBanner = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation {
                showBanner = false
            }
        }
    }
}

#Preview {
    ScannerView()
}
