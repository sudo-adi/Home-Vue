//
//  ModelDeletionManager.swift
//  HomeVue
//
//  Created by Bhumi on 25/05/25.
//


import SwiftUI
import RealityKit

class ModelDeletionManager: ObservableObject {
    @Published var entitySelectedForDeletion: ModelEntity? = nil {
        willSet(newValue) {
            if self.entitySelectedForDeletion == nil, let newlySelectedModelEntity = newValue {
                
                // Selecting new entitySelectedForDeletion, no prior selection
                print("Selecting new entitySelectedForDeletion, no prior selection.")
                
                // Set newlySelectedModelEntity
                let component = ModelDebugOptionsComponent(visualizationMode: .lightingDiffuse)
                newlySelectedModelEntity.modelDebugOptions = component
            } else if let previouslySelectedModelEntity = self.entitySelectedForDeletion, let newlySelectedModelEntity = newValue {
                
                // Selecting new entitySelectedForDeletion, had a prior selection
                print("Selecting new entitySelectedForDeletion, had a prior selection.")

                // Clear previouslySelectedModelEntity
                previouslySelectedModelEntity.modelDebugOptions = nil
                
                // Set newlySelectedModelEntity
                let component = ModelDebugOptionsComponent(visualizationMode: .lightingDiffuse)
                newlySelectedModelEntity.modelDebugOptions = component
            } else if newValue == nil {
                
                // Clearing entitySelectedForDeletion
                print("Clearing entitySelectedForDeletion.")
                self.entitySelectedForDeletion?.modelDebugOptions = nil
            }
        }
    }
    
    func deleteSelectedModel() {
        guard let selectedEntity = entitySelectedForDeletion,
              let anchor = selectedEntity.anchor else { return }
        
        // Remove the anchor from ARSessionManager
        ARSessionManager.shared.removeAnchor(anchor as! AnchorEntity)
        
        // Clear the selected entity
        entitySelectedForDeletion = nil
    }
    
    func deleteAllModels() {
        // Remove all anchors from ARSessionManager
        ARSessionManager.shared.removeAllAnchors()
        
        // Clear the selected entity
        entitySelectedForDeletion = nil
    }
}
