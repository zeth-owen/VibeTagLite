//
//  CKRecord+Ext.swift
//  VibeTagLite
//
//  Created by Zeth Thomas on 6/18/25.
//

import Foundation

import CloudKit

extension CKRecord {
    func convertToVibeLocation() -> VibeLocation { VibeLocation(record: self) }
//    func convertToVibeProfile() -> VibeProfile { VibeProfile(record: self) }
//    func convertToVibePhoto() -> VibePhoto { VibePhoto(record: self) }
//    func convertToFeaturedPhoto() -> FeaturedPhoto { FeaturedPhoto(record: self) }
}
