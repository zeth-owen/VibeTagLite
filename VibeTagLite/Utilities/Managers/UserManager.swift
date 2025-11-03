//
//  UserManager.swift
//  VibeTagLite
//
//  Created by Zeth Thomas on 5/19/25.
//

import Foundation
import CloudKit

@Observable
final class UserManager {
    
    var completedVibes: [CKRecord.ID: Date] = [:]
    
    func cleanExpiredVibes() {
        let now = Date()
        for (id, completedDate) in completedVibes {
            let expiration = Calendar.current.date(byAdding: .day, value: 7, to: completedDate)!
            if expiration <= now {
                completedVibes[id] = nil
            }
        }
    }
    
    var isBusinessOwner: Bool = false
    var firstName: String = ""
    var lastName: String = ""
    
}
