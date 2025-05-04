import UIKit

class HomeViewController: UIViewController {
    private let bottomSheetView = UIView()
    private let dragHandle = UIView()
    private let appBarStackView = UIStackView() // App bar for avatar and label
    private let avatarImageView = UIImageView()
    private let userNameLabel = UILabel()
    private let exploreLabel = UILabel()

    private let roomCategories = RoomCategoryType.allCases
    private let furnitureCategories = FurnitureCategoryType.allCases

    // Horizontal Scroll View
    private let horizontalScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private let horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    // New collection view and segmented controls
    private let topSegmentedControl = UISegmentedControl(items: ["My Spaces", "Catalogue"])
    private let gridCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        return collectionView
    }()

    private var bottomSheetTopConstraint: NSLayoutConstraint!
    private var isBottomSheetExpanded: Bool = false

    private enum BottomSheetPosition {
        case half, expanded
    }

    private let collapsedHeight: CGFloat = 100
    private let expandedHeightMultiplier: CGFloat = 0.85

    override func viewDidLoad() {
        super.viewDidLoad()
        let gradientLayer = CAGradientLayer()

        gradientLayer.colors = [
//            UIColor(red: 135/255.0, green: 122/255.0, blue: 120/255.0, alpha: 1.0).cgColor,
//            UIColor(red: 57/255.0, green: 50/255.0, blue: 49/255.0, alpha: 1.0).cgColor,
            UIColor.gradientStartColor.cgColor,
            UIColor.gradientEndColor.cgColor
        ]

        gradientLayer.locations = [0.0, 1.0] // Start and end points (0% to 100%)

        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0) // Top-left
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0) // Bottom-right

        gradientLayer.frame = view.bounds

        view.layer.insertSublayer(gradientLayer, at: 0)

        setupAppBar()
        setupHorizontalScrollView()
        setupBottomSheet()
        setupPanGesture()
        setupGridCollectionView()
        setupSegmentedControl()

        horizontalScrollView.isHidden = false

        navigationController?.navigationBar.isTranslucent = false
           self.edgesForExtendedLayout = []
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: false)

        navigationController?.navigationBar.isTranslucent = false
        self.extendedLayoutIncludesOpaqueBars = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        navigationController?.setNavigationBarHidden(false, animated: false)
    }


    private func setupAppBar() {
        appBarStackView.axis = .vertical
        appBarStackView.alignment = .leading
        appBarStackView.spacing = 8
        appBarStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(appBarStackView)

        // Avatar setup
        avatarImageView.image = UIImage(named: "profileImage")
        avatarImageView.tintColor = .white
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true
        
        // Create circular border with spacing
        avatarImageView.layer.cornerRadius = 30 // Match half of the width/height
        avatarImageView.layer.borderWidth = 2.0
        avatarImageView.layer.borderColor = UIColor.white.cgColor
        
        // Add outer spacing with a container view
        let avatarContainerView = UIView()
        avatarContainerView.translatesAutoresizingMaskIntoConstraints = false
        avatarContainerView.backgroundColor = UIColor.clear
        avatarContainerView.layer.cornerRadius = 34 // Slightly larger than avatar
        avatarContainerView.layer.borderWidth = 1.5
        avatarContainerView.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
        view.addSubview(avatarContainerView)
        
        avatarImageView.layer.masksToBounds = true
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add avatar to container
        avatarContainerView.addSubview(avatarImageView)

        avatarImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        avatarImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        // Add avatar directly to view instead of stack view
        view.addSubview(avatarImageView)

        let attributedUserName = NSMutableAttributedString(
            string: "Hi ",
            attributes: [
                .font: UIFont.systemFont(ofSize: 32, weight: .regular),
                .foregroundColor: UIColor.white
            ]
        )

        attributedUserName.append(NSAttributedString(
            string: User1.name,
            attributes: [
                .font: UIFont.systemFont(ofSize: 32, weight: .bold),
                .foregroundColor: UIColor.white
            ]
        ))

        userNameLabel.attributedText = attributedUserName
        userNameLabel.numberOfLines = 1

        exploreLabel.text = "Explore something new"
        exploreLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        exploreLabel.textColor = .white
        exploreLabel.alpha = 1
        exploreLabel.numberOfLines = 1

        // Remove avatar from stack view
        appBarStackView.addArrangedSubview(userNameLabel)
        appBarStackView.addArrangedSubview(exploreLabel)

        NSLayoutConstraint.activate([
            appBarStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            appBarStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            appBarStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),
            
            // Position avatar on the right side
            avatarImageView.centerYAnchor.constraint(equalTo: appBarStackView.topAnchor, constant: 30),
            avatarImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -45)
        ])
    }

