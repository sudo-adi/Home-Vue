import UIKit
import SceneKit

class Room3DViewController: UIViewController {

    var modelURL: URL?
    var roomName: String?

    var scnView: SCNView!
    var modelNode: SCNNode!
    var cameraNode: SCNNode!

    var arrowButton: UIButton!
    var shareButton: UIButton!
    var addFurnitureToCatalogueToolBar: UIView! // Renamed expandable view
    var crossButton: UIButton!
    var scrollView: UIScrollView! // Scroll view for cards
    
    private var isShowingCategories = true
    private var currentCategory: FurnitureCategoryType?
    private let furnitureDataProvider = FurnitureDataProvider.shared

    // List of furniture images and names
//    let furnitureItems = [
//        ("BedImg", "Bed"),
//        ("CabinetsAndShelvesImg", "Cabinets & Shelves"),
//        ("ChairImg", "Chair"),
//        ("DecorImg", "Decor"),
//        ("DiningImg", "Dining"),
//        ("KitchenFurnitureImg", "Kitchen Furniture"),
//        ("OthersImg", "Others"),
//        ("SeatingFurnitureImg", "Seating Furniture"),
//        ("TableImg", "Table"),
//    ]

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
        // Get the key window scene
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = windowScene.delegate as? SceneDelegate else {
            return
        }
        
        // Create and set the CustomTabBarController as root
        let tabBarController = CustomTabBarController()
        sceneDelegate.window?.rootViewController = tabBarController
        sceneDelegate.window?.makeKeyAndVisible()
        
