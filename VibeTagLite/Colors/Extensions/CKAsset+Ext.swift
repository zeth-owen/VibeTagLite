//
//  CKAsset+Ext.swift
//  VibeTagLite
//
//  Created by Zeth Thomas on 5/7/25.
//

import CloudKit
import UIKit

extension CKAsset {
    func convertToUIImage(in dimension: ImageDimension) -> UIImage {
        
        guard let fileUrl = self.fileURL else { return dimension.placeHolderImage }
        
        do {
            let data = try Data(contentsOf: fileUrl)
            return UIImage(data: data) ?? dimension.placeHolderImage
        } catch {
            return dimension.placeHolderImage
        }
    }
}