//    // MARK: - Horizontal Scroll View Setup
    private func setupHorizontalScrollView() {
       view.addSubview(horizontalScrollView)
       
       horizontalScrollView.addSubview(horizontalStackView)

       let allCategories = FurnitureDataProvider.shared.getFurnitureCategories()
           let topItems = allCategories.flatMap { $0.furnitureItems }.prefix(4)
           
           for (index, item) in topItems.enumerated() {
               let cardView = createHorizontalCardView(item: item, backgroundImageName: "Ad Cards\(index+1)", labelText: item.name)
               horizontalStackView.addArrangedSubview(cardView)
           }

       NSLayoutConstraint.activate([
           horizontalScrollView.topAnchor.constraint(equalTo: appBarStackView.bottomAnchor, constant: 30), // Increased from 10 to 16 for better spacing
           horizontalScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
           horizontalScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
           horizontalScrollView.heightAnchor.constraint(equalToConstant: 210),
           horizontalStackView.topAnchor.constraint(equalTo: horizontalScrollView.topAnchor),
           horizontalStackView.leadingAnchor.constraint(equalTo: horizontalScrollView.leadingAnchor, constant: 16),
           horizontalStackView.trailingAnchor.constraint(equalTo: horizontalScrollView.trailingAnchor, constant: -16),
           horizontalStackView.bottomAnchor.constraint(equalTo: horizontalScrollView.bottomAnchor)
       ])
   }

