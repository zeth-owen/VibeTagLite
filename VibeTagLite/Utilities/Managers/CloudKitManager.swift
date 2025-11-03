//
//  CloudKitManager.swift
//  VibeTagLite
//
//  Created by Zeth Thomas on 5/7/25.
//

import CloudKit

final class CloudKitManager {
    
    static let shared = CloudKitManager()
    
    private init() {}
    
    var userRecord: CKRecord?
    var profileRecordID: CKRecord.ID?
    let container = CKContainer.default()
 
    
    
    func getUserRecord() async throws {
        
        let recordID = try await container.userRecordID( )
        let record = try await container.publicCloudDatabase.record(for: recordID)
        
        userRecord = record
        
        if let profileReference = record["userProfile"] as? CKRecord.Reference {
            profileRecordID = profileReference.recordID
        }
    }
    
    
    func getLocations() async throws -> [VibeLocation] {
        let query = CKQuery(recordType: "VibeLocation", predicate: NSPredicate(value: true))
        let (matchedResult, _) = try await CKContainer.default().publicCloudDatabase.records(matching: query)
        let locations = matchedResult.compactMap { _, result in try? result.get() }
        return locations.map(VibeLocation.init)
        
    }

    
    func getCompletedVibes(for profileRecordID: CKRecord.ID) async throws -> [CKRecord] {
        let userReference = CKRecord.Reference(recordID: profileRecordID, action: .none)
        
        let predicate = NSPredicate(format: "userReference == %@", userReference)
        let query = CKQuery(recordType: "UserVibeProgress", predicate: predicate)
        
        let (matchedResults, _) = try await container.publicCloudDatabase.records(matching: query)
        
        let completedVibeRecords = matchedResults.compactMap { (_, result) -> CKRecord? in
            return try? result.get()
        }
        
        return completedVibeRecords
    }

    
    
    
    func getPhotoSpots(for locationID: CKRecord.ID) async throws -> [VibePhoto] {
        let reference = CKRecord.Reference(recordID: locationID, action: .none)
        let predicate = NSPredicate(format: "vibeLocation == %@", reference)
        let query = CKQuery(recordType: RecordType.photo, predicate: predicate)
        
        let (matchResults, _) = try await container.publicCloudDatabase.records(matching: query)
        let records = matchResults.compactMap { _, result in try? result.get() }
        
        return records.map(VibePhoto.init)
    }
    
    func getFeaturedPhotos(for locationID: CKRecord.ID) async throws -> [FeaturedPhoto] {
        let reference = CKRecord.Reference(recordID: locationID, action: .none)
        let predicate = NSPredicate(format: "vibeLocation == %@", reference)
        let query = CKQuery(recordType: RecordType.featuredPhoto, predicate: predicate)
        
        let (matchResults, _) = try await container.publicCloudDatabase.records(matching: query)
        let records = matchResults.compactMap { _, result in try? result.get() }
        
        return records.map(FeaturedPhoto.init)
    }
    
    func getBusinessLogCount(for businessID: CKRecord.ID, increment: ScanIncrement) async throws -> Int {
        let reference = CKRecord.Reference(recordID: businessID, action: .none)
        var predicates: [NSPredicate] = [
            NSPredicate(format: "vibeReference == %@", reference)
        ]
        
        
        switch increment {
          case .daily:
            if let twentyFourHours = Calendar.current.date(byAdding: .hour, value: -24, to: Date()) {
                predicates.append(NSPredicate(format: "createdTimeStamp >= %@", twentyFourHours as NSDate))
            }
              
          case .weekly:
              if let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()) {
                  predicates.append(NSPredicate(format: "createdTimeStamp >= %@", sevenDaysAgo as NSDate))
              }
       
              
          case .monthly:
              if let monthAgo = Calendar.current.date(byAdding: .month, value: -1, to: Date()) {
                  predicates.append(NSPredicate(format: "createdTimeStamp >= %@", monthAgo as NSDate))
              }
              
          case .total:
              break
          }
        
         let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
         let query = CKQuery(recordType: "UserVibeProgress", predicate: predicate)
         
         let (matchResults, _) = try await CKContainer.default().publicCloudDatabase.records(matching: query)
         let records = matchResults.compactMap { _, result in try? result.get() }
         
         return records.count
        
    }
    
    
    func batchSave(records: [CKRecord]) async throws -> [CKRecord] {
        let (savedResult, _) = try await container.publicCloudDatabase.modifyRecords(saving: records, deleting: [])
        return savedResult.compactMap { _, result in try? result.get() }
        
    }
    
    func save(record: CKRecord) async throws -> CKRecord  {
        return try await container.publicCloudDatabase.save(record)
    }
    
    
    func fetchRecord(with id: CKRecord.ID) async throws -> CKRecord {
        return try await container.publicCloudDatabase.record(for: id)
    }
}



