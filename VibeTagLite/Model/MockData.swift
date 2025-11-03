//
//  MockData.swift
//  VibeTagLite
//
//  Created by Zeth Thomas on 5/7/25.
//

import CloudKit
import Foundation
import SwiftUI

struct MockData {
    static var location: CKRecord {
        let record = CKRecord(recordType: RecordType.location)
        record[VibeLocation.kName] = "The Best Club"
        record[VibeLocation.kAddress] = "4567 Freshwater St"
        record[VibeLocation.kDescription] = "This is a test decription. It is super aweesome! How mucj writing before I hit 3 lines"
        record[VibeLocation.kWebsiteURL] = "https://www.google.com"
        record[VibeLocation.kLocation] = CLLocation(latitude: 36.10548, longitude: -115.15166)
        record[VibeLocation.kPhoneNumber] = " 307-333-3245"
        
        return record
    }
    
    static var profile: CKRecord {
        let record = CKRecord(recordType: RecordType.profile)
        record[VibeProfile.kFirstName] = "Zeth"
        record[VibeProfile.kLastName] = "Thomas"

        return record
    }
    
    static var featuredPhoto: CKRecord {
        let record = CKRecord(recordType: RecordType.featuredPhoto)
        record[FeaturedPhoto.kIGHandle] = "@beach123"
        return record
    }
}

struct Landmark {
    
    private var imageName2: String?
    
    var image2: Image? {
        guard let imageName2 else {
            return nil
        }
        return Image(imageName2)
    }
}