//    // MARK: - Create Horizontal Card View
    private func createHorizontalCardView(item: FurnitureItem, backgroundImageName: String, labelText: String) -> UIView {
        
        let cardView = UIView()
        cardView.layer.cornerRadius = 30
        cardView.clipsToBounds = true
        cardView.translatesAutoresizingMaskIntoConstraints = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(horizontalCardTapped(_:)))
        cardView.addGestureRecognizer(tapGesture)
        cardView.isUserInteractionEnabled = true

        // Store the furniture item's name as identifier
        cardView.accessibilityIdentifier = item.name
        
        let backgroundImageView = UIImageView(image: UIImage(named: backgroundImageName))
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.clipsToBounds = true
        backgroundImageView.layer.cornerRadius = 30
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.alpha = 0.90 // Set opacity to 90%
        cardView.addSubview(backgroundImageView)

        let furnitureImageView = UIImageView(image: item.image)
        furnitureImageView.contentMode = .scaleAspectFit
        furnitureImageView.clipsToBounds = true
        furnitureImageView.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(furnitureImageView)

        let textLabel = UILabel()
        textLabel.text = labelText
        textLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        textLabel.textColor = .black
        textLabel.textAlignment = .left
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(textLabel)

        let imageButton = UIButton(type: .custom)
        imageButton.translatesAutoresizingMaskIntoConstraints = false

        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "arkit")?.withTintColor(.white.withAlphaComponent(0.95), renderingMode: .alwaysOriginal)
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        imageButton.configuration = config

        imageButton.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        imageButton.layer.cornerRadius = 20
        imageButton.clipsToBounds = true
        
        // Add target-action for the ARKit button
        imageButton.addTarget(self, action: #selector(arButtonTapped(_:)), for: .touchUpInside)
        // Store the furniture item's name in the button's accessibilityIdentifier for reference
        imageButton.accessibilityIdentifier = item.name

        cardView.addSubview(imageButton)

        NSLayoutConstraint.activate([
            cardView.widthAnchor.constraint(equalToConstant: 300),
            cardView.heightAnchor.constraint(equalToConstant: 200),

            // Background image constraints
            backgroundImageView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 20),
            backgroundImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor),

            //furnitureImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 50), // shift right
            furnitureImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: 5),
            furnitureImageView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16),  // move upward from bottom
            furnitureImageView.widthAnchor.constraint(equalTo: cardView.widthAnchor, multiplier: 0.85), // narrower
            furnitureImageView.heightAnchor.constraint(equalTo: cardView.heightAnchor, multiplier: 1.0),  // taller, allows overflow from top


            // Text label constraints
            textLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            textLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16),

            // Image button constraints
            imageButton.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 24),
            imageButton.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            imageButton.widthAnchor.constraint(equalToConstant: 40),
            imageButton.heightAnchor.constraint(equalToConstant: 40)
        ])

        return cardView
    }
    
    @objc private func horizontalCardTapped(_ gesture: UITapGestureRecognizer) {
        guard let cardView = gesture.view,
              let itemName = cardView.accessibilityIdentifier else { return }
        
        let allCategories = FurnitureDataProvider.shared.getFurnitureCategories()
        let allItems = allCategories.flatMap { $0.furnitureItems }
        
        guard let tappedItem = allItems.first(where: { $0.name == itemName }) else { return }
        
        let storyboard = UIStoryboard(name: "ProductDisplay", bundle: nil)
        if let destinationVC = storyboard.instantiateViewController(withIdentifier: "ProductInfoTableViewController") as? ProductInfoTableViewController {
            destinationVC.furnitureItem = tappedItem
            destinationVC.modalPresentationStyle = .fullScreen
            present(destinationVC, animated: true)
        }
    }
    
    @objc private func arButtonTapped(_ sender: UIButton) {
        guard let itemName = sender.accessibilityIdentifier else {
            print("Error: Could not retrieve furniture item name")
            return
        }
        
        let allCategories = FurnitureDataProvider.shared.getFurnitureCategories()
        let allItems = allCategories.flatMap { $0.furnitureItems }
        
        guard let furnitureItem = allItems.first(where: { $0.name == itemName }) else {
            print("Error: Furniture item \(itemName) not found")
            return
        }
        
        ARViewPresenter.presentARView(for: furnitureItem, allowBrowse: false, from: self)
    }
    
    // MARK: - Bottom Sheet Setup
    private func setupBottomSheet() {
        bottomSheetView.backgroundColor = .solidBackgroundColor // #D9D9D9
        bottomSheetView.layer.cornerRadius = 40
        bottomSheetView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        bottomSheetView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomSheetView)

        dragHandle.backgroundColor = .lightGray
        dragHandle.layer.cornerRadius = 3
        dragHandle.translatesAutoresizingMaskIntoConstraints = false
        bottomSheetView.addSubview(dragHandle)

        // Setup Segmented Controls
        topSegmentedControl.selectedSegmentIndex = 0
        topSegmentedControl.backgroundColor = UIColor(red: 57/255.0, green: 50/255.0, blue: 49/255.0, alpha: 1.0)

        topSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white
        ]
        let activeAttribute: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(red: 31/255.0, green: 29/255.0, blue: 29/255.0, alpha: 1.0)
        ]
        topSegmentedControl.setTitleTextAttributes(normalAttributes, for: .normal)
        topSegmentedControl.setTitleTextAttributes(activeAttribute, for: .selected)
        bottomSheetView.addSubview(topSegmentedControl)

        bottomSheetTopConstraint = bottomSheetView.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -view.frame.height / 2.2)

        NSLayoutConstraint.activate([
            bottomSheetTopConstraint,
            bottomSheetView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomSheetView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomSheetView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            dragHandle.centerXAnchor.constraint(equalTo: bottomSheetView.centerXAnchor),
            dragHandle.topAnchor.constraint(equalTo: bottomSheetView.topAnchor, constant: 10),
            dragHandle.widthAnchor.constraint(equalToConstant: 60),
            dragHandle.heightAnchor.constraint(equalToConstant: 6),

            topSegmentedControl.topAnchor.constraint(equalTo: dragHandle.bottomAnchor, constant: 16),
            topSegmentedControl.leadingAnchor.constraint(equalTo: bottomSheetView.leadingAnchor, constant: 16),
            topSegmentedControl.trailingAnchor.constraint(equalTo: bottomSheetView.trailingAnchor, constant: -16)
        ])
    }

    // MARK: - Grid Collection View Setup
    private func setupGridCollectionView() {
        gridCollectionView.translatesAutoresizingMaskIntoConstraints = false
        bottomSheetView.addSubview(gridCollectionView)

        gridCollectionView.register(RoomCardCell.self, forCellWithReuseIdentifier: RoomCardCell.reuseIdentifier)
        gridCollectionView.register(CatalogueCardCell.self, forCellWithReuseIdentifier: CatalogueCardCell.reuseIdentifier)

        gridCollectionView.delegate = self
        gridCollectionView.dataSource = self

        NSLayoutConstraint.activate([
            gridCollectionView.topAnchor.constraint(equalTo: topSegmentedControl.bottomAnchor, constant: 16),
            gridCollectionView.leadingAnchor.constraint(equalTo: bottomSheetView.leadingAnchor, constant: 8), // Reduced leading space
            gridCollectionView.trailingAnchor.constraint(equalTo: bottomSheetView.trailingAnchor, constant: -8), // Reduced trailing space
            gridCollectionView.bottomAnchor.constraint(equalTo: bottomSheetView.bottomAnchor, constant: -16)
        ])
    }

    private func setupPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        bottomSheetView.addGestureRecognizer(panGesture)
    }

    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let velocity = gesture.velocity(in: view)
        let maxSheetHeight = view.frame.height * expandedHeightMultiplier

        if gesture.state == .changed {
            let newTopConstant = bottomSheetTopConstraint.constant + translation.y
            bottomSheetTopConstraint.constant = max(-maxSheetHeight, min(newTopConstant, -view.frame.height / 2))
            gesture.setTranslation(.zero, in: view)

            let isExpanded = bottomSheetTopConstraint.constant == -(view.frame.height * expandedHeightMultiplier)
            updateAppBarLayout(isExpanded: isExpanded)
        }

        if gesture.state == .ended {
            let snapPosition: BottomSheetPosition = velocity.y < -500 ? .expanded : .half
            animateBottomSheet(to: snapPosition)
        }
    }

    private func animateBottomSheet(to position: BottomSheetPosition) {
        let maxSheetHeight = view.frame.height * expandedHeightMultiplier
        bottomSheetTopConstraint.constant = position == .expanded ? -maxSheetHeight : -view.frame.height / 2

        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut], animations: {
            self.view.layoutIfNeeded()
            self.updateAppBarLayout(isExpanded: position == .expanded)
        })
    }

    // MARK: - Update App Bar Layout
    private func updateAppBarLayout(isExpanded: Bool) {
        UIView.animate(withDuration: 0.3) {
            // Animate stack view
            self.appBarStackView.axis = isExpanded ? .horizontal : .vertical
            self.appBarStackView.spacing = isExpanded ? 4 : 8
            self.appBarStackView.alignment = isExpanded ? .fill : .leading

            let userNameText = NSMutableAttributedString(
                string: "Hi ",
                attributes: [
                    .font: isExpanded
                        ? UIFont.systemFont(ofSize: 16, weight: .thin)
                        : UIFont.systemFont(ofSize: 32, weight: .thin),
                    .foregroundColor: UIColor.white
                ]
            )

            userNameText.append(NSAttributedString(
                string: User1.name,
                attributes: [
                    .font: isExpanded
                        ? UIFont.systemFont(ofSize: 16, weight: .semibold)
                        : UIFont.systemFont(ofSize: 32, weight: .bold),
                    .foregroundColor: UIColor.white
                ]
            ))

            self.userNameLabel.attributedText = userNameText

            self.exploreLabel.font = isExpanded
                ? UIFont.systemFont(ofSize: 16, weight: .thin) // Smaller font when expanded
                : UIFont.systemFont(ofSize: 16, weight: .regular) // Original font size when collapsed

            self.horizontalScrollView.isHidden = isExpanded
            
            // Adjust avatar visibility when expanded
            self.avatarImageView.isHidden = isExpanded ? true : false
//            self.avatarImageView.alpha = isExpanded ? 0.7 : 1.0
        }
    }

    // MARK: - Segmented Control Setup
    private func setupSegmentedControl() {
        topSegmentedControl.selectedSegmentTintColor = .white
        topSegmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
        topSegmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        topSegmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
    }

    @objc private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        let direction: CATransitionSubtype = sender.selectedSegmentIndex == 0 ? .fromLeft : .fromRight
        let transition = CATransition()
        transition.type = .push
        transition.subtype = direction
        transition.duration = 0.3
        gridCollectionView.layer.add(transition, forKey: nil)
        gridCollectionView.reloadData()
    }
}

