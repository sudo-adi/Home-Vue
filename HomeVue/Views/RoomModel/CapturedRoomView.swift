//  CapturedRoomView.swift
//  Sample
//
//  Created by Nishtha on 27/04/25.
//
import SwiftUI
import SceneKit
import RoomPlan
import simd
import UIKit

protocol CapturedRoomViewDelegate: AnyObject {
    func roomWasSaved()
}

struct addFurniture{
    let id : UUID
    let node : SCNNode
    let item : FurnitureItem
}

struct CapturedRoomView: View {
    var room: CapturedRoom?
    var onDismiss: (() -> Void)? = nil
    weak var delegate: CapturedRoomViewDelegate?

    @State private var scene = SCNScene()
    @State private var showFurnitureCatalogue = false
    @State private var showShareSheet = false
    @State private var shareURL: URL?

    @State private var showWalls = true
    @State private var wallColor: Color = Color(hex: "#f7f7f7")
    @State private var showWallControl = false
    @State private var wallTexture: String = "DefaultTexture"

    @State private var selectedNode: SCNNode?
    @State private var addedFurniture: [addFurniture] = []
    @State private var selectedFurnitureItem: FurnitureItem?
    @State private var rotationAngle: Double = 0

    @State private var showFloorControl = false
    @State private var floorTexture: String = "DefaultTexture"
    @State private var showControlSheet: Bool = false
    
    @State private var showExportPopup = false
    @State private var exportRoomName = ""
    @State private var exportCategory: String = ""
    private let exportCategories = ["Living Room", "Bedroom", "Kitchen", "Bathroom", "Other"]
    
    // Added states for save feedback
    @State private var showSaveConfirmation = false
    @State private var saveError: String? = nil
    
    @State private var showTutorial = true
    
    var body: some View {
        ZStack {
            if let room {
                SceneViewContainer(
                    scene: $scene,
                    onTap: { position in
                        if let item = selectedFurnitureItem {
                            addFurnitureItemToScene(item, at: position)
                            selectedFurnitureItem = nil
                        }
                    },
                    onNodeMove: { node, newPosition in
                        moveFurnitureNode(node, to: newPosition)
                    },
                    onNodeSelect: { node in
                        selectedNode = node
                    },
                    selectedNode: $selectedNode,
                    addedFurniture: addedFurniture
                )
                .onAppear {
                    setupScene(for: room)
                    setSceneBackgroundColor()
                }
                .onChange(of: showWalls) { oldValue, newValue in
                    setupScene(for: room)
                }
                .onChange(of: wallColor) { oldValue, newValue in
                    wallTexture = "DefaultTexture"
                    setupScene(for: room)
                }
                .onChange(of: wallTexture) { oldValue, newValue in
                    setupScene(for: room)
                }
                .onChange(of: floorTexture) { oldValue, newValue in
                    setupScene(for: room)
                }
                .edgesIgnoringSafeArea(.all)
            } else {
                Text("No room scanned.")
                    .foregroundColor(.gray)
            }
            
            if !showFurnitureCatalogue {
                VStack(alignment: .trailing, spacing: 12) {
                    CustomIconButton(imageName: "square.and.arrow.up") {
                        shareScene()
                    }

                    CustomIconButton(imageName: "chevron.left") {
                        withAnimation {
                            showFurnitureCatalogue = true
                        }
                    }

                    CustomIconButton(imageName: "paintbrush") {
                        withAnimation {
                            showWallControl = true
                        }
                    }
                }
                .padding(.top, 10)
                .padding(.leading, 20)
                .frame(maxWidth: .infinity, alignment: .topTrailing)
            }
            
            if let onDismiss = onDismiss {
                VStack {
                    HStack {
                        Button(action: { onDismiss() }) {
                            Image(systemName: "xmark")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.black.opacity(0.5))
                                .clipShape(Circle())
                        }
                        Spacer()
                    }
                    Spacer()
                }
                .padding()
            }
            
            VStack {
                Spacer()
                if selectedNode != nil {
                    Slider(
                        value: Binding(
                            get: {
                                rotationAngle
                            },
                            set: { newValue in
                                rotationAngle = newValue
                                if let node = selectedNode {
                                    node.eulerAngles.y = Float(newValue * .pi / 180)
                                }
                            }
                        ),
                        in: 0...360,
                        step: 1
                    )
                    .padding(.horizontal, 40)
                    .padding(.bottom, 8)
                }
                AddedFurnitureView(
                    // addedFurnitureItems: addedFurnitureItems,
                    addedFurnitureItems: addedFurniture.map { $0.item },
                    onRemove: { item in
                        if let idx = addedFurniture.firstIndex(where: { $0.item.id == item.id }) {
                            let furniture = addedFurniture[idx]
                            furniture.node.removeFromParentNode()
                            addedFurniture.remove(at: idx)
                            if selectedNode == furniture.node { selectedNode = nil }
                        }
                    },
                    onSelect: { item in
                        if let idx = addedFurniture.firstIndex(where: { $0.item.id == item.id }) {
                            let furniture = addedFurniture[idx]
                            selectedNode = furniture.node
                            rotationAngle = Double(furniture.node.eulerAngles.y) * 180 / .pi
                        }
                    }
                )
            }
            .padding(.bottom, -33)
            .ignoresSafeArea(.keyboard)

            if showFurnitureCatalogue {
                FurnitureCatalogueView(
                    isToolbarVisible: $showFurnitureCatalogue,
                    onAddFurniture: { item in
                        selectedFurnitureItem = item
                        showFurnitureCatalogue = false
                    }
                )
                .transition(.move(edge: .trailing))
            }
            if showExportPopup {
                Color.black.opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
                    .transition(.opacity)
                    .onTapGesture {
                        showExportPopup = false
                    }
                VStack(spacing: 16) {
                    Text("Export Room")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color(hex: "#393231"))
                        .padding(.top, 10)

                    // Room name text field
                    TextField("Enter room name", text: $exportRoomName)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(hex: "#393231"), lineWidth: 1)
                        )
                        .foregroundColor(Color(hex: "#393231"))
                        .font(.system(size: 15))

