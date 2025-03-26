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
        // Create the gradient layer
        let gradientLayer = CAGradientLayer()

        // Set the gradient colors
        gradientLayer.colors = [
            UIColor(red: 135/255.0, green: 122/255.0, blue: 120/255.0, alpha: 1.0).cgColor,
            UIColor(red: 57/255.0, green: 50/255.0, blue: 49/255.0, alpha: 1.0).cgColor,
        ]

        // Set the gradient locations (optional)
        gradientLayer.locations = [0.0, 1.0] // Start and end points (0% to 100%)

        // Set the start and end points for gradient direction
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0) // Top-left
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0) // Bottom-right

        // Set the frame of the gradient to match the view
        gradientLayer.frame = view.bounds

        // Add the gradient layer to the view's layer
        view.layer.insertSublayer(gradientLayer, at: 0)

        setupAppBar()
        setupHorizontalScrollView()
        setupBottomSheet()
        setupPanGesture()
        setupGridCollectionView()
        setupSegmentedControl()

        // Ensure horizontal scroll view is initially visible
        horizontalScrollView.isHidden = false

        navigationController?.navigationBar.isTranslucent = false
           self.edgesForExtendedLayout = []
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Hide the navigation bar for this view
        navigationController?.setNavigationBarHidden(true, animated: false)

        // Ensure proper layout by removing extra space
        navigationController?.navigationBar.isTranslucent = false
        self.extendedLayoutIncludesOpaqueBars = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Restore the navigation bar for other views
        navigationController?.setNavigationBarHidden(false, animated: false)
    }


    private func setupAppBar() {
        appBarStackView.axis = .vertical
        appBarStackView.alignment = .leading
        appBarStackView.spacing = 8
        appBarStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(appBarStackView)

        // Avatar setup
        avatarImageView.image = UIImage(named: "ProfileImage") // Set image to "ProfileImage"
        avatarImageView.tintColor = .white
        avatarImageView.contentMode = .scaleAspectFill // Use scaleAspectFill to fill the rounded view
        avatarImageView.clipsToBounds = true // Ensure the image stays within the rounded bounds
        avatarImageView.layer.cornerRadius = 25 // Half of the height to make it rounded
        avatarImageView.layer.masksToBounds = true // Apply corner radius to the image

        // Set a smaller size for the avatar image view
        avatarImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        avatarImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true

        // Create attributed text for userName
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

        // Title label setup
        userNameLabel.attributedText = attributedUserName
        userNameLabel.numberOfLines = 1

        // Explore label setup
        exploreLabel.text = "Explore something new"
        exploreLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        exploreLabel.textColor = .white
        exploreLabel.alpha = 1 // Initially hidden for animation
        exploreLabel.numberOfLines = 1

        // Add avatar and labels to the stack view
        appBarStackView.addArrangedSubview(avatarImageView)
        appBarStackView.addArrangedSubview(userNameLabel)
        appBarStackView.addArrangedSubview(exploreLabel)

        NSLayoutConstraint.activate([
            appBarStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2),
            appBarStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            appBarStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60)
        ])
    }

    // MARK: - Horizontal Scroll View Setup
    private func setupHorizontalScrollView() {
        view.addSubview(horizontalScrollView)
        
        horizontalScrollView.addSubview(horizontalStackView)
        for (index, item) in adCards.enumerated() {
            let cardView = createHorizontalCardView(item: item, backgroundImageName: "Ad Cards\(index + 1)", labelText: item.name)
            horizontalStackView.addArrangedSubview(cardView)
        }

        NSLayoutConstraint.activate([
            horizontalScrollView.topAnchor.constraint(equalTo: appBarStackView.bottomAnchor, constant: 10),
            horizontalScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            horizontalScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            horizontalScrollView.heightAnchor.constraint(equalToConstant: 190),

            horizontalStackView.topAnchor.constraint(equalTo: horizontalScrollView.topAnchor),
            horizontalStackView.leadingAnchor.constraint(equalTo: horizontalScrollView.leadingAnchor, constant: 16),
            horizontalStackView.trailingAnchor.constraint(equalTo: horizontalScrollView.trailingAnchor, constant: -16),
            horizontalStackView.bottomAnchor.constraint(equalTo: horizontalScrollView.bottomAnchor)
        ])
    }

    // MARK: - Create Horizontal Card View
    private func createHorizontalCardView(item: FurnitureItem, backgroundImageName: String, labelText: String) -> UIView {
        let cardView = UIView()
        cardView.layer.cornerRadius = 30
        cardView.clipsToBounds = true
        cardView.translatesAutoresizingMaskIntoConstraints = false

        // Add background image
        let backgroundImageView = UIImageView(image: UIImage(named: backgroundImageName))
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.clipsToBounds = true
        backgroundImageView.layer.cornerRadius = 30
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.alpha = 0.90 // Set opacity to 90%
        cardView.addSubview(backgroundImageView)

        // Add semi-transparent black overlay
        let overlayView = UIView()
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(overlayView)

        // Add furniture image
        let furnitureImageView = UIImageView(image: item.image)
        furnitureImageView.contentMode = .scaleAspectFit
        furnitureImageView.clipsToBounds = true
        furnitureImageView.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(furnitureImageView)

        // Add text label at the bottom right
        let textLabel = UILabel()
        textLabel.text = labelText
        textLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        textLabel.textColor = .white // Changed to white for better visibility
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(textLabel)

        // Add image button at the top left corner
        let imageButton = UIButton(type: .custom)
        imageButton.translatesAutoresizingMaskIntoConstraints = false

        // Configure the button using UIButtonConfiguration
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "arkit")?.withTintColor(.white.withAlphaComponent(0.95), renderingMode: .alwaysOriginal)
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        imageButton.configuration = config

        imageButton.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        imageButton.layer.cornerRadius = 20
        imageButton.clipsToBounds = true

        cardView.addSubview(imageButton)

        NSLayoutConstraint.activate([
            cardView.widthAnchor.constraint(equalToConstant: 285),
            cardView.heightAnchor.constraint(equalToConstant: 190),

            // Background image constraints
            backgroundImageView.topAnchor.constraint(equalTo: cardView.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor),

            // Overlay constraints
            overlayView.topAnchor.constraint(equalTo: cardView.topAnchor),
            overlayView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            overlayView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor),

            // Furniture image constraints - larger size and overflow effect
            furnitureImageView.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            furnitureImageView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor),
            furnitureImageView.widthAnchor.constraint(equalTo: cardView.widthAnchor, multiplier: 1.1), // 110% of card width
            furnitureImageView.heightAnchor.constraint(equalTo: cardView.heightAnchor, multiplier: 1.1), // 110% of card height

            // Text label constraints
            textLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            textLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16),

            // Image button constraints
            imageButton.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            imageButton.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            imageButton.widthAnchor.constraint(equalToConstant: 40),
            imageButton.heightAnchor.constraint(equalToConstant: 40)
        ])

        return cardView
    }
    // MARK: - Bottom Sheet Setup
    private func setupBottomSheet() {
        // Set the background color of the bottom sheet to #D9D9D9
        bottomSheetView.backgroundColor = UIColor(red: 217/255.0, green: 217/255.0, blue: 217/255.0, alpha: 1.0) // #D9D9D9
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

        // Register cell
        gridCollectionView.register(RoomCardCell.self, forCellWithReuseIdentifier: RoomCardCell.reuseIdentifier)
        gridCollectionView.register(CatalogueCardCell.self, forCellWithReuseIdentifier: CatalogueCardCell.reuseIdentifier)

        // Set delegate and data source
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

            // Dynamically update the app bar layout during dragging
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
            self.appBarStackView.spacing = isExpanded ? 16 : 8
            self.appBarStackView.alignment = isExpanded ? .fill : .leading

            // Update font sizes for expanded/collapsed states
            let userNameText = NSMutableAttributedString(
                string: "Hi ",
                attributes: [
                    .font: isExpanded
                        ? UIFont.systemFont(ofSize: 16, weight: .thin) // Smaller font when expanded
                        : UIFont.systemFont(ofSize: 32, weight: .thin), // Original font size when collapsed
                    .foregroundColor: UIColor.white
                ]
            )

            userNameText.append(NSAttributedString(
                string: User1.name,
                attributes: [
                    .font: isExpanded
                        ? UIFont.systemFont(ofSize: 16, weight: .semibold) // Smaller font when expanded
                        : UIFont.systemFont(ofSize: 32, weight: .bold), // Original font size when collapsed
                    .foregroundColor: UIColor.white
                ]
            ))

            self.userNameLabel.attributedText = userNameText

            // Update explore label font
            self.exploreLabel.font = isExpanded
                ? UIFont.systemFont(ofSize: 16, weight: .thin) // Smaller font when expanded
                : UIFont.systemFont(ofSize: 16, weight: .regular) // Original font size when collapsed

            // Hide or show the horizontal scroll view
            self.horizontalScrollView.isHidden = isExpanded
        }
    }

    // MARK: - Segmented Control Setup
    private func setupSegmentedControl() {
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
        return 10 // Minimal horizontal spacing between items
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10 // Minimal vertical spacing between rows
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(topSegmentedControl.selectedSegmentIndex==0){
            print("Item selected at indexPath: \(indexPath)")
            let selectedCategoryType = roomCategories[indexPath.item]
                   print("Selected category: \(selectedCategoryType.rawValue)")
                   guard let roomCategory = RoomDataProvider.shared.roomCategories.first(where: { $0.category == selectedCategoryType }) else {
                       print("Error: No matching RoomCategory found for \(selectedCategoryType.rawValue)")
                       return
                   }

                   let storyboard = UIStoryboard(name: "RoomScreen", bundle: nil)
                   if let destinationVC = storyboard.instantiateViewController(withIdentifier: "RoomScreenVC") as? RoomsCollectionViewController {
                       destinationVC.roomCategory = roomCategory
                       print("Passing roomCategory: \(roomCategory.category.rawValue)")
                navigationController?.pushViewController(destinationVC, animated: true)}
        }else{
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
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
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
        // Add image view
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        // Add room name label
        addSubview(roomNameLabel)
        roomNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            roomNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            roomNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            roomNameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }

    func configure(with category: RoomCategoryType) {
        imageView.image = UIImage(named: category.thumbnail)
        roomNameLabel.text = category.rawValue
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