// MARK: - UICollectionView Delegate & Data Source
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topSegmentedControl.selectedSegmentIndex == 0 ? roomCategories.count : furnitureCategories.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if topSegmentedControl.selectedSegmentIndex == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RoomCardCell.reuseIdentifier, for: indexPath) as! RoomCardCell
            cell.configure(with: roomCategories[indexPath.item])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CatalogueCardCell.reuseIdentifier, for: indexPath) as! CatalogueCardCell
            cell.configure(with: furnitureCategories[indexPath.item])
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 10 // Minimal horizontal and vertical spacing
        let numberOfColumns: CGFloat = 2 // Two columns for both sections
        let totalSpacing = (numberOfColumns - 1) * spacing
        let width = (collectionView.bounds.width - totalSpacing) / numberOfColumns // Adjusted for leading/trailing padding
        return CGSize(width: width, height: width) // Square cards
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(topSegmentedControl.selectedSegmentIndex==0){
            print("Item selected at indexPath: \(indexPath)")
            let selectedCategoryType = roomCategories[indexPath.item]
            print("Selected category: \(selectedCategoryType.rawValue)")
            
            let roomCount = RoomDataProvider.shared.getRooms(for: selectedCategoryType).count
            
           guard let roomCategory = RoomDataProvider.shared.roomCategories.first(where: { $0.category == selectedCategoryType }) else {
               print("Error: No matching RoomCategory found for \(selectedCategoryType.rawValue)")
               return
           }

           let storyboard = UIStoryboard(name: "RoomScreen", bundle: nil)
           if let destinationVC = storyboard.instantiateViewController(withIdentifier: "RoomScreenVC") as? RoomsCollectionViewController {
               destinationVC.roomCategory = roomCategory
               print("Passing roomCategory: \(roomCategory.category.rawValue)")
               navigationController?.pushViewController(destinationVC, animated: true)}
        } else {
            //Catalouge Card
            let storyboard = UIStoryboard(name: "ProductDisplay", bundle: nil)
            if let destinationVC = storyboard.instantiateViewController(withIdentifier: "MainCollectionViewController") as? mainCollectionViewController {
                let selectedCategoryType = furnitureCategories[indexPath.item] // FurnitureCategoryType
                let furnitureItems = FurnitureDataProvider.shared.fetchFurnitureItems(for: selectedCategoryType)
                let furnitureCategory = FurnitureCategory(category: selectedCategoryType, furnitureItems: furnitureItems)
                destinationVC.furnitureCategory = furnitureCategory
                navigationController?.pushViewController(destinationVC, animated: true)}
        }
    }
}

