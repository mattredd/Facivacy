//
//  ImagePickerView.swift
//  Facivacy
//
//  Created by Matthew Reddin on 21/04/2020.
//  Copyright © 2020 Matthew Reddin. All rights reserved.
//

import Foundation
import SwiftUI

struct ImagePickerView: UIViewControllerRepresentable {
    
    @Binding var show: Bool
    @Binding var image: UIImage?
    
    func makeCoordinator() -> Coordinator {
        Coordinator(wrapper: self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        let imageWrapper: ImagePickerView
        
        init(wrapper: ImagePickerView) {
            self.imageWrapper = wrapper
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            imageWrapper.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            imageWrapper.show = false
        }
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imgPicker = UIImagePickerController()
        imgPicker.delegate = context.coordinator
        return imgPicker
    }
}
