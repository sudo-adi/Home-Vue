import Foundation
import ARKit
import RealityKit
import Combine
import FocusEntity

class ARSessionManager: ObservableObject {
    static let shared = ARSessionManager()
    
    // AR Session properties
    private(set) var arView: CustomARView?
    private var configuration: ARWorldTrackingConfiguration?
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        setupConfiguration()
    }
    
    private func setupConfiguration() {
        configuration = ARWorldTrackingConfiguration()
        configuration?.planeDetection = [.horizontal, .vertical]
        
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
            configuration?.sceneReconstruction = .mesh
        }
        
        // Enable people occlusion permanently
        if ARWorldTrackingConfiguration.supportsFrameSemantics(.personSegmentationWithDepth) {
            configuration?.frameSemantics.insert(.personSegmentationWithDepth)
        }
    }
    
    func setupARView(frame: CGRect) -> CustomARView {
        let arView = CustomARView(frame: frame)
        self.arView = arView
        
        if let config = configuration {
            arView.session.run(config)
        }
        
        // Enable object occlusion permanently
        arView.environment.sceneUnderstanding.options.insert(.occlusion)
        
        return arView
    }
    
    func pauseSession() {
        arView?.session.pause()
    }
    
    func resumeSession() {
        if let config = configuration {
            arView?.session.run(config)
        }
    }
    
    func addAnchor(_ anchor: AnchorEntity) {
        arView?.scene.addAnchor(anchor)
    }
    
    func removeAnchor(_ anchor: AnchorEntity) {
        arView?.scene.removeAnchor(anchor)
    }
    
    func performRaycast(at point: CGPoint) -> (simd_float4x4, simd_float3)? {
        guard let arView = arView else { return nil }
        
        // Perform raycast
        let raycastQuery = arView.makeRaycastQuery(from: point,
                                                  allowing: .estimatedPlane,
                                                  alignment: .any)
        
        guard let query = raycastQuery else { return nil }
        
        let results = arView.session.raycast(query)
        guard let firstResult = results.first else { return nil }
        
        let position = simd_float3(firstResult.worldTransform.columns.3.x,
                                 firstResult.worldTransform.columns.3.y,
                                 firstResult.worldTransform.columns.3.z)
        
        return (firstResult.worldTransform, position)
    }
} 
