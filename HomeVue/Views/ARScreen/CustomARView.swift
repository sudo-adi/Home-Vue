//
//  CustomARView.swift
//  Temp
//
//  Created by Bhumi on 08/04/25.
//

import Foundation
import ARKit
import FocusEntity
import RealityKit
import SwiftUI
import Combine

class CustomARView: ARView {
    var focusEntity: FocusEntity!
    var sessionSettings: SessionSettings
    
    private var peopleOcclusionCancellable: AnyCancellable?
    private var objectOcclusionCancellable: AnyCancellable?
    private var lidarDebugCancellable: AnyCancellable?
    private var multiuserCancellable: AnyCancellable?
    
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
        }
        
        session.run(config)
    }
    
    private func initializeSettings(){
        self.updatePeopleOcclusion(isEnabled: sessionSettings.isPeopleOcclusionEnabled)
        self.updateObjectOcclusion(isEnabled: sessionSettings.isObjectOcclusionEnabled)
        self.updateLidarDebug(isEnabled: sessionSettings.isLidarDebugEnabled)
        self.updateMultiuser(isEnabled: sessionSettings.isMultiuserEnabled)

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
        
        self.multiuserCancellable = sessionSettings.$isMultiuserEnabled.sink { [weak self] isEnabled in
            self?.updateMultiuser(isEnabled: isEnabled)
        }
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
        guard let configuration = self.session.configuration as? ARWorldTrackingConfiguration else {
            print("Failed to get AR configuration")
            return
        }
        
        // Enable mesh reconstruction first (required for object occlusion)
        configuration.sceneReconstruction = .mesh
        
        // Set object occlusion state based on the isEnabled parameter
        if isEnabled {
            self.environment.sceneUnderstanding.options.insert(.occlusion)
            // You might also need to set additional occlusion-related options
            configuration.environmentTexturing = .automatic
        } else {
            self.environment.sceneUnderstanding.options.remove(.occlusion)
        }
        
        // Add more detailed debugging information
        print("Scene understanding options: \(self.environment.sceneUnderstanding.options)")
        
        // Rerun the session to affect the configuration change
        self.session.run(configuration, options: [.resetSceneReconstruction])
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
    
    private func updateMultiuser(isEnabled: Bool) {
        print("\(#file): isMultiuserEnabled is now \(String(describing: isEnabled).uppercased())")
    }
}
