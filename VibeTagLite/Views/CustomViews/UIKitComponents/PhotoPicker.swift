//
//  PhotoPicker.swift
//  VibeTagLite
//
//  Created by Zeth Thomas on 5/17/25.
//

import SwiftUI

struct PhotoPicker: UIViewControllerRepresentable {

    @Binding var image: UIImage?
    @Environment(\.dismiss) var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(photoPicker: self)
    }
    
    
    final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let photoPicker: PhotoPicker
        
        init(photoPicker: PhotoPicker) {
            self.photoPicker = photoPicker
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                let compressedImageData = image.jpegData(compressionQuality: 0.25)!
                photoPicker.image = UIImage(data: compressedImageData)!
                
            }
            photoPicker.dismiss()
        }
    }
}