                    // Category picker
                    Menu {
                        ForEach(exportCategories, id: \.self) { category in
                            Button(category) { exportCategory = category }
                        }
                    } label: {
                        HStack {
                            Text(exportCategory.isEmpty ? "Select category" : exportCategory)
                                .foregroundColor(exportCategory.isEmpty ? Color(hex: "#393231").opacity(0.6) : Color(hex: "#393231"))
                                .font(.system(size: 15))
                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundColor(Color(hex: "#393231"))
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(hex: "#393231"), lineWidth: 1)
                        )
                    }

                    HStack(spacing: 12) {
                        Button(action: {
                            showExportPopup = false
                            exportRoomName = ""
                            exportCategory = ""
                        }) {
                            Text("Cancel")
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                                .background(Color(hex: "#635655"))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                                .font(.system(size: 15, weight: .medium))
                        }
                        Button(action: {
                            if exportRoomName.isEmpty || exportCategory.isEmpty {
                                saveError = "Please enter both room name and category"
                                showSaveConfirmation = true
                            } else {
                                let thumbnail = snapshotScene()
                                let category = RoomCategoryType(rawValue: exportCategory) ?? .others
                                let newRoom = RoomModel(
                                    name: exportRoomName,
                                    model3D: nil,
                                    modelImage: thumbnail,
                                    createdDate: Date(),
                                    userId: UUID(),
                                    category: category,
                                    capturedRoom: room 
                                )
                                RoomDataProvider.shared.addRoom(to: category, room: newRoom)
                                showExportPopup = false
                                exportRoomName = ""
                                exportCategory = ""
                                showSaveConfirmation = true
                                saveError = nil
                                
                                // Notify delegate that a room was saved
                                delegate?.roomWasSaved()
                            }
                        }) {
                            Text("Save")
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                                .background(Color(hex: "#393231"))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                                .font(.system(size: 15, weight: .medium))
                        }
                    }
                    .frame(height: 36)
                }
                .padding(20)
                .background(Color.white)
                .cornerRadius(14)
                .frame(maxWidth: 300)
                .shadow(radius: 10)
                .padding(.horizontal, 24)
                .transition(.scale)
            }
            if showWallControl || showFloorControl {
                VStack {
                    Spacer()
                    FloorAndWallSegmentedControlView(
                        wallTexture: $wallTexture,
                        wallColor: $wallColor,
                        showWalls: $showWalls,
                        floorTexture: $floorTexture,
                        isVisible: Binding(
                            get: { showWallControl || showFloorControl },
                            set: { newValue in
                                showWallControl = newValue
                                showFloorControl = newValue
                            }
                        )
                    )
                }
                .edgesIgnoringSafeArea(.bottom)
            }
            
            // Save confirmation alert
            if showSaveConfirmation {
                Color.black.opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
                    .transition(.opacity)
                
                VStack(spacing: 16) {
                    if let error = saveError {
                        Text("Error Saving Room")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Color(hex: "#393231"))
                            .padding(.top, 10)
                        
                        Text(error)
                            .font(.system(size: 15))
                            .foregroundColor(Color(hex: "#393231"))
                            .multilineTextAlignment(.center)
                    } else {
                        Text("Room Saved")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Color(hex: "#393231"))
                            .padding(.top, 10)
                        
                        Text("Your room has been saved successfully.")
                            .font(.system(size: 15))
                            .foregroundColor(Color(hex: "#393231"))
                            .multilineTextAlignment(.center)
                    }
                    
                    Button(action: {
                        showSaveConfirmation = false
                        saveError = nil
                    }) {
                        Text("OK")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .background(Color(hex: "#393231"))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .font(.system(size: 15, weight: .medium))
                    }
                }
                .padding(20)
                .background(Color.white)
                .cornerRadius(14)
                .frame(maxWidth: 300)
                .shadow(radius: 10)
                .padding(.horizontal, 24)
                .transition(.scale)
            }
        }
        .background(Color(hex: "#635655"))
        .navigationTitle("Captured Room")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showExportPopup = true
                }) {
                    Text("Save")
                        .font(.system(size: 16, weight: .medium))
                }
            }
        }
        .sheet(isPresented: $showShareSheet) {
            if let url = shareURL {
                ShareSheet(activityItems: [url])
            }
        }
        .sheet(isPresented: $showTutorial) {
            RoomTutorialView(isPresented: $showTutorial)
        }
    }
    private func addFurnitureItemToScene(_ item: FurnitureItem, at position: SCNVector3) {
        guard let sceneSource = SCNScene(named: item.model3D) else {
            print("DEBUG: Failed to load furniture model: \(item.model3D)")
            return
        }
        let furnitureNode = SCNNode()
        for child in sceneSource.rootNode.childNodes {
            furnitureNode.addChildNode(child)
        }

        furnitureNode.name = "furniture_\(item.name)"

        let (minVec, maxVec) = furnitureNode.boundingBox
        let modelWidth = CGFloat(abs(maxVec.x - minVec.x))
        let modelHeight = CGFloat(abs(maxVec.y - minVec.y))
        let modelDepth = CGFloat(abs(maxVec.z - minVec.z))
        
        // Convert dimensions from centimeters to meters (divide by 100)
        let itemWidth = CGFloat(item.dimensions.width) / 100.0
        let itemHeight = CGFloat(item.dimensions.height) / 100.0
        let itemDepth = CGFloat(item.dimensions.depth) / 100.0
        
        // Ensure we don't divide by zero
        let safeModelWidth = modelWidth > 0 ? modelWidth : 0.01
        let safeModelHeight = modelHeight > 0 ? modelHeight : 0.01
        let safeModelDepth = modelDepth > 0 ? modelDepth : 0.01
        
        // Calculate scale factors
        let scaleX = itemWidth / safeModelWidth
        let scaleY = itemHeight / safeModelHeight
        let scaleZ = itemDepth / safeModelDepth
        
        // Use the maximum scale to ensure the furniture is at least as large as specified
        let uniformScale = [scaleX, scaleY, scaleZ].max() ?? 1.0
        
        // Apply the scale
        furnitureNode.scale = SCNVector3(uniformScale, uniformScale, uniformScale)

        // Adjust the position to account for the model's origin
        for child in furnitureNode.childNodes {
            child.position.y -= minVec.y * Float(uniformScale)
        }
        
        // Set the position
        furnitureNode.position = position

        // Add to scene
        scene.rootNode.addChildNode(furnitureNode)

        // Add to tracking array
        let furniture = addFurniture(id: UUID(), node: furnitureNode, item: item)
        addedFurniture.append(furniture)
    }

    private func snapshotScene() -> UIImage? {
        let renderer = SCNRenderer(device: nil, options: nil)
        renderer.scene = scene
        let size = CGSize(width: 300, height: 200) // Adjust as needed
        let image = renderer.snapshot(atTime: 0, with: size, antialiasingMode: .multisampling4X)
        return image
    }
    
    private func moveFurnitureNode(_ node: SCNNode, to position: SCNVector3) {
        if addedFurniture.firstIndex(where: { $0.node === node }) != nil {
            node.position = position
        }
    }
    private func setupScene(for room: CapturedRoom) {
        scene.rootNode.childNodes.forEach { $0.removeFromParentNode() }

        if showWalls {
            let wallThickness: CGFloat = 0.1
            let walls = createSurfaceNodes(for: room.walls,
                                           length: wallThickness,
                                           contents: getWallContents())
            walls.forEach { scene.rootNode.addChildNode($0) }
        }

        let doorThickness: CGFloat = 0.11
        let doors = createSurfaceNodes(for: room.doors,
                                       length: doorThickness,
                                       contents: UIColor.brown)
        doors.forEach { scene.rootNode.addChildNode($0) }

        let windowThickness: CGFloat = 0.11
        let windows = createSurfaceNodes(for: room.windows,
                                         length: windowThickness,
                                         contents: UIColor.clear)
        windows.forEach { scene.rootNode.addChildNode($0) }

        let openingThickness: CGFloat = 0.11
        let openings = createSurfaceNodes(for: room.openings,
                                          length: openingThickness,
                                          contents: UIColor.blue.withAlphaComponent(0.5))
        openings.forEach { scene.rootNode.addChildNode($0) }

        let floorThickness: CGFloat = 0.05
        let floors = createSurfaceNodes(for: room.floors,
                                        length: floorThickness,
                                        contents: getFloorContents())
        floors.forEach { scene.rootNode.addChildNode($0) }

        let objects = createObjectNodes(for: room.objects)
        objects.forEach { scene.rootNode.addChildNode($0) }

        for furniture in addedFurniture {
            scene.rootNode.addChildNode(furniture.node)
        }
    }
    private func createSurfaceNodes(for surfaces: [CapturedRoom.Surface], length: CGFloat, contents: Any?) -> [SCNNode] {
        var nodes: [SCNNode] = []
        for surface in surfaces {
            let width = CGFloat(surface.dimensions.x)
            let height = CGFloat(surface.dimensions.y)
            let box = SCNBox(width: width, height: height, length: length, chamferRadius: 0)

            if let material = contents as? SCNMaterial {
                let materials = [material, material, material, material, material, material]
                box.materials = materials
            } else if let image = contents as? UIImage {
                // If we're using a simple image texture
                let material = SCNMaterial()
                material.diffuse.contents = image
                material.diffuse.wrapS = .repeat
                material.diffuse.wrapT = .repeat

                let scaleX = Float(width / 2.0)
                let scaleY = Float(height / 2.0)

                material.diffuse.contentsTransform = SCNMatrix4MakeScale(scaleX, scaleY, 1)

                let materials = [material, material, material, material, material]
                box.materials = materials
            } else {
                // If we're using a simple color
                let material = SCNMaterial()
                material.diffuse.contents = contents

                let materials = [material, material, material, material, material]
                box.materials = materials
            }

            let node = SCNNode(geometry: box)
            node.transform = SCNMatrix4(surface.transform)
            nodes.append(node)
        }
        return nodes
    }
    private func setSceneBackgroundColor() {
        scene.background.contents = Color(hex: "#635655")
    }
    private func createObjectNodes(for objects: [CapturedRoom.Object]) -> [SCNNode] {
        var nodes: [SCNNode] = []

        for object in objects {
            let width = CGFloat(object.dimensions.x)
            let height = CGFloat(object.dimensions.y)
            let length = CGFloat(object.dimensions.z)

            let boxGeometry = SCNBox(width: width, height: height, length: length, chamferRadius: 0)

            boxGeometry.firstMaterial?.diffuse.contents = UIColor.green.withAlphaComponent(0.8)
            boxGeometry.firstMaterial?.isDoubleSided = true

            let boxNode = SCNNode(geometry: boxGeometry)

            boxNode.transform = SCNMatrix4(object.transform)

            nodes.append(boxNode)
        }

        return nodes
    }

    private func loadModel(for category: FurnitureCategoryType) -> SCNNode? {
        var modelName: String
        switch category {
        case .tablesAndChairs: modelName = "Table"
        case .seatingFurniture: modelName = "Chair"
        default: return nil
        }

        let scene = SCNScene(named: "\(modelName).usdz")
        return scene?.rootNode.clone()
    }

    private func getWallContents() -> Any {
        switch wallTexture{
        case "DefaultTexture":
            return UIColor(wallColor)
        case "Tiles":
            return createPBRMaterial(named: "Tiles039_1K-JPG")
        case "BrickTexture":
            return createPBRMaterial(named: "PaintedBricks001_1K-JPG")
        case "PavingStoneTexture":
            return createPBRMaterial(named: "PavingStones128_1K-JPG")
        default:
            return UIColor(wallColor)
        }
    }

    private func getFloorContents() -> Any {
        switch floorTexture {
        case "DefaultTexture":
            return UIColor.gray.withAlphaComponent(0.7)
        case "WoodFloor":
            return createPBRMaterial(named: "WoodFloor054_1K-JPG")
        case "TileFloor2":
            return createPBRMaterial(named: "Tiles054_1K-JPG")
        case "TileFloor":
            return createPBRMaterial(named: "Tiles079_1K-JPG")
        case "MarbleFloor":
            return createPBRMaterial(named: "Marble014_1K-JPG")
        default:
            return UIColor.green.withAlphaComponent(0.7)
        }
    }

    func createPBRMaterial(named textureName: String) -> SCNMaterial {
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "\(textureName)_Color")
        material.normal.contents = UIImage(named: "\(textureName)_NormalGL")
        material.roughness.contents = UIImage(named: "\(textureName)_Roughness")
        material.ambientOcclusion.contents = UIImage(named: "\(textureName)_AmbientOcclusion")

        return material
    }

    private func exportSceneToUSDZ() -> URL? {
        let tempDir = FileManager.default.temporaryDirectory
        let fileURL = tempDir.appendingPathComponent("room_model.usdz")
        
        do {
            try scene.write(to: fileURL, options: nil, delegate: nil, progressHandler: nil)
            return fileURL
        } catch {
            print("Error exporting scene: \(error)")
            return nil
        }
    }

    private func shareScene() {
        if let url = exportSceneToUSDZ() {
            shareURL = url
            showShareSheet = true
        }
    }
}

