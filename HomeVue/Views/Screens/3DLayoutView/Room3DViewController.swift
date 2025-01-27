//
//  Room3DViewController.swift
//  HomeVue
//
//  Created by Aditya Prasad on 27/01/25.
//


import UIKit
import SceneKit

class Room3DViewController: UIViewController {
    var scnView: SCNView!
    var modelNode: SCNNode!
    var cameraNode: SCNNode!

    var arrowButton: UIButton!
    var shareButton: UIButton!
    var addFurnitureToCatalogueToolBar: UIView! // Renamed expandable view
    var crossButton: UIButton!
    var scrollView: UIScrollView! // Scroll view for cards

    // List of furniture images and names
    let furnitureItems = [
        ("BedImg", "Bed"),
        ("CabinetsAndShelvesImg", "Cabinets & Shelves"),
        ("ChairImg", "Chair"),
        ("DecorImg", "Decor"),
        ("DiningImg", "Dining"),
        ("KitchenFurnitureImg", "Kitchen Furniture"),
        ("OthersImg", "Others"),
        ("SeatingFurnitureImg", "Seating Furniture"),
        ("TableImg", "Table")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSceneView()    // Set up the SceneKit view
        loadRoomModel()     // Load the 3D model
        addGestures()       // Add gestures for interaction
        setupArrowButton()  // Set up the arrow button
        setupShareButton()  // Set up the share button
        setupAddFurnitureToCatalogueToolBar() // Set up the expandable view
        setupCurrentViewportItems()
        setupAppBar()
    }

