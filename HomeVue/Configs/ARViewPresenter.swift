//
//  ARViewPresenter.swift
//  HomeVue
//
//  Created by Bhumi on 21/04/25.
//


import UIKit
import SwiftUI

//class ARViewPresenter {
//    static func presentARView(for furnitureItem: FurnitureItem? = nil, allowBrowse: Bool, from viewController: UIViewController) {
//        // Create placement settings
//        let placementSettings = PlacementSettings()
////        let sessionSettings = SessionSettings()
//        
//        // If a furniture item is provided, set up the model
//        if let furnitureItem = furnitureItem {
//            let modelCategory = Model.getCategoryFromModel3D(furnitureItem.model3D!)
//            let scaleCompensation = Model.getScaleCompensation(furnitureItem.model3D!)
//            let model = Model(name: furnitureItem.model3D!.replacingOccurrences(of: ".usdz", with: ""), category: modelCategory, scaleCompensation: scaleCompensation)
//            model.asyncLoadModelEntity()
//            placementSettings.selectedModel = model
//            print("Presenting AR view for: \(furnitureItem.name), model: \(furnitureItem.model3D)")
//        } else {
//            print("Presenting AR view with no initial model, allowBrowse: \(allowBrowse)")
//        }
//        
//        // Create content view with the specified allowBrowse value
//        let contentView = ContentView(allowBrowse: allowBrowse)
//            .environmentObject(placementSettings)
////            .environmentObject(sessionSettings)
//        
//        // Present the SwiftUI view modally
//        viewController.presentFullScreen(contentView)
//    }
//}
// ARViewPresenter.swift
import UIKit
import SwiftUI

//class ARViewPresenter {
//    @MainActor
//    static func presentARView(for furnitureItem: FurnitureItem? = nil, allowBrowse: Bool, from viewController: UIViewController) async {
//        let placementSettings = PlacementSettings()
//        
//        if let furnitureItem = furnitureItem {
//            let modelCategory = Model.getCategoryFromModel3D(furnitureItem.model3D ?? "Others.usdz")
//            let scaleCompensation = Model.getScaleCompensation(furnitureItem.model3D ?? "Others.usdz")
//            let model = Model(
//                name: furnitureItem.name ?? "Unnamed",
//                category: modelCategory,
//                thumbnail: furnitureItem.imageURL,
//                scaleCompensation: scaleCompensation
//            )
//            do {
//                try await model.asyncLoadModelEntity(from: furnitureItem.model3D)
//                placementSettings.selectedModel = model
//                print("Presenting AR view for: \(furnitureItem.name ?? "Unnamed"), model: \(furnitureItem.model3D ?? "None")")
//            } catch {
//                print("Failed to load model: \(error)")
//                return
//            }
//        } else {
//            print("Presenting AR view with no initial model, allowBrowse: \(allowBrowse)")
//        }
//        
//        let contentView = ContentView(allowBrowse: allowBrowse)
//            .environmentObject(placementSettings)
//        
//        viewController.presentFullScreen(contentView)
//    }
//}
class ARViewPresenter {
    @MainActor
    static func presentARView(for furnitureItem: FurnitureItem? = nil, allowBrowse: Bool, from viewController: UIViewController) async {
        let placementSettings = PlacementSettings()
        
        if let furnitureItem = furnitureItem {
            guard
                let name = furnitureItem.name,
                let modelURL = furnitureItem.model3D,
                let category = ModelCategory(rawValue: furnitureItem.category.rawValue)
            else {
                print("❌ Invalid FurnitureItem, cannot present AR view.")
                return
            }

            let model = Model(
                name: name,
                category: category,
                thumbnail: furnitureItem.imageURL,
                scaleCompensation: Float(Double(furnitureItem.scaleCompenstation))            )

            do {
                try await model.asyncLoadModelEntity(from: modelURL)
                placementSettings.selectedModel = model
                print("📱 Presenting AR view for: \(name), model: \(modelURL)")
            } catch {
                print("❌ Failed to load modelEntity for \(name): \(error)")
                return
            }
        } else {
            print("📱 Presenting AR view with no initial model, allowBrowse: \(allowBrowse)")
        }

        let contentView = ContentView(allowBrowse: allowBrowse)
            .environmentObject(placementSettings)

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

