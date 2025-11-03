//
//  SubmitPhotoViewModel.swift
//  VibeTagLite
//
//  Created by Zeth Thomas on 5/8/25.
//


import CloudKit
import SwiftUI
import UIKit
import Vision

@MainActor final class SubmitPhotoViewModel: ObservableObject {
    
    
    var location: VibeLocation
    @Published var isLoading = false
    @Published var isShowingPhotoPicker = false
    @Published var alertItem: AlertItem?
    @Published var selectedImage: UIImage?
    @Published var barcode: UIImage?
    @Published var resetDate: Date?
    @AppStorage("hasSubscribed") var hasSubscribed = false
    private let userManager: UserManager
    
    
    private let barcodeGenerator = BarcodeGenerator()
    
    
    init(location: VibeLocation, userManager: UserManager) {
        self.location = location
        self.userManager = userManager
        
    }
    
    func getPhotoSpots(for photoLocationManager: PhotoLocationManager) {
        if let existingPhotos = photoLocationManager.photoSpots[location.name], !existingPhotos.isEmpty {
            return
        }
        showLoadingView()
        Task {
            do {
                photoLocationManager.photoSpots[location.name] = try await CloudKitManager.shared.getPhotoSpots(for: location.id)
                hideLoadingView()
            } catch {
                alertItem = AlertContext.unableToGetPhotoSpots
                hideLoadingView()
            }
        }
    }
    
    func userVerification() {
        guard CloudKitManager.shared.profileRecordID != nil else {
            alertItem = AlertContext.logInRequired
            return
        }
        isShowingPhotoPicker = true
    }
    
    func extractText(from image: UIImage, completion: @escaping (String?) -> Void) {
        guard let cgImage = image.cgImage else {
            completion(nil)
            return
        }
        
        let request = VNRecognizeTextRequest { request, error in
            if error != nil {
                completion(nil)
                return
            }
            
            var extractedText = ""
            
            for observation in request.results as? [VNRecognizedTextObservation] ?? [] {
                if let topCandidate = observation.topCandidates(1).first {
                    extractedText += topCandidate.string
                }
            }
            completion(extractedText)
        }
        
        let requests: [VNRequest] = [request]
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        do {
            try handler.perform(requests)
        } catch {
            completion(nil)
        }
    }
    
    func submitPhoto() {
        guard let selectedImage else { return }
        
        extractText(from: selectedImage) { [self] text in
            guard let text else { return }
            let cleanedText = text.lowercased()
            
            let containsBarName = cleanedText.contains(location.name.lowercased())
            let containsHashtag = cleanedText.contains("@vibetag")
            
            switch (containsBarName, containsHashtag) {
            case (false, _):
                alertItem = AlertContext.missingBarName
                
            case (true, false):
                alertItem = AlertContext.missingHashTag
                
            case (true, true):
                alertItem = AlertContext.success
                
                guard let profileRecordID = CloudKitManager.shared.profileRecordID else { return }
                
                
                barcode = barcodeGenerator.generateBarcode(
                    vibeLocationID: location.id,
                    profileRecordID: profileRecordID
                )
            }
        }
    }
    
    var completionStatus: CompletionStatus {
        guard let completedDate = userManager.completedVibes[location.id] else {
            return .incomplete
        }
        let expirationDate = Calendar.current.date(byAdding: .day, value: 7, to: completedDate)!
        return expirationDate > Date() ? .complete : .incomplete
    }
    

    
    
    
    func subscribeToNotifications() {
        guard let profileID = CloudKitManager.shared.profileRecordID else {
            self.alertItem = AlertContext.loginRequired
            return
        }
        guard hasSubscribed == false else {
            return
        }
        
        
        let userReference = CKRecord.Reference(recordID: profileID, action: .none)
        let predicate = NSPredicate(format: "userReference == %@", userReference)
        let subscription = CKQuerySubscription(recordType: "UserVibeProgress", predicate: predicate , subscriptionID: "QR_Codes_Scanned_\(profileID.recordName)", options: .firesOnRecordCreation)
        let info = CKSubscription.NotificationInfo()
        info.shouldSendContentAvailable = true
        subscription.notificationInfo = info
        
        
        CKContainer.default().publicCloudDatabase.save(subscription) { returnedSubscription, returnedError in
            if returnedError != nil {
            } else {
                DispatchQueue.main.async {
                            self.hasSubscribed = true
                            UIApplication.shared.registerForRemoteNotifications()
                        }
            }
        }
    }
    
    func updateResetDate() {
        if let completedDate = userManager.completedVibes[location.id] {
            let resetThreshold = Calendar.current.date(byAdding: .day, value: 7, to: completedDate)!
            if resetThreshold > Date() {
                self.resetDate = resetThreshold
            } else {
                self.resetDate = nil
            }
        } else {
            self.resetDate = nil
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