    // MARK: - Setup App Bar
    func setupAppBar() {
        // Create the app bar
        let appBar = UIView()
        appBar.backgroundColor = .clear

        // Add the app bar to the view first so we can use constraints
        view.addSubview(appBar)

        // Enable Auto Layout
        appBar.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
               // Pin to top of safe area - this replaces the fixed 45-point offset
            appBar.topAnchor.constraint(equalTo: view.topAnchor, constant:75),
               // Pin to left and right edges
               appBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
               appBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
               // Set height
               appBar.heightAnchor.constraint(equalToConstant: 45)
           ])

        // Add back button (using constraints)
        // Add back button (using constraints)
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .white // Black color for the icon and text
        backButton.setTitle(" Back", for: .normal)
        backButton.setTitleColor(.white, for: .normal) // Black color for the text
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        backButton.addTarget(self, action: #selector(handleBackButton), for: .touchUpInside)

        backButton.translatesAutoresizingMaskIntoConstraints = false
        appBar.addSubview(backButton)

        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: appBar.leadingAnchor, constant: 10),
            backButton.centerYAnchor.constraint(equalTo: appBar.centerYAnchor)
        ])

        // Add scan again button (using constraints)
        let scanAgainButton = UIButton(type: .system)
        scanAgainButton.setTitle("Scan Again", for: .normal)
        scanAgainButton.tintColor = .black // Black color for the text
        scanAgainButton.setTitleColor(.white, for: .normal) // Black color for the text
        scanAgainButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        scanAgainButton.addTarget(self, action: #selector(handleScanAgainButton), for: .touchUpInside)

        scanAgainButton.translatesAutoresizingMaskIntoConstraints = false
        appBar.addSubview(scanAgainButton)

        NSLayoutConstraint.activate([
            scanAgainButton.trailingAnchor.constraint(equalTo: appBar.trailingAnchor, constant: -10),
            scanAgainButton.centerYAnchor.constraint(equalTo: appBar.centerYAnchor)
        ])
    }


    @objc func handleBackButton() {
        // Dismiss the current view controller with animation
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - Handle Scan Again Button
    @objc func handleScanAgainButton() {
        // Handle scan again button action
        print("Scan Again button tapped")
        // Add your scan again functionality here
    }

    // MARK: - Setup SceneView
    func setupSceneView() {
        // Initialize SCNView and add it to the view controller
        scnView = SCNView(frame: view.bounds)
        scnView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(scnView)

        // Set up the scene
        let scene = SCNScene()
        scnView.scene = scene

        // Set the background color to #504645 (dark grayish-brown)
        scnView.backgroundColor = UIColor(hex: "#504645")

        // Add a camera node
        cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(0, 0, 10) // Move the camera further back
        cameraNode.camera?.fieldOfView = 60 // Increase the field of view for a wider perspective
        scene.rootNode.addChildNode(cameraNode)

        // Add ambient light to illuminate all parts of the model evenly
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light?.type = .ambient
        ambientLightNode.light?.intensity = 1000 // Adjust intensity as needed
        ambientLightNode.light?.color = UIColor.white
        scene.rootNode.addChildNode(ambientLightNode)

        // Add directional light for additional illumination
        let directionalLightNode = SCNNode()
        directionalLightNode.light = SCNLight()
        directionalLightNode.light?.type = .directional
        directionalLightNode.light?.intensity = 500 // Adjust intensity as needed
        directionalLightNode.light?.color = UIColor.white
        directionalLightNode.position = SCNVector3(0, 10, 10) // Position the light
        directionalLightNode.eulerAngles = SCNVector3(-Float.pi / 4, Float.pi / 4, 0) // Rotate the light
        scene.rootNode.addChildNode(directionalLightNode)
    }

    // MARK: - Load 3D Model
    func loadRoomModel() {
        // Load the 3D model from the app bundle
        let modelName = "plane" // Name of the 3D model file (e.g., .scn, .dae, .usdz)
        guard let modelURL = Bundle.main.url(forResource: modelName, withExtension: "usdz") else {
            print("Failed to find the 3D model in the bundle.")
            return
        }

        // Load the 3D model from the URL
        guard let modelScene = try? SCNScene(url: modelURL, options: nil) else {
            print("Failed to load the 3D model from the URL.")
            return
        }

        // Get the root node of the model
        modelNode = modelScene.rootNode

        // Position the model in the scene
        modelNode.position = SCNVector3(0, 0, 0) // Center the model

        // Scale the model if it's too large
        modelNode.scale = SCNVector3(0.5, 0.5, 0.5) // Adjust scale as needed

        // Add the model to the scene
        scnView.scene?.rootNode.addChildNode(modelNode)
    }

    // MARK: - Add Gestures for Interaction
    func addGestures() {
        // Rotation gesture
        let rotateGesture = UIRotationGestureRecognizer(target: self, action: #selector(handleRotation(_:)))
        scnView.addGestureRecognizer(rotateGesture)

        // Pinch gesture (for scaling)
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        scnView.addGestureRecognizer(pinchGesture)

        // Pan gesture (for translation)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        scnView.addGestureRecognizer(panGesture)
    }

    // MARK: - Gesture Handlers
    @objc func handleRotation(_ gesture: UIRotationGestureRecognizer) {
        guard gesture.state == .changed else { return }

        // Apply rotation to the model
        let rotation = Float(gesture.rotation)
        modelNode.eulerAngles.y -= rotation // Rotate around the Y-axis
        gesture.rotation = 0 // Reset the gesture rotation
    }

    @objc func handlePinch(_ gesture: UIPinchGestureRecognizer) {
        guard gesture.state == .changed else { return }

        // Apply scaling to the model
        let scale = Float(gesture.scale)
        modelNode.scale.x *= scale
        modelNode.scale.y *= scale
        modelNode.scale.z *= scale
        gesture.scale = 1 // Reset the gesture scale
    }

    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard gesture.state == .changed else { return }

        // Convert translation to 3D space
        let translation = gesture.translation(in: scnView)
        let deltaX = Float(translation.x) / 100
        let deltaY = Float(-translation.y) / 100

        // Apply translation to the model
        modelNode.position.x += deltaX
        modelNode.position.y += deltaY
        gesture.setTranslation(.zero, in: scnView) // Reset the gesture translation
    }

    // MARK: - Setup Arrow Button
    func setupArrowButton() {
        // Create the arrow button
        arrowButton = UIButton(type: .system)
        arrowButton.setImage(UIImage(systemName: "chevron.left"), for: .normal) // Chevron left icon
        arrowButton.tintColor = .white // White color for the icon
        arrowButton.backgroundColor = UIColor(hex: "#4a4551") // Background color
        arrowButton.layer.cornerRadius = 20 // Half of the height to make it pill-shaped
        arrowButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner] // Round left side only
        arrowButton.frame = CGRect(x: view.frame.width - 60, y: 150, width: 60, height: 40) // Positioned lower
        arrowButton.addTarget(self, action: #selector(toggleAddFurnitureToCatalogueToolBar), for: .touchUpInside)
        view.addSubview(arrowButton)
    }

    // MARK: - Setup Share Button
    func setupShareButton() {
        // Create the share button
        shareButton = UIButton(type: .system)
        shareButton.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal) // Share icon
        shareButton.tintColor = .white // White color for the icon
        shareButton.backgroundColor = UIColor(hex: "#4a4551") // Background color
        shareButton.layer.cornerRadius = 20 // Half of the height to make it pill-shaped
        shareButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner] // Round left side only
        shareButton.frame = CGRect(x: view.frame.width - 60, y: 100, width: 60, height: 40) // Positioned above the arrow button
        shareButton.addTarget(self, action: #selector(handleShare), for: .touchUpInside)
        view.addSubview(shareButton)
    }

    // MARK: - Setup Add Furniture To Catalogue ToolBar
    func setupAddFurnitureToCatalogueToolBar() {
        // Create the expandable view
        addFurnitureToCatalogueToolBar = UIView()
        addFurnitureToCatalogueToolBar.backgroundColor = UIColor(hex: "#4a4551").withAlphaComponent(0.8) // Semi-transparent
        addFurnitureToCatalogueToolBar.layer.cornerRadius = 10
        addFurnitureToCatalogueToolBar.isHidden = true // Initially hidden

        // Increase width and height
        let toolBarWidth = view.frame.width / 2.2 // Wider toolbar
        let toolBarHeight = view.frame.height / 2 * 1.2 // Increased height
        addFurnitureToCatalogueToolBar.frame = CGRect(x: view.frame.width - toolBarWidth, y: 150, width: toolBarWidth, height: toolBarHeight)
        view.addSubview(addFurnitureToCatalogueToolBar)

        // Add blur effect
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = addFurnitureToCatalogueToolBar.bounds
        blurView.layer.cornerRadius = 10
        blurView.clipsToBounds = true
        addFurnitureToCatalogueToolBar.addSubview(blurView)

        // Add cross button
        crossButton = UIButton(type: .system)
        crossButton.setTitle("×", for: .normal) // Cross symbol
        crossButton.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        crossButton.tintColor = .white
        crossButton.frame = CGRect(x: 10, y: 10, width: 30, height: 30)
        crossButton.addTarget(self, action: #selector(toggleAddFurnitureToCatalogueToolBar), for: .touchUpInside)
        addFurnitureToCatalogueToolBar.addSubview(crossButton)

        // Add "Inventory" text (centered horizontally)
        let inventoryLabel = UILabel()
        inventoryLabel.text = "Inventory"
        inventoryLabel.textColor = .white
        inventoryLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        inventoryLabel.sizeToFit()
        inventoryLabel.center = CGPoint(x: addFurnitureToCatalogueToolBar.frame.width / 2, y: 25)
        addFurnitureToCatalogueToolBar.addSubview(inventoryLabel)

        // Add scroll view
        scrollView = UIScrollView()
        scrollView.frame = CGRect(x: 0, y: 50, width: addFurnitureToCatalogueToolBar.frame.width, height: addFurnitureToCatalogueToolBar.frame.height - 60)
        scrollView.showsVerticalScrollIndicator = false
        addFurnitureToCatalogueToolBar.addSubview(scrollView)

        // Add square cards to the scroll view
        let cardSize = CGSize(width: scrollView.frame.width - 20, height: 150) // Increased height for name
        let spacing: CGFloat = 10 // Spacing between cards
        var yOffset: CGFloat = 0

        for (imageName, itemName) in furnitureItems {
            let card = UIView()
            card.backgroundColor = .white
            card.layer.cornerRadius = 10
            card.frame = CGRect(x: 10, y: yOffset, width: cardSize.width, height: cardSize.height)
            scrollView.addSubview(card)

            // Add + button at the top-left corner
            let addButton = UIButton(type: .system)
            addButton.setImage(UIImage(systemName: "plus"), for: .normal)
            addButton.tintColor = .white
            addButton.backgroundColor = UIColor(hex: "#393231") // Circular background
            addButton.layer.cornerRadius = 15 // Half of the height to make it circular
            addButton.frame = CGRect(x: 10, y: 10, width: 30, height: 30)
            card.addSubview(addButton)

            // Add furniture image (smaller size)
            let furnitureImageView = UIImageView(image: UIImage(named: imageName))
            furnitureImageView.contentMode = .scaleAspectFit
            furnitureImageView.frame = CGRect(x: 10, y: 50, width: card.frame.width - 20, height: 60) // Smaller image
            card.addSubview(furnitureImageView)

            // Add item name
            let nameLabel = UILabel()
            nameLabel.text = itemName
            nameLabel.textColor = .black
            nameLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            nameLabel.textAlignment = .center
            nameLabel.backgroundColor = UIColor(hex: "#F0F0F0") // Light gray background
            nameLabel.layer.cornerRadius = 5
            nameLabel.layer.masksToBounds = true
            nameLabel.layer.borderColor = UIColor.black.cgColor // Black border
            nameLabel.layer.borderWidth = 1 // Border width
            nameLabel.frame = CGRect(x: 10, y: 120, width: card.frame.width - 20, height: 20)
            card.addSubview(nameLabel)

            yOffset += cardSize.height + spacing
        }

        // Set the content size of the scroll view
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: yOffset)
    }

    // MARK: - Setup Current Viewport Items
    // MARK: - Setup Current Viewport Items
    func setupCurrentViewportItems() {
        // Create the horizontal bar at the bottom
        let currentViewportItems = UIView()
        currentViewportItems.backgroundColor = UIColor(hex: "#635f5f") // Background color
        currentViewportItems.layer.cornerRadius = 10 // Rounded corners
        currentViewportItems.frame = CGRect(x: 0, y: view.frame.height - 100, width: view.frame.width, height: 100) // Stick to the bottom
        view.addSubview(currentViewportItems)

        // Add a button (20% width)
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "cube.transparent"), for: .normal)
        button.tintColor = UIColor.white // White color for the icon
        button.backgroundColor = UIColor.white.withAlphaComponent(0.75) // 75% opacity
        button.layer.cornerRadius = (currentViewportItems.frame.height - 10) / 2 // Circular button
        button.frame = CGRect(
            x: currentViewportItems.frame.width * 0.8 + 5, // 80:20 proportion
            y: 5,
            width: currentViewportItems.frame.height - 20, // Smaller button
            height: currentViewportItems.frame.height - 20 // Smaller button
        )

        // Increase the size of the cube icon
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .default) // Smaller icon
        let largeCubeIcon = UIImage(systemName: "cube.transparent", withConfiguration: largeConfig)
        button.setImage(largeCubeIcon, for: .normal)

        currentViewportItems.addSubview(button)

        // Add a thin horizontal separator line
        let separatorLine = UIView()
        separatorLine.backgroundColor = UIColor.lightGray
        separatorLine.frame = CGRect(
            x: currentViewportItems.frame.width * 0.8,
            y: 5,
            width: 1,
            height: currentViewportItems.frame.height - 10
        )
        currentViewportItems.addSubview(separatorLine)
    }

    // MARK: - Toggle Add Furniture To Catalogue ToolBar
    @objc func toggleAddFurnitureToCatalogueToolBar() {
        if addFurnitureToCatalogueToolBar.isHidden {
            // Show the expandable view
            addFurnitureToCatalogueToolBar.isHidden = false
            arrowButton.isHidden = true
        } else {
            // Hide the expandable view
            addFurnitureToCatalogueToolBar.isHidden = true
            arrowButton.isHidden = false
        }
    }

    // MARK: - Handle Share Button
    @objc func handleShare() {
        // Handle share button action
        print("Share button tapped")
        // Add your share functionality here
    }
}

// MARK: - UIColor Extension for Hex Colors
extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if hexFormatted.hasPrefix("#") {
            hexFormatted.remove(at: hexFormatted.startIndex)
        }

        assert(hexFormatted.count == 6, "Invalid hex code used.")

        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)

        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}
