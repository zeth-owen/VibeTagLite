//
//  PhotoLocationManager.swift
//  VibeTagLite
//
//  Created by Zeth Thomas on 5/25/25.
//

import Foundation

@Observable
final class PhotoLocationManager: ObservableObject {
    
   var photoSpots: [String: [VibePhoto] ] = [:]
    
}
