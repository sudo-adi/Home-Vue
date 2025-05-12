import Foundation
import ARKit
import FocusEntity
import RealityKit
import SwiftUI
import Combine
import Photos

class CustomARView: ARView {
    var focusEntity: FocusEntity!
    var sessionSettings: SessionSettings
    
    @State private var toastMessage: String = ""
    @State private var showToast: Bool = false
    
    private var peopleOcclusionCancellable: AnyCancellable?
    private var objectOcclusionCancellable: AnyCancellable?
    private var lidarDebugCancellable: AnyCancellable?
    
    required init(frame frameRect: CGRect, sessionSettings: SessionSettings){
        self.sessionSettings = sessionSettings
        
        super.init(frame: frameRect)
        
        focusEntity = FocusEntity(on: self, focus: .classic)
        
        configure()
        
        self.initializeSettings()
        
        self.setupSubscribers()
    }
    
    required init(frame frameRect: CGRect){
        fatalError("init(frame:) has not been implemented")
    }
    
    @objc required dynamic init?(coder decoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]

        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
            config.sceneReconstruction = .mesh
            config.environmentTexturing = .automatic
            
            // Set the scene's physics origin to world space
//            self.environment.physicsOrigin = .world
        }
        
        // Start with a clean session
        session.run(config, options: [.resetTracking, .removeExistingAnchors])
    }
    
    func pauseSession() {
       session.pause()
       focusEntity.isEnabled = false
       print("AR session paused")
   }
   
   func resetSession() {
       let config = ARWorldTrackingConfiguration()
       config.planeDetection = [.horizontal, .vertical]
       config.sceneReconstruction = .mesh
       config.environmentTexturing = .automatic
       session.run(config, options: [.resetTracking, .removeExistingAnchors])
       print("AR session reset")
   }
    
    private func initializeSettings(){
        self.updatePeopleOcclusion(isEnabled: sessionSettings.isPeopleOcclusionEnabled)
        self.updateObjectOcclusion(isEnabled: sessionSettings.isObjectOcclusionEnabled)
        self.updateLidarDebug(isEnabled: sessionSettings.isLidarDebugEnabled)
    }
    
    private func setupSubscribers() {
        self.peopleOcclusionCancellable = sessionSettings.$isPeopleOcclusionEnabled.sink { [weak self] isEnabled in
            self?.updatePeopleOcclusion(isEnabled: isEnabled)
        }
        
        self.objectOcclusionCancellable = sessionSettings.$isObjectOcclusionEnabled.sink { [weak self] isEnabled in
            self?.updateObjectOcclusion(isEnabled: isEnabled)
        }
        
        self.lidarDebugCancellable = sessionSettings.$isLidarDebugEnabled.sink { [weak self] isEnabled in
            self?.updateLidarDebug(isEnabled: isEnabled)
        }
    }
    
    func setupLighting() {
        // Enable automatic environment lighting
        environment.sceneUnderstanding.options = [.occlusion, .physics]
        
        // Add directional light
        let directionalLight = DirectionalLight()
        directionalLight.light.intensity = 1000
        directionalLight.shadow = DirectionalLightComponent.Shadow(
            maximumDistance: 4,
            depthBias: 2
        )
        
        // Position the light
        directionalLight.look(at: [0, 0, 0], from: [1, 1.5, 1], relativeTo: nil)
        
        // Create anchor for lights
        let lightAnchor = AnchorEntity(.world(transform: .init(diagonal: [1,1,1,1])))
        lightAnchor.addChild(directionalLight)
        
        scene.addAnchor(lightAnchor)
    }

    
    private func updatePeopleOcclusion(isEnabled: Bool) {
        print("\(#file)): isPeopleOcclusionEnabled is now \(String(describing: isEnabled).uppercased())")
        
        // Verify device support for People Occlusion
        guard ARWorldTrackingConfiguration.supportsFrameSemantics(.personSegmentationWithDepth) else {
            return
        }
        
        // Obtain the AR Session current configuration
        guard let configuration = self.session.configuration as? ARWorldTrackingConfiguration else {
            return
        }
        
        // Enable/disable People Occlusion by adding/removing the personSegmentationWithDepth option to/from the configuration’s frame semantics.
//        if configuration.frameSemantics.contains(.personSegmentationWithDepth) {
//            configuration.frameSemantics.remove(.personSegmentationWithDepth)
//        } else {
//            configuration.frameSemantics.insert(.personSegmentationWithDepth)
//        }
        if isEnabled {
                configuration.frameSemantics.insert(.personSegmentationWithDepth)
            } else {
                configuration.frameSemantics.remove(.personSegmentationWithDepth)
            }
        
        // Rerun the session to affect the configuration change.
        self.session.run(configuration)
    }

    private func updateObjectOcclusion(isEnabled: Bool) {
        print("\(#file): isObjectOcclusionEnabled is now \(String(describing: isEnabled).uppercased())")
        
        // Verify device support for Object Occlusion
        guard ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) else {
            print("Device doesn't support scene reconstruction with mesh")
            return
        }
        
        // Obtain the AR Session current configuration
//        guard let configuration = self.session.configuration as? ARWorldTrackingConfiguration else {
//            print("Failed to get AR configuration")
//            return
//        }
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        configuration.environmentTexturing = .automatic
        // Enable mesh reconstruction first (required for object occlusion)
        configuration.sceneReconstruction = .mesh
        
        // Set object occlusion state based on the isEnabled parameter
        if isEnabled {
            self.environment.sceneUnderstanding.options.insert([.occlusion, .receivesLighting])
            // You might also need to set additional occlusion-related options
//            configuration.environmentTexturing = .automatic
        } else {
            self.environment.sceneUnderstanding.options.remove([.occlusion, .receivesLighting])
        }
        
        // Add more detailed debugging information
        print("Scene understanding options: \(self.environment.sceneUnderstanding.options)")
        
        // Rerun the session to affect the configuration change
//        self.session.run(configuration, options: [.resetSceneReconstruction])
//        self.session.run(configuration, options: [.resetTracking, .removeExistingAnchors, .resetSceneReconstruction])
        let options: ARSession.RunOptions = isEnabled ? [] : [.resetTracking, .removeExistingAnchors]
        self.session.run(configuration, options: options)
    }
    

    private func updateLidarDebug(isEnabled: Bool) {
        print("\(#file): isLidarDebugEnabled is now \(String(describing: isEnabled).uppercased())")
        
        // Verify device support for LiDAR
        guard ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) else {
            return
        }
        
        // Obtain the AR Session current configuration
        guard let configuration = self.session.configuration as? ARWorldTrackingConfiguration else {
            return
        }
        
        // Set LiDAR debug visualization state based on the isEnabled parameter
        if isEnabled {
            self.debugOptions.insert(.showSceneUnderstanding)
        } else {
            self.debugOptions.remove(.showSceneUnderstanding)
        }
        
        // Rerun the session to affect the configuration change if needed
        self.session.run(configuration)
    }
}
