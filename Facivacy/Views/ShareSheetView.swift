//
//  ShareSheetView.swift
//  Facivacy
//
//  Created by Matthew Reddin on 22/04/2020.
//  Copyright © 2020 Matthew Reddin. All rights reserved.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

struct ShareSheetView: UIViewControllerRepresentable {

    @Binding var showShareSheet: Bool
    let finalImage: Data
    let imageUTI = UTType.jpeg
    
    func makeCoordinator() -> Coordinator {
        Coordinator(wrapper: self)
    }
    
    class Coordinator: NSObject, UIActivityItemSource {
        
        let shareSheet: ShareSheetView
        
        func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
            Data()
        }
        
        func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
            shareSheet.finalImage
        }
        
        func activityViewController(_ activityViewController: UIActivityViewController, dataTypeIdentifierForActivityType activityType: UIActivity.ActivityType?) -> String {
            shareSheet.imageUTI.identifier
        }
        
        init(wrapper: ShareSheetView) {
            self.shareSheet = wrapper
        }
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let shareSheet = UIActivityViewController(activityItems: [context.coordinator], applicationActivities: nil)
        shareSheet.completionWithItemsHandler = { (_, _, _, _) in
            self.showShareSheet = false
        }
        return shareSheet
    }
}
