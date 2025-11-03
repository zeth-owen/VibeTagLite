//
//  VibeLocation.swift
//  VibeTagLite
//
//  Created by Zeth Thomas on 5/7/25.
//

import CloudKit
import Foundation
import UIKit

struct VibeLocation: Identifiable, Hashable {
    
    static let kName = "name"
    static let kDescription = "description"
    static let kSquareAsset = "squareAsset"
    static let kBannerAsset = "bannerAsset"
    static let kAddress = "address"
    static let kLocation = "location"
    static let kWebsiteURL = "websiteURL"
    static let kPhoneNumber = "phoneNumber"
    static let kCategory = "category"
    static let kStateCode = "stateCode"
    
    let id: CKRecord.ID
    let name: String
    let description: String
    let squareAsset: CKAsset?
    let bannerAsset: CKAsset?
    let address: String
    let location: CLLocation
    let websiteURL: String
    let phoneNumber: String
    let category: String
    let stateCode: String
    
    init(record: CKRecord) {
        id = record.recordID
        name = record[VibeLocation.kName] as? String ?? "N/A"
        description = record[VibeLocation.kDescription] as? String ?? "N/A"
        squareAsset = record[VibeLocation.kSquareAsset] as? CKAsset
        bannerAsset = record[VibeLocation.kBannerAsset] as? CKAsset
        address = record[VibeLocation.kAddress] as? String ?? "N/A"
        location = record[VibeLocation.kLocation] as? CLLocation ?? CLLocation(latitude: 0, longitude: 0)
        websiteURL = record[VibeLocation.kWebsiteURL] as? String ?? "N/A"
        phoneNumber = record[VibeLocation.kPhoneNumber] as? String ?? "N/A"
        category = record[VibeLocation.kCategory] as? String ?? "N/A"
        stateCode = record[VibeLocation.kStateCode] as? String ?? "N/A"
        
    }
    
    var squareImage: UIImage {
        guard let asset = squareAsset else {
            return PlaceHolderImage.square
        }
        return asset.convertToUIImage(in: .square)
    }
    
    var bannerImage: UIImage {
        guard let asset = bannerAsset else {
            return PlaceHolderImage.banner
        }
        return asset.convertToUIImage(in: .banner)
    }
}
