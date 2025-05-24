import Foundation
import ARKit
import FocusEntity
import RealityKit
import SwiftUI
import Combine

class CustomARView: ARView {
    var focusEntity: FocusEntity!
    
    required init(frame frameRect: CGRect) {
        super.init(frame: frameRect)
        
        focusEntity = FocusEntity(on: self, focus: .classic)
    }
    
    @objc required dynamic init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
