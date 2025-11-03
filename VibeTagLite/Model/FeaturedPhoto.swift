//
//  FeaturedPhoto.swift
//  VibeTagLite
//
//  Created by Zeth Thomas on 5/10/25.
//

import CloudKit
import UIKit


struct FeaturedPhoto: Identifiable {
    
    static let kBarName = "barName"
    static let kIGHandle = "igHandle"
    static let kPortraitAsset = "portraitAsset"
    static let kSquareAsset = "squareAsset"
    static let kVibeLocation = "vibeLocation"
    
    
    var id: CKRecord.ID
    var igHandle: String
    var portraitAsset: CKAsset?
    var squareAsset: CKAsset?
    var vibeLocation: String
    
    
    init(record: CKRecord) {
        id = record.recordID
        igHandle = record[FeaturedPhoto.kIGHandle] as? String ?? ""
        portraitAsset = record[FeaturedPhoto.kPortraitAsset] as? CKAsset
        squareAsset = record[FeaturedPhoto.kSquareAsset] as? CKAsset
        vibeLocation = record[FeaturedPhoto.kVibeLocation] as? String ?? ""
    }
    
    func createSquareImage() -> UIImage {
        guard let asset = squareAsset else {
            return PlaceHolderImage.square
        }
        return asset.convertToUIImage(in: .square)
    }
}

