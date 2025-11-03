//
//  UserVibeProgress.swift
//  VibeTagLite
//
//  Created by Zeth Thomas on 6/26/25.
//

import CloudKit
import Foundation

struct UserVibeProgress: Identifiable {
    
    static let kUserReference = "userReference"
    static let kVibeReference = "vibeReference"
    static let kVibePhotoReference = "vibePhotoReference"
    static let kCreatedTimeStamp = "createdTimeStamp"
    
    let id: CKRecord.ID
    let userReference:  CKRecord.Reference?
    let vibeReference: CKRecord.Reference?
    let vibePhotoReference: CKRecord.Reference?
    let createdTimeStamp: Date?
    
    init(record: CKRecord) {
        self.id = record.recordID
        self.userReference = record[UserVibeProgress.kUserReference] as? CKRecord.Reference
        self.vibeReference = record[UserVibeProgress.kVibeReference] as? CKRecord.Reference
        self.vibePhotoReference = record[UserVibeProgress.kVibePhotoReference] as? CKRecord.Reference
        self.createdTimeStamp = record[UserVibeProgress.kCreatedTimeStamp] as? Date
    }
}