// MARK: - Custom Button, WallControlView, etc.

//struct ArrowButton: View {
//   @Binding var showFurnitureCatalogue: Bool
//
//   var body: some View {
//       Button(action: {
//           withAnimation {
//               showFurnitureCatalogue = true
//           }
//       }) {
//           Image(systemName: "chevron.left")
//               .font(.system(size: 18, weight: .bold))
//               .foregroundColor(.white)
//               .frame(width: 60, height: 40)
//               .background(Color(hex: "#4a4551"))
//               .cornerRadius(20, corners: [.topLeft, .bottomLeft])
//       }
//   }
//}
struct CustomIconButton: View {
    let imageName: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: imageName)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 60, height: 40)
                .background(Color(hex: "#4a4551"))
                .cornerRadius(20, corners: [.topLeft, .bottomLeft])
        }
    }
}

extension View {
   func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
       clipShape(RoundedCorner(radius: radius, corners: corners))
   }
}

struct RoundedCorner: Shape {
   var radius: CGFloat = .infinity
   var corners: UIRectCorner = .allCorners

   func path(in rect: CGRect) -> Path {
       let path = UIBezierPath(
           roundedRect: rect,
           byRoundingCorners: corners,
           cornerRadii: CGSize(width: radius, height: radius))
       return Path(path.cgPath)
   }
}

// Add ShareSheet view for sharing functionality
struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: nil
        )
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
