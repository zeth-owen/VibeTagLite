//
//  FeaturedPhotoManager.swift
//  VibeTagLite
//
//  Created by Zeth Thomas on 5/20/25.
//

import Foundation

@Observable
final class FeaturedPhotoManager: ObservableObject {
    
    var featuredPhoto: [String: [FeaturedPhoto]] = [:]
    
}
