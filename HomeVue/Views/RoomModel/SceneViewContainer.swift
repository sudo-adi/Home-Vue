//  SceneViewContainer.swift
//  Sample
//
//  Created by Nishtha on 27/04/25.
//
import SwiftUI
import SceneKit

struct SceneViewContainer: UIViewRepresentable {
    @Binding var scene: SCNScene
    var onTap: ((SCNVector3) -> Void)?
    var onNodeMove: ((SCNNode, SCNVector3) -> Void)?
    var onNodeSelect: ((SCNNode?) -> Void)?
    @Binding var selectedNode: SCNNode?
    var addedFurniture: [addFurniture]

    func makeUIView(context: Context) -> SCNView {
        let scnView = SCNView()
        scnView.scene = scene
        scnView.allowsCameraControl = true
        scnView.autoenablesDefaultLighting = true

        // Single tap gesture for placing furniture
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(_:)))
        tapGesture.numberOfTapsRequired = 1
        
        // Double tap gesture for selecting furniture
        let doubleTapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleDoubleTap(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
    
        tapGesture.require(toFail: doubleTapGesture)
        
        scnView.addGestureRecognizer(doubleTapGesture)
        scnView.addGestureRecognizer(tapGesture)

        // Pan gesture for moving furniture
        let panGesture = UIPanGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handlePan(_:)))
        panGesture.delegate = context.coordinator
        panGesture.maximumNumberOfTouches = 1
        scnView.addGestureRecognizer(panGesture)

        return scnView
    }

    func updateUIView(_ uiView: SCNView, context: Context) {
        uiView.scene = scene
        context.coordinator.selectedNode = selectedNode
        context.coordinator.addedFurniture = addedFurniture
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIGestureRecognizerDelegate {
        let parent: SceneViewContainer
        var selectedNode: SCNNode?
        var addedFurniture: [addFurniture] = []

        init(_ parent: SceneViewContainer) {
            self.parent = parent
            self.addedFurniture = parent.addedFurniture
        }

        func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
            if gestureRecognizer is UIPanGestureRecognizer {
                return selectedNode != nil
            }
            return true
        }

        @objc func handleTap(_ gesture: UITapGestureRecognizer) {
            guard let scnView = gesture.view as? SCNView else { return }
            let location = gesture.location(in: scnView)
            let hitResults = scnView.hitTest(location, options: [:])
            
            if selectedNode != nil {
                selectedNode = nil
                parent.selectedNode = nil
                parent.onNodeSelect?(nil)
                return
            }
            
            if let hit = hitResults.first {
                let position = hit.worldCoordinates
                parent.onTap?(position)
            }
        }
        
        @objc func handleDoubleTap(_ gesture: UITapGestureRecognizer) {
            guard let scnView = gesture.view as? SCNView else { return }
            let location = gesture.location(in: scnView)
            let hitResults = scnView.hitTest(location, options: [:])
        
            if let hitNode = hitResults.first?.node {
                if let matchedFurniture = findFurnitureForNode(hitNode) {
                    self.selectedNode = matchedFurniture.node
                    parent.selectedNode = matchedFurniture.node
                    parent.onNodeSelect?(matchedFurniture.node)
                    return
                }
            }
        }

        @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
            guard let scnView = gesture.view as? SCNView else { return }
            let location = gesture.location(in: scnView)

            guard let node = self.selectedNode else { return }

            let hitResults = scnView.hitTest(location, options: [SCNHitTestOption.searchMode: SCNHitTestSearchMode.all.rawValue])

            if let floorHit = hitResults.first(where: { hit in
                guard hit.node.geometry is SCNBox else { return false }
                if isNodeOrChild(hit.node, equalTo: node) {
                    return false
                }
                let normal = hit.worldNormal
                return normal.y > 0.8
            }) {
                let newPosition = floorHit.worldCoordinates
                node.position = SCNVector3(newPosition.x, node.position.y, newPosition.z)
                parent.onNodeMove?(node, node.position)
            }
        }
        
        private func findFurnitureForNode(_ node: SCNNode) -> addFurniture? {
            if let furniture = addedFurniture.first(where: { $0.node === node }) {
                return furniture
            }
            
            // Then check if it's a child node of any furniture
            for furniture in addedFurniture {
                if isNodeChildOf(node, parent: furniture.node) {
                    return furniture
                }
            }
            
            return nil
        }
        
        private func isNodeChildOf(_ node: SCNNode, parent: SCNNode) -> Bool {
            if parent.childNodes.contains(where: { $0 === node }) {
                return true
            }

            for child in parent.childNodes {
                if isNodeChildOf(node, parent: child) {
                    return true
                }
            }
            
            return false
        }
        
        private func isNodeOrChild(_ node: SCNNode, equalTo otherNode: SCNNode) -> Bool {
            if node === otherNode {
                return true
            }
            return isNodeChildOf(node, parent: otherNode)
        }
    }
}
