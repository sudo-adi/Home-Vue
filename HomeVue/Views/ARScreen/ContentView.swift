import SwiftUI
import RealityKit
import ARKit

struct ContentView: View {
    @EnvironmentObject var placementSettings: PlacementSettings
    @Environment(\.dismiss) private var dismiss
    @State private var showBrowse: Bool = false
    var allowBrowse: Bool
    
    init(allowBrowse: Bool = true) {
        self.allowBrowse = allowBrowse
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                ARViewContainer()
                
                if self.placementSettings.selectedModel == nil {
                    ControlView(showBrowse: $showBrowse, allowBrowse: allowBrowse)
                } else {
                    PlacementView()
                }
            }
            .edgesIgnoringSafeArea(.all)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: backButton)
        }
    }
    
    private var backButton: some View {
        Button(action: {
            // Pause AR session before navigating back
            ARSessionManager.shared.pauseSession()
            dismiss()
        }) {
            HStack {
                Image(systemName: "chevron.left")
                Text("Back")
            }
        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    @EnvironmentObject var placementSettings: PlacementSettings
    
    func makeUIView(context: Context) -> CustomARView {
        let arView = ARSessionManager.shared.setupARView(frame: .zero)
        
        // Subscribe to sceneEvents.update
        self.placementSettings.sceneObserver = arView.scene.subscribe(to: SceneEvents.Update.self, { (event) in
            self.updateScene(for: arView)
        })
        return arView
    }
    
    func updateUIView(_ uiView: CustomARView, context: Context) {
    }
    
    private func updateScene(for arView: CustomARView) {
        arView.focusEntity?.isEnabled = self.placementSettings.selectedModel != nil
        
        // Add model to scene if confirmed for placement
        if let confirmedModel = self.placementSettings.confirmedModel, let modelEntity = confirmedModel.modelEntity {
            self.place(modelEntity, in: arView)
            self.placementSettings.confirmedModel = nil
        }
    }
    
    private func place(_ modelEntity: ModelEntity, in arView: ARView) {
        // 1. Clone model Entity
        let clonedEntity = modelEntity.clone(recursive: true)
        
        // 2. Enable translation and rotation gesture
        clonedEntity.generateCollisionShapes(recursive: true)
        arView.installGestures([.translation, .rotation], for: clonedEntity)
        
        // 3. Get the center point of the screen
        let centerPoint = CGPoint(x: arView.bounds.midX, y: arView.bounds.midY)
        
        // 4. Perform raycast to find placement position
        if let (transform, position) = ARSessionManager.shared.performRaycast(at: centerPoint) {
            // Create an anchor entity at the raycast hit position
            let anchorEntity = AnchorEntity(world: transform)
            anchorEntity.addChild(clonedEntity)
            
            // Add the anchorEntity to the scene
            ARSessionManager.shared.addAnchor(anchorEntity)
            print("Added modelEntity to scene at position: \(position)")
        } else {
            print("Failed to find a valid surface for placement")
        }
    }
}

