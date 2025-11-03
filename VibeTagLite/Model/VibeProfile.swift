//
//  VibeProfile.swift
//  VibeTagLite
//
//  Created by Zeth Thomas on 5/7/25.
//

import CloudKit
import Foundation


struct VibeProfile {
    
    static let kAppleIdentifier = "appleIdentifier"
    static let kFirstName = "firstName"
    static let kLastName = "lastName"
    static let kBusiness = "business"
   
   

    
    let ckRecordID: CKRecord.ID
    let appleIdentifier: String
    let firstName: String
    let lastName: String
    let business: String
    
    init(record: CKRecord) {
        ckRecordID = record.recordID
        firstName = record[VibeProfile.kFirstName] as? String ?? ""
        lastName = record[VibeProfile.kLastName] as? String ?? ""
        appleIdentifier = record[VibeProfile.kAppleIdentifier] as? String ?? ""
        business = record[VibeProfile.kBusiness] as? String ?? ""
  
    }
    
}
