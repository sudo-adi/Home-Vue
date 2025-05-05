//  RoomController.swift
//  Sample
//
//  Created by Nishtha on 27/04/25.
//
import RoomPlan
import SwiftUI
import UIKit
import SceneKit

class RoomController: NSObject, RoomCaptureViewDelegate {
    func encode(with coder: NSCoder) {
        fatalError("Not Needed")
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not Needed")
    }
    
    static let shared = RoomController()
    
    var captureView: RoomCaptureView
    var sessionConfig: RoomCaptureSession.Configuration
    var finalResult: CapturedRoom?
    var completion: ((CapturedRoom) -> Void)?
    var sceneView: SCNView?
    var scene: SCNScene?

    private override init() {
        captureView = RoomCaptureView(frame: .zero)
        sessionConfig = RoomCaptureSession.Configuration()
        scene = SCNScene()
        
        // Initialize SceneView
        sceneView = SCNView()
        sceneView?.allowsCameraControl = true
        sceneView?.autoenablesDefaultLighting = true
        sceneView?.backgroundColor = .black
        
        let camera = SCNCamera()
        let cameraNode = SCNNode()
        cameraNode.camera = camera
        cameraNode.position = SCNVector3(0, 0, 5)
        
        super.init()
        
        scene?.rootNode.addChildNode(cameraNode)
        captureView.delegate = self
    }
    
    // MARK: - Session Control
    func startSession(completion: @escaping (CapturedRoom) -> Void) {
        self.completion = completion
        captureView.captureSession.run(configuration: sessionConfig)
    }
    
    func stopSession() {
        captureView.captureSession.stop()
    }
    
    // MARK: - RoomCaptureViewDelegate
    func captureView(shouldPresent roomDataForProcessing: CapturedRoomData, error: Error?) -> Bool {
        return true
    }
    
    func captureView(didPresent processedResult: CapturedRoom, error: Error?) {
        finalResult = processedResult
        processCapturedRoom(processedResult)
        completion?(processedResult)
        print("Room Capture complete.")
    }
    
    // MARK: - Room Processing
    private func processCapturedRoom(_ room: CapturedRoom) {
        scene?.rootNode.childNodes.forEach { node in
            if node.camera == nil {
                node.removeFromParentNode()
            }
        }
        
        setupLights()
    }
    
    private func setupLights() {
        let ambientLight = SCNNode()
        ambientLight.light = SCNLight()
        ambientLight.light?.type = .ambient
        ambientLight.light?.intensity = 1000
        scene?.rootNode.addChildNode(ambientLight)
        
        let directionalLight = SCNNode()
        directionalLight.light = SCNLight()
        directionalLight.light?.type = .directional
        directionalLight.position = SCNVector3(5, 5, 5)
        scene?.rootNode.addChildNode(directionalLight)
    }
}

struct RoomCaptureViewRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> RoomCaptureView {
        RoomController.shared.captureView
    }
    
    func updateUIView(_ uiView: RoomCaptureView, context: Context) {}
}
