//
//  GenericVirtualObject.swift
//  ARKitProject
//
//  Created by Bhumi on 07/03/25.
//  Copyright © 2025 Apple. All rights reserved.
//

import Foundation
import SceneKit
class GenericVirtualObject: VirtualObject, ReactsToScale {
    private var particleSize: Float?
    
    init(modelName: String, thumbnailName: String? = nil, initialScale: SCNVector3 = SCNVector3(1.0, 1.0, 1.0), particleSize: Float? = nil) {
        super.init(modelName: modelName, fileExtension: "scn", thumbImageFilename: thumbnailName ?? modelName, title: modelName.capitalized)
        self.scale = initialScale
        self.particleSize = particleSize
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadModel() {
        super.loadModel()
        
        // Ensure model sits on the surface
        self.boundingBox.min.y = 0
        
        // Adjust position to sit on surface
        let (min, max) = self.boundingBox
        let height = max.y - min.y
        self.position.y = height/2
    }
    
    func reactToScale() {
        if let particleSize = particleSize {
            let flameNode = self.childNode(withName: "flame", recursively: true)
            flameNode?.particleSystems?.first?.reset()
            flameNode?.particleSystems?.first?.particleSize = CGFloat(self.scale.x * particleSize)
        }
    }
}