        // Optional: Add cross dissolve transition
        UIView.transition(with: sceneDelegate.window!,
                          duration: 0.1,
                          options: .transitionCrossDissolve,
                          animations: nil,
                          completion: nil)
    }

    // MARK: - Handle Scan Again Button
    @objc func handleScanAgainButton() {
        
        self.dismiss(animated: true, completion: nil)

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
        
        // Enhanced lighting
           ambientLightNode.light = SCNLight()
           ambientLightNode.light?.type = .ambient
           ambientLightNode.light?.intensity = 1000
           ambientLightNode.light?.color = UIColor.white
           scene.rootNode.addChildNode(ambientLightNode)

           // Key light
           let directionalLight = SCNLight()
           directionalLight.type = .directional
           directionalLight.intensity = 1000
           directionalLight.castsShadow = true
           let directionalNode = SCNNode()
           directionalNode.light = directionalLight
           directionalNode.position = SCNVector3(-10, 20, 10)
           directionalNode.eulerAngles = SCNVector3(-Float.pi/4, -Float.pi/4, -Float.pi/4)
           scene.rootNode.addChildNode(directionalNode)
           
           // Fill light
           let fillLight = SCNLight()
           fillLight.type = .directional
           fillLight.intensity = 500
           let fillNode = SCNNode()
           fillNode.light = fillLight
           fillNode.position = SCNVector3(10, 10, 10)
           scene.rootNode.addChildNode(fillNode)
    }

    func loadRoomModel() {
        guard let modelURL = self.modelURL else {
            print("No model URL provided")
            return
        }

        do {
            // Load the USDZ file
            let modelScene = try SCNScene(url: modelURL, options: nil)
            modelNode = modelScene.rootNode

            // Center the model
            modelNode.position = SCNVector3(0, 0, 0)
            
            // Calculate screen dimensions
            let screenSize = UIScreen.main.bounds.size
            let scaleFactor = Float(min(screenSize.width, screenSize.height)) / 500.0
            
            // Apply scale (adjust the divisor as needed)
            modelNode.scale = SCNVector3(scaleFactor, scaleFactor, scaleFactor)

            // Add the model to the scene
            scnView.scene?.rootNode.addChildNode(modelNode)

            // Configure the view
            scnView.allowsCameraControl = true
            scnView.autoenablesDefaultLighting = true
            scnView.backgroundColor = UIColor(hex: "#504645")

        } catch {
            print("Failed to load the 3D model: \(error)")
        }
    }
    
    
    deinit {
        if let modelURL = self.modelURL {
            try? FileManager.default.removeItem(at: modelURL)
        }
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
        addFurnitureToCatalogueToolBar.backgroundColor = UIColor(hex: "#4a4551").withAlphaComponent(0.8)
        addFurnitureToCatalogueToolBar.layer.cornerRadius = 10
        addFurnitureToCatalogueToolBar.isHidden = true

        let toolBarWidth = view.frame.width / 2.2
        let toolBarHeight = view.frame.height / 2 * 1.2
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
        crossButton.setTitle("×", for: .normal)
        crossButton.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        crossButton.tintColor = .white
        crossButton.frame = CGRect(x: 10, y: 10, width: 30, height: 30)
        crossButton.addTarget(self, action: #selector(toggleAddFurnitureToCatalogueToolBar), for: .touchUpInside)
        addFurnitureToCatalogueToolBar.addSubview(crossButton)

        // Add "Inventory" text
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

        showCategories()
    }

    private func showCategories() {
        // Clear existing content
        scrollView.subviews.forEach { $0.removeFromSuperview() }
        isShowingCategories = true
        
        let cardSize = CGSize(width: scrollView.frame.width - 20, height: 150)
        let spacing: CGFloat = 10
        var yOffset: CGFloat = 0

        for category in FurnitureCategoryType.allCases {
            let card = UIView()
            card.backgroundColor = .white
            card.layer.cornerRadius = 10
            card.frame = CGRect(x: 10, y: yOffset, width: cardSize.width, height: cardSize.height)
            
            // Make card tappable
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(categoryCardTapped(_:)))
            card.addGestureRecognizer(tapGesture)
            card.isUserInteractionEnabled = true
            card.tag = category.hashValue // Store category information
            
            // Add category image
            let imageView = UIImageView(image: UIImage(named: category.thumbnail))
            imageView.contentMode = .scaleAspectFit
            imageView.frame = CGRect(x: 10, y: 10, width: card.frame.width - 20, height: 100)
            card.addSubview(imageView)

            // Add category name
            let nameLabel = UILabel()
            nameLabel.text = category.rawValue
            nameLabel.textColor = .black
            nameLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            nameLabel.textAlignment = .center
            nameLabel.backgroundColor = UIColor(hex: "#F0F0F0")
            nameLabel.layer.cornerRadius = 5
            nameLabel.layer.masksToBounds = true
            nameLabel.frame = CGRect(x: 10, y: 120, width: card.frame.width - 20, height: 20)
            card.addSubview(nameLabel)

            scrollView.addSubview(card)
            yOffset += cardSize.height + spacing
        }

        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: yOffset)
    }

    private func showItemsForCategory(_ category: FurnitureCategoryType) {
        // Clear existing content
        scrollView.subviews.forEach { $0.removeFromSuperview() }
        isShowingCategories = false
        currentCategory = category

        // Add back button
        let backButton = UIButton(type: .system)
        backButton.setTitle("← Back", for: .normal)
        backButton.tintColor = .white
        backButton.frame = CGRect(x: 10, y: 10, width: 60, height: 30)
        backButton.addTarget(self, action: #selector(backToCategories), for: .touchUpInside)
        scrollView.addSubview(backButton)

        // Get items for the selected category
        let items = furnitureDataProvider.fetchFurnitureItems(for: category)
        
        let cardSize = CGSize(width: scrollView.frame.width - 20, height: 150)
        let spacing: CGFloat = 10
        var yOffset: CGFloat = 50 // Start below back button

        for item in items {
            let card = UIView()
            card.backgroundColor = .white
            card.layer.cornerRadius = 10
            card.frame = CGRect(x: 10, y: yOffset, width: cardSize.width, height: cardSize.height)

            // Add + button
            let addButton = UIButton(type: .system)
            addButton.setImage(UIImage(systemName: "plus"), for: .normal)
            addButton.tintColor = .white
            addButton.backgroundColor = UIColor(hex: "#393231")
            addButton.layer.cornerRadius = 15
            addButton.frame = CGRect(x: 10, y: 10, width: 30, height: 30)
            addButton.tag = item.id.hashValue
            addButton.addTarget(self, action: #selector(addItemButtonTapped(_:)), for: .touchUpInside)
            card.addSubview(addButton)

            // Add item image
            let imageView = UIImageView(image: item.image)
            imageView.contentMode = .scaleAspectFit
            imageView.frame = CGRect(x: 10, y: 50, width: card.frame.width - 20, height: 60)
            card.addSubview(imageView)

            // Add item name
            let nameLabel = UILabel()
            nameLabel.text = item.name
            nameLabel.textColor = .black
            nameLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            nameLabel.textAlignment = .center
            nameLabel.backgroundColor = UIColor(hex: "#F0F0F0")
            nameLabel.layer.cornerRadius = 5
            nameLabel.layer.masksToBounds = true
            nameLabel.layer.borderColor = UIColor.black.cgColor
            nameLabel.layer.borderWidth = 1
            nameLabel.frame = CGRect(x: 10, y: 120, width: card.frame.width - 20, height: 20)
            card.addSubview(nameLabel)

            scrollView.addSubview(card)
            yOffset += cardSize.height + spacing
        }

        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: yOffset)
    }

    @objc private func categoryCardTapped(_ gesture: UITapGestureRecognizer) {
        guard let card = gesture.view,
              let category = FurnitureCategoryType.allCases.first(where: { $0.hashValue == card.tag }) else {
            return
        }
        showItemsForCategory(category)
    }

    @objc private func backToCategories() {
        showCategories()
    }

    @objc private func addItemButtonTapped(_ sender: UIButton) {
        // Handle adding item to the 3D view
        print("Add item button tapped with tag: \(sender.tag)")
        // Implement your item adding logic here
    }

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
        button.setImage(UIImage(systemName: "arkit"), for: .normal)
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
        let largeCubeIcon = UIImage(systemName: "arkit", withConfiguration: largeConfig)
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
        guard let modelURL = self.modelURL else { return }

        let activityVC = UIActivityViewController(
            activityItems: [modelURL],
            applicationActivities: nil
        )

        if let popOver = activityVC.popoverPresentationController {
            popOver.sourceView = shareButton
        }

        present(activityVC, animated: true)
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
