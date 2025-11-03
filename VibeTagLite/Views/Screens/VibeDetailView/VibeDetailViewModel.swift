//
//  VibeDetailViewModel.swift
//  VibeTagLite
//
//  Created by Zeth Thomas on 5/9/25.
//

import Observation
import CloudKit
import MapKit
import SwiftUI

enum CompletionStatus {
    case complete, incomplete
}

@MainActor @Observable
final class VibeDetailViewModel {
    
    var isLoading = false
    var alertItem: AlertItem?
    
    
    var location: VibeLocation
    var completedVibes: [CKRecord.ID: Date]
    var completionStatusText: String { completionStatus == .complete ? "Complete" : "Incomplete" }
    var buttonColor: Color { completionStatus == .complete ? .green : .red }
    var imageName: String { completionStatus == .complete ? "person.fill.checkmark" : "person.fill.xmark" }
    var isShowingFeaturedPhoto = false
    var selectedFeaturedPhoto: FeaturedPhoto? = nil
    
    
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    
    
    init(location: VibeLocation, completedVibes: [CKRecord.ID: Date]) {
        self.location = location
        self.completedVibes = completedVibes
    }
    
    
    func getDirectionsToLocation() {
        let placemark = MKPlacemark(coordinate: location.location.coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = location.name
        
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
        
    }
    
    func callLocation() {
        guard let url = URL(string: "tel://\(location.phoneNumber)") else {
            alertItem = AlertContext.invalidPhoneNumber
            return
        }
        UIApplication.shared.canOpenURL(url)
        UIApplication.shared.open(url)
    }
    
    
    func getFeaturedPhotos(for featuredPhotoManager: FeaturedPhotoManager) {
        if let existingPhotos = featuredPhotoManager.featuredPhoto[location.name], !existingPhotos.isEmpty { return }
        
        showLoadingView()
        
        Task {
            do {
                featuredPhotoManager.featuredPhoto[location.name] = try await CloudKitManager.shared.getFeaturedPhotos(for: location.id)
                hideLoadingView()
            } catch {
                alertItem = AlertContext.unableToGetPhotoSpots
                hideLoadingView()
            }
        }
    }
    
    var completionStatus: CompletionStatus {
        completedVibes[location.id] != nil ? .complete : .incomplete
    }
    
    private func showLoadingView() { isLoading = true }
    private func hideLoadingView() { isLoading = false }
    
}


