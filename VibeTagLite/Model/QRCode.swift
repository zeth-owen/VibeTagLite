//
//  QRCode.swift
//  VibeTagLite
//
//  Created by Zeth Thomas on 6/11/25.
//

import CloudKit
import Foundation

struct QRCode: Identifiable {
    
    static let kIsUsed = "isUsed"
    static let kVibeLocation = "vibeLocation"
    static let kvibeProfile = "vibeProfile"
    
    let id: CKRecord.ID
    let isUsed: Bool
    let vibeLocation: CKRecord.Reference
    let vibeProfile: CKRecord.Reference
    
    init(record: CKRecord) {
        self.id = record.recordID
        self.isUsed = (record[QRCode.kIsUsed] as? NSNumber)?.boolValue ?? false
        self.vibeLocation = record[QRCode.kVibeLocation] as! CKRecord.Reference
        self.vibeProfile = record[QRCode.kvibeProfile] as! CKRecord.Reference
    }
}
