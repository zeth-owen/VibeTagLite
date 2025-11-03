//
//  VibeManager.swift
//  VibeTagLite
//
//  Created by Zeth Thomas on 5/7/25.
//

import Foundation

@Observable
final class VibeManager {
    
   var locations: [VibeLocation] = []
  
   @ObservationIgnored var groupedLocations: [String: [VibeLocation]] {
        Dictionary(grouping: locations, by: { $0.category })
    }
    
   @ObservationIgnored var selectedVibeLocation: VibeLocation?
    
        
}
