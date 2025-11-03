//
//  VibeMapViewModel.swift
//  VibeTagLite
//
//  Created by Zeth Thomas on 5/7/25.
//

import CoreLocation
import MapKit
import SwiftUI


@Observable
final class VibeMapViewModel: NSObject, CLLocationManagerDelegate {
    
    var isLoading = false
    var isShowingDetailView = false
    var alertItem: AlertItem?
    
    
    var cameraPosition: MapCameraPosition = .automatic
    
    let deviceLocationManager = CLLocationManager()
    
    override init() {
        super.init()
        deviceLocationManager.delegate = self
       
    }
    
    
    func requestLocationPermission() {
            switch deviceLocationManager.authorizationStatus {
            case .notDetermined:
                DispatchQueue.main.async { self.deviceLocationManager.requestWhenInUseAuthorization() }
            case .authorizedWhenInUse, .authorizedAlways:
                deviceLocationManager.requestLocation()
            case .denied, .restricted:
                DispatchQueue.main.async { self.deviceLocationManager.requestWhenInUseAuthorization() }
            @unknown default: break
            }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()
        case .denied, .restricted:
            alertItem = AlertContext.locationDenied
        case .notDetermined: break
        @unknown default: break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else { return }
            withAnimation {
                cameraPosition = .region(
                    .init(center: currentLocation.coordinate,
                          latitudinalMeters: 1200,
                          longitudinalMeters: 1200)
                )
            }
        }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let e = error as? CLError {
            switch e.code {
            case .denied, .locationUnknown:
               break
            case .network:
                alertItem = AlertContext.unableToGetLocations
            default:
                alertItem = AlertContext.didFailWithError
            }
        } else {
            alertItem = AlertContext.didFailWithError
        }
    }
}







