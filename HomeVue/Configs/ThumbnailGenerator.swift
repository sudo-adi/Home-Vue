//
//  ThumbnailGenerator.swift
//  HomeVue
//
//  Created by Bhumi on 25/03/25.
//


import UIKit
import SceneKit

class ThumbnailGenerator {
    static func generateThumbnail(from modelURL: URL, size: CGSize = CGSize(width: 300, height: 300)) -> UIImage? {
        let scene = try? SCNScene(url: modelURL, options: nil)
        let sceneView = SCNView(frame: CGRect(origin: .zero, size: size))
        sceneView.scene = scene
        sceneView.backgroundColor = .clear
        
        // Set up camera
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 5)
        scene?.rootNode.addChildNode(cameraNode)
        
        // Add ambient light
        let ambientLight = SCNNode()
        ambientLight.light = SCNLight()
        ambientLight.light?.type = .ambient
        ambientLight.light?.intensity = 1000
        scene?.rootNode.addChildNode(ambientLight)
        
        // Render the scene
        return sceneView.snapshot()
    }
}