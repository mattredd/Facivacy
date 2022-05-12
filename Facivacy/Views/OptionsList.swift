//
//  ManagementList.swift
//  Facivacy
//
//  Created by Matthew Reddin on 03/05/2022.
//  Copyright © 2022 Matthew Reddin. All rights reserved.
//

import SwiftUI

struct OptionsList: View {
    
    @EnvironmentObject var blurViewModel: AppViewModel
    @Environment(\.dismiss) var dismiss
    @Binding var showNewPictureView: Bool
    @Binding var shoudUseHighConfidenceForFaceDetection: Bool
    @Binding var faceCoveringMethod: Int
    
    var body: some View {
        Form {
            Section("New Picture") {
                Button {
                    withAnimation(.spring()) {
                        showNewPictureView = true
                        dismiss()
                    }
                } label: {
                    VStack(alignment: .leading, spacing: UIConstants.systemSpacing) {
                        Text("New Picture")
                        Text("All changes to the current image will be lost.")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                }
            }
            Section("Options") {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Require a high probability to detect a face")
                            .fixedSize(horizontal: false, vertical: true)
                            .lineLimit(nil)
                        Spacer()
                        Toggle("Require a high probability to detect a face", isOn: $shoudUseHighConfidenceForFaceDetection)
                            .labelsHidden()
                    }
                    Text("Turning this feature off will increase the likelihood of false positives.")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 8)
                ConcealTypePickerView(faceCoveringMethod: $faceCoveringMethod)
            }
            BlurredFacesList()
                .environmentObject(blurViewModel)
        }
        .overlay(
            Button(action: dismiss.callAsFunction) {
                Image(systemName: "xmark.circle.fill")
                    .font(.title)
                    .symbolRenderingMode(.hierarchical)
            }
            .tint(.secondary)
            .padding()
        , alignment: .topTrailing)
    }
}
