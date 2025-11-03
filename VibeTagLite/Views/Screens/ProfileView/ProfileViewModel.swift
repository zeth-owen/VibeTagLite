//
//  ProfileViewModel.swift
//  VibeTagLite
//
//  Created by Zeth Thomas on 5/8/25.
//

import _AuthenticationServices_SwiftUI
import CloudKit



@MainActor @Observable
final class ProfileViewModel {
    
    var isLoading = false
    var isShowingProfileCompletionView = false
    var alertItem: AlertItem?
    var firstName: String = "to"
    var lastName: String = "VibeTag"
    var completionPercentageStatus: String = "0%"
    
    
    @ObservationIgnored  private var existingProfileRecord: CKRecord?
    
    
    
    func handleSignInWithApple(result: (Result<ASAuthorization, Error>)) {
        switch result {
        case .success(let authResults):
            if let appleUserID = authResults.credential as? ASAuthorizationAppleIDCredential {
                let firstName = appleUserID.fullName?.givenName ?? self.firstName
                let lastName = appleUserID.fullName?.familyName ?? self.lastName
                
                
                DispatchQueue.main.async {
                    guard let userRecord = CloudKitManager.shared.userRecord else {
                        self.alertItem = AlertContext.noUserRecord
                        return
                    }
                    if let _ = userRecord["userProfile"] as? CKRecord.Reference {
                        self.isShowingProfileCompletionView = true
                    } else {
                        self.createProfile(firstName: firstName, lastName: lastName)
                    }
                }
            }
        case .failure(_):
            DispatchQueue.main.async {
                self.alertItem = AlertContext.signInWithAppleFailed
            }
        }
    }
    
    
    
    func createProfile(firstName: String, lastName: String)  {
        guard let userRecord = CloudKitManager.shared.userRecord else {
            alertItem = AlertContext.noUserRecord
            return
        }
        let profileRecord = createProfileRecord(firstName: firstName, lastName: lastName)
  
        userRecord["userProfile"] = CKRecord.Reference(recordID: profileRecord.recordID, action: .none)
        showLoadingView()
        
        Task {
            do {
                let records = try await CloudKitManager.shared.batchSave(records: [userRecord, profileRecord])
                for record in records where record.recordType == RecordType.profile {
                    existingProfileRecord = record
                    CloudKitManager.shared.profileRecordID = record.recordID
                    self.firstName = firstName
                    self.lastName = lastName
                }
                isShowingProfileCompletionView = true
                hideLoadingView()
            } catch {
                hideLoadingView()
                alertItem = AlertContext.createProfileFailure
            }
        }
    }
    
    
    
    func getProfile(for userManager: UserManager) {
        guard let userRecord = CloudKitManager.shared.userRecord else {
            self.alertItem = AlertContext.noUserRecord
            return
        }
        
        guard let profileReference = userRecord["userProfile"] as? CKRecord.Reference else {
            return
        }
        
        let profileRecordID = profileReference.recordID
        showLoadingView()
        
        Task {
            do {
                let record = try await CloudKitManager.shared.fetchRecord(with: profileRecordID)
                existingProfileRecord = record
                let profile = VibeProfile(record: record)
                firstName = profile.firstName
                lastName = profile.lastName
                userManager.firstName = profile.firstName
                userManager.lastName = profile.lastName
                
                if let businesses = record[VibeProfile.kBusiness] as? [CKRecord.Reference],
                          !businesses.isEmpty {
                           userManager.isBusinessOwner = true
                       } else {
                           userManager.isBusinessOwner = false
                       }
                hideLoadingView()
            } catch {
                hideLoadingView()
                alertItem = AlertContext.unableToGetProfile
            }
        }
    }
    
    private func createProfileRecord(firstName: String, lastName: String) -> CKRecord {
        let profile = CKRecord(recordType: RecordType.profile)
        profile["firstName"] = firstName
        profile["lastName"] = lastName
        return profile
    }
    
    func getCompletedVibes(for userManager: UserManager) {
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



