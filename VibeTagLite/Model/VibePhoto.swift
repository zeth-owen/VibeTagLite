//
//  VibePhoto.swift
//  VibeTagLite
//
//  Created by Zeth Thomas on 5/8/25.
//


import CloudKit
import Foundation
import UIKit

struct VibePhoto: Identifiable {
    
    static let kVibeLocation = "vibeLocation"
    static let kBarName = "barName"
    static let kSquareAsset = "squareAsset"
    static let kLocation = "location"
    static let kDescription = "description"
    
    let id: CKRecord.ID
    let vibeLocation: CKRecord.Reference?
    let barName: String
    let squareAsset: CKAsset?
    let location: String
    let description: String
    
    init(record: CKRecord) {
        id = record.recordID
        vibeLocation = record[VibePhoto.kVibeLocation] as? CKRecord.Reference
        barName = record[VibePhoto.kBarName] as? String ?? ""
        squareAsset = record[VibePhoto.kSquareAsset] as? CKAsset
        location = record[VibePhoto.kLocation] as? String ?? ""
        description = record[VibePhoto.kDescription] as? String ?? ""
    }
    
    var squareImage: UIImage {
        
        guard let asset = squareAsset else {
            return PlaceHolderImage.square
        }
        return asset.convertToUIImage(in: .square)
    }
}