// MARK: - Custom Room Card Cell
class RoomCardCell: UICollectionViewCell {
    static let reuseIdentifier = "RoomCardCell"
    private let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    
    private let countLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
            label.textColor = .white
            label.textAlignment = .center
            label.backgroundColor = .brown
            label.layer.cornerRadius = 12
            label.layer.masksToBounds = true
            return label
        }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner] // All corners rounded
        return imageView
    }()

    private let roomNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupBlurEffect()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        // Add image view
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        // Add blur effect view (before the label)
        addSubview(blurEffectView)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            blurEffectView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: bottomAnchor),
            blurEffectView.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        blurEffectView.layer.cornerRadius = 12
        blurEffectView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        blurEffectView.clipsToBounds = true
        blurEffectView.alpha = 0.8

        // Add room name label inside the blurEffectView
        blurEffectView.contentView.addSubview(roomNameLabel)
        roomNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            roomNameLabel.leadingAnchor.constraint(equalTo: blurEffectView.contentView.leadingAnchor, constant: 8),
            roomNameLabel.trailingAnchor.constraint(equalTo: blurEffectView.contentView.trailingAnchor, constant: -8),
            roomNameLabel.centerYAnchor.constraint(equalTo: blurEffectView.contentView.centerYAnchor)
        ])

        // Add count label (still on top of image view directly)
        addSubview(countLabel)
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            countLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            countLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            countLabel.widthAnchor.constraint(equalToConstant: 24),
            countLabel.heightAnchor.constraint(equalToConstant: 24)
        ])
    }

    private func setupBlurEffect() {
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(blurEffectView)
        
        NSLayoutConstraint.activate([
            blurEffectView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            blurEffectView.heightAnchor.constraint(equalToConstant: 40) // Only small strip below the text
        ])
        
        blurEffectView.layer.cornerRadius = 12
        blurEffectView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        blurEffectView.clipsToBounds = true
        blurEffectView.alpha = 0.8 // Optional: make blur semi-transparent
    }

    func configure(with category: RoomCategoryType) {
        imageView.image = UIImage(named: category.thumbnail)
        roomNameLabel.text = category.rawValue


        // Get room count for this category
        let roomCount = RoomDataProvider.shared.getRooms(for: category).count
        countLabel.text = "\(roomCount)"
        
        // Update cell appearance based on room count
//        isUserInteractionEnabled = roomCount > 0
        alpha = roomCount > 0 ? 1.0 : 0.6

    }
}

// MARK: - Custom Catalogue Card Cell
class CatalogueCardCell: UICollectionViewCell {
    static let reuseIdentifier = "CatalogueCardCell"

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit // Changed to scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner] // Only top corners rounded
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = UIColor(red: 57/255.0, green: 50/255.0, blue: 49/255.0, alpha: 1.0) // #393231
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        // Set background color of the cell to white
        backgroundColor = .white
        layer.cornerRadius = 10
        layer.masksToBounds = true

        // Add image view
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 8), // Add padding on top
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8), // Add padding on leading
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8), // Add padding on trailing
            imageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.6) // Image takes 60% of the cell height
        ])

        // Add title label
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8), // Add padding between image and label
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8) // Add padding on bottom
        ])
    }

    func configure(with category: FurnitureCategoryType) {
        imageView.image = UIImage(named: category.thumbnail)
        titleLabel.text = category.rawValue
    }
}
