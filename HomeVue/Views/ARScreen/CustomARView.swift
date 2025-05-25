import Foundation
import ARKit
import FocusEntity
import RealityKit
import SwiftUI
import Combine

class CustomARView: ARView {
    var modelDeletionManager: ModelDeletionManager
    var focusEntity: FocusEntity!
    var allowBrowse: Bool
    
    required init(frame frameRect: CGRect) {
        // Initialize with a default ModelDeletionManager
        self.modelDeletionManager = ModelDeletionManager()
        self.allowBrowse = false
        super.init(frame: frameRect)
        
        focusEntity = FocusEntity(on: self, focus: .classic)
    }
    
    convenience init(frame frameRect: CGRect, modelDeletionManager: ModelDeletionManager, allowBrowse: Bool) {
        self.init(frame: frameRect)
        self.modelDeletionManager = modelDeletionManager
        self.allowBrowse = allowBrowse
        if allowBrowse {
            enableObjectDeletion()
        }
    }
    
    @objc required dynamic init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func enableObjectDeletion() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(recognizer:)))
        longPressGesture.minimumPressDuration = 0.5 // Set minimum press duration to 0.5 seconds
        self.addGestureRecognizer(longPressGesture)
    }
    
    @objc func handleLongPress(recognizer: UILongPressGestureRecognizer) {
        guard allowBrowse else { return }
        
        let location = recognizer.location(in: self)
        
        switch recognizer.state {
        case .began:
            // Get entity at location, if any
            if let entity = self.entity(at: location) as? ModelEntity {
                print("Long press detected on model: \(entity.name)")
                // Only select if it's not already selected
                if modelDeletionManager.entitySelectedForDeletion !== entity {
                    modelDeletionManager.entitySelectedForDeletion = entity
                }
            } else {
                print("No model found at location")
            }
        case .ended, .cancelled:
            // Optionally handle gesture end
            break
        default:
            break
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        // Only clear selection if deletion is enabled
        if allowBrowse {
            if let touch = touches.first {
                let location = touch.location(in: self)
                if self.entity(at: location) == nil {
                    modelDeletionManager.entitySelectedForDeletion = nil
                }
            }
        }
    }
}
