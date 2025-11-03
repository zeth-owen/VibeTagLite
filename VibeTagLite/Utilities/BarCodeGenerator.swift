//
//  BarCodeGenerator.swift
//  VibeTagLite
//
//  Created by Zeth Thomas on 5/17/25.
//

import CloudKit
import CoreImage.CIFilterBuiltins
import SwiftUI


struct BarcodeGenerator {
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    func generateBarcode(vibeLocationID: CKRecord.ID, profileRecordID: CKRecord.ID) -> UIImage? {
        let payload: [String: String] = [
            "vibeLocationID": vibeLocationID.recordName,
            "profileRecordID": profileRecordID.recordName
        ]
        
        guard let data = try? JSONSerialization.data(withJSONObject: payload),
              let qrText = String(data: data, encoding: .utf8) else {
            return nil
        }
        
        filter.message = Data(qrText.utf8)
        
        if let outputImage = filter.outputImage {
            let scale: CGFloat = 6.6667 
             let transformedImage = outputImage.transformed(by: CGAffineTransform(scaleX: scale, y: scale))
             
             if let cgImage = context.createCGImage(transformedImage, from: transformedImage.extent) {
                 return UIImage(cgImage: cgImage)
                 
             }
         }
        
        return nil
    }
}
