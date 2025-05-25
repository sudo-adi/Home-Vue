//
//  ARViewPresenter.swift
//  HomeVue
//
//  Created by Bhumi on 21/04/25.
//


import UIKit
import SwiftUI

class ARViewPresenter {
    static func presentARView(for furnitureItem: FurnitureItem? = nil, allowBrowse: Bool, from viewController: UIViewController) {
        // Create placement settings
        let placementSettings = PlacementSettings()
        let modelDeletionManager = ModelDeletionManager()
        
        // If a furniture item is provided, set up the model
        if let furnitureItem = furnitureItem {
            let modelCategory = Model.getCategoryFromModel3D(furnitureItem.model3D)
            let scaleCompensation = Model.getScaleCompensation(furnitureItem.model3D)
            let model = Model(name: furnitureItem.model3D.replacingOccurrences(of: ".usdz", with: ""), category: modelCategory, scaleCompensation: scaleCompensation)
            model.asyncLoadModelEntity()
            placementSettings.selectedModel = model
            print("Presenting AR view for: \(furnitureItem.name), model: \(furnitureItem.model3D)")
        } else {
            print("Presenting AR view with no initial model, allowBrowse: \(allowBrowse)")
        }
        
        // Create content view with the specified allowBrowse value
        let contentView = ContentView(allowBrowse: allowBrowse)
            .environmentObject(placementSettings)
            .environmentObject(modelDeletionManager)
        
        // Present the SwiftUI view modally
        viewController.presentFullScreen(contentView)
    }
}

extension UIViewController {
    func presentFullScreen(_ content: some View) {
        let hostingController = UIHostingController(rootView: content)
        hostingController.modalPresentationStyle = .fullScreen
        present(hostingController, animated: true, completion: nil)
    }
}
