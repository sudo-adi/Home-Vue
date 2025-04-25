//
//  ContentView.swift
//  ARFurniture
//
//  Created by student-2 on 03/04/25.
//

import SwiftUI
import RealityKit
import ARKit

struct ContentView: View {
    @EnvironmentObject var placementSettings: PlacementSettings
    @State private var isControlsVisible: Bool = true
    @State private var showBrowse: Bool = false
    @State private var showSettings: Bool = false
    @Environment(\.dismiss) var dismiss
    
    // Add parameter to control browse view visibility
    var allowBrowse: Bool
    
    init(allowBrowse: Bool = true) {
        self.allowBrowse = allowBrowse
    }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                ARViewContainer()
                
                if self.placementSettings.selectedModel == nil {
//                    if allowBrowse {
//                        ControlView(isControlVisible: $isControlsVisible, showBrowse: $showBrowse, showSettings: $showSettings)
//                    } else {
//                        // Show controls without browse
//                        VStack {
//                            ControlVisibilityToggleButton(isControlVisible: $isControlsVisible)
//                            
//                            Spacer()
//                            
//                            if isControlsVisible {
//                                HStack {
//                                    //MostRecentlyPLaced Button
//                                    ControlButton(systemIconName: "clock.fill"){
//                                        print("MostRecentlyPlaced button pressed")
//                                    }
//                                    
//                                    Spacer()
//                                    
//                                    //Settings Button
//                                    ControlButton(systemIconName: "slider.horizontal.3"){
//                                        print("settings button pressed.")
//                                        self.showSettings.toggle()
//                                    }.sheet(isPresented: $showSettings){
//                                        SettingsView(showSettings: $showSettings)
//                                    }
//                                }
//                                .frame(maxWidth: 500)
//                                .padding(30)
//                                .background(Color.black.opacity(0.25))
//                            }
//                        }
//                    }
                    ControlView(isControlVisible: $isControlsVisible,
                                                  showBrowse: $showBrowse,
                                                  showSettings: $showSettings,
                                                  allowBrowse: allowBrowse)
                } else {
                    PlacementView()
                }
            }
            .edgesIgnoringSafeArea(.all)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .foregroundColor(.white)
                    }
                }
            }
            .navigationBarBackground({
                Color.clear
            })
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ARViewContainer: UIViewRepresentable {
    @EnvironmentObject var placementSettings: PlacementSettings
    @EnvironmentObject var sessionSettings: SessionSettings
    
    func makeUIView(context: Context) -> CustomARView {
        let arView = CustomARView(frame: .zero, sessionSettings: sessionSettings)
        
        // Setup lighting when view is created
        arView.setupLighting()
        
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        arView.session.run(config, options: [])
        
        self.placementSettings.sceneObserver = arView.scene.subscribe(to: SceneEvents.Update.self, { (event) in
            self.updateScene(for: arView)
        })
        return arView
    }
    
    func updateUIView(_ uiView: CustomARView, context: Context) {}
    
    private func updateScene(for arView: CustomARView) {
        arView.focusEntity?.isEnabled = self.placementSettings.selectedModel != nil
        
        if let confirmedModel = self.placementSettings.confirmedModel,
           let modelEntity = confirmedModel.modelEntity {
            self.place(modelEntity, in: arView)
            self.placementSettings.confirmedModel = nil
        }
    }
    
//    private func place(_ modelEntity: ModelEntity, in arView: ARView) {
//        let clonedEntity = modelEntity.clone(recursive: true)
//        
//        clonedEntity.generateCollisionShapes(recursive: true)
//        arView.installGestures([.translation, .rotation], for: clonedEntity)
//        
//        let anchorEntity = AnchorEntity(plane: .any)
//        anchorEntity.addChild(clonedEntity)
//        
//        arView.scene.addAnchor(anchorEntity)
//        print("added modelEntity to scene")
//    }
    private func place(_ modelEntity: ModelEntity, in arView: ARView) {
        let clonedEntity = modelEntity.clone(recursive: true)
        clonedEntity.generateCollisionShapes(recursive: true)
        arView.installGestures([.translation, .rotation], for: clonedEntity)
        
        // Get the center of the screen
        let screenCenter = CGPoint(x: arView.bounds.midX, y: arView.bounds.midY)
        
        // Perform raycast from screen center
        if let raycastResult = arView.raycast(from: screenCenter, allowing: .estimatedPlane, alignment: .any).first {
            // Create anchor at raycast hit position
            let anchorEntity = AnchorEntity(world: raycastResult.worldTransform)
            anchorEntity.addChild(clonedEntity)
            arView.scene.addAnchor(anchorEntity)
            print("Added modelEntity to scene at raycast position")
        } else {
            // Fallback to default plane anchor if raycast fails
            let anchorEntity = AnchorEntity(plane: .any)
            anchorEntity.addChild(clonedEntity)
            arView.scene.addAnchor(anchorEntity)
            print("Added modelEntity to scene with default plane anchor")
        }
    }
}

extension View {
    func navigationBarBackground(_ background: @escaping () -> some View) -> some View {
        return self.modifier(NavigationBarModifier(background: background))
    }
}

struct NavigationBarModifier<Background>: ViewModifier where Background: View {
    let background: () -> Background
    
    init(@ViewBuilder background: @escaping () -> Background) {
        self.background = background
        
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithTransparentBackground()
        coloredAppearance.backgroundColor = .clear
        coloredAppearance.shadowColor = .clear
        
        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().compactAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
    }
    
    func body(content: Content) -> some View {
        ZStack {
            content
            VStack {
                background()
                    .edgesIgnoringSafeArea([.top, .leading, .trailing])
                    .frame(height: 0)
                Spacer()
            }
        }
    }
}


#Preview {
    ContentView()
        .environmentObject(PlacementSettings())
        .environmentObject(SessionSettings())
}
