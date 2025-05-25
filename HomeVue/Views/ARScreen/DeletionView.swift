//
//  DeletionView.swift
//  HomeVue
//
//  Created by Bhumi on 25/05/25.
//


import SwiftUI

struct DeletionView: View {
    @EnvironmentObject var modelDeletionManager: ModelDeletionManager
    
    var body: some View {
        HStack {
            Spacer()
            
            DeletionButton(systemIconName: "xmark.circle.fill") {
                print("Cancel Deletion button pressed.")
                self.modelDeletionManager.entitySelectedForDeletion = nil
            }
            
            Spacer()
            
            DeletionButton(systemIconName: "trash.circle.fill") {
                print("Confirm Deletion button pressed.")
                self.modelDeletionManager.deleteSelectedModel()
            }
            
            Spacer()
        }
        .padding(.bottom, 30)
    }
}

struct DeletionButton: View {
    let systemIconName: String
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            self.action()
        }) {
            Image(systemName: systemIconName)
                .font(.system(size: 50, weight: .light, design: .default))
                .foregroundColor(.white)
                .buttonStyle(PlainButtonStyle())
        }
        .frame(width: 75, height: 75)
    }
}
