import UIKit

struct GridItem {
    let id: String
    let title: String
    let image: UIImage?
    let description: String
}

struct HorizontalCardItem {
    let title: String
    let subtitle: String
    let color: UIColor
}

class HomeViewController: UIViewController {
    private let bottomSheetView = UIView()
    private let dragHandle = UIView()
    private let appBarStackView = UIStackView() // App bar for avatar and label
    private let avatarImageView = UIImageView()
    private let userNameLabel = UILabel()
    private let exploreLabel = UILabel()
    
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

    // Sample data for grid
    private var gridItems: [String] = Array(repeating: "Item", count: 20)
    
    // Sample data for horizontal cards
    private var horizontalCardItems: [HorizontalCardItem] = [
        HorizontalCardItem(title: "Sofa", subtitle: "", color: UIColor(red: 47/255, green: 47/255, blue: 47/255, alpha: 0.8)),
        HorizontalCardItem(title: "Bed", subtitle: "", color:UIColor(red: 47/255, green: 47/255, blue: 47/255, alpha: 0.8)),
        HorizontalCardItem(title: "Chair", subtitle: "", color: UIColor(red: 47/255, green: 47/255, blue: 47/255, alpha: 0.8)),
        HorizontalCardItem(title: "Dadi ji", subtitle: "", color: UIColor(red: 47/255, green: 47/255, blue: 47/255, alpha: 0.8))
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Create the gradient layer
        let gradientLayer = CAGradientLayer()
        
        // Set the gradient colors
        gradientLayer.colors = [
            UIColor(red: 135/255.0, green: 122/255.0, blue: 120/255.0, alpha: 1.0).cgColor,
            UIColor(red: 57/255.0, green:50/255.0, blue: 49/255.0, alpha: 1.0).cgColor,
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

        // Ensure horizontal scroll view is initially visible
        horizontalScrollView.isHidden = false
    }

    // MARK: - App Bar Setup
    private func setupAppBar() {
        appBarStackView.axis = .vertical
        appBarStackView.alignment = .leading
        appBarStackView.spacing = 8
        appBarStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(appBarStackView)

        // Avatar setup
        avatarImageView.image = UIImage(systemName: "person.circle")
        avatarImageView.tintColor = .white
        avatarImageView.contentMode = .scaleAspectFit
        avatarImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        avatarImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true

        // Create attributed text for userName
        let attributedUserName = NSMutableAttributedString(
            string: "Hi ",
            attributes: [
                .font: UIFont.systemFont(ofSize: 32, weight: .regular),
                .foregroundColor: UIColor.white
            ]
        )
        
        attributedUserName.append(NSAttributedString(
            string: "Aman",
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
            appBarStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            appBarStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            appBarStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    // MARK: - Horizontal Scroll View Setup
    private func setupHorizontalScrollView() {
        view.addSubview(horizontalScrollView)
        horizontalScrollView.addSubview(horizontalStackView)

        // Create and add card views
        for item in horizontalCardItems {
            let cardView = createHorizontalCardView(item: item)
            horizontalStackView.addArrangedSubview(cardView)
        }

        NSLayoutConstraint.activate([
            horizontalScrollView.topAnchor.constraint(equalTo: appBarStackView.bottomAnchor, constant: 20),
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
    private func createHorizontalCardView(item: HorizontalCardItem) -> UIView {
        let cardView = UIView()
        cardView.backgroundColor = item.color
        cardView.layer.cornerRadius = 40
        cardView.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.text = item.title
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let subtitleLabel = UILabel()
        subtitleLabel.text = item.subtitle
        subtitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .light)
        subtitleLabel.textColor = .white
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false

        cardView.addSubview(titleLabel)
        cardView.addSubview(subtitleLabel)

        NSLayoutConstraint.activate([
            cardView.widthAnchor.constraint(equalToConstant: 285),
            cardView.heightAnchor.constraint(equalToConstant: 190),

            titleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16)
        ])

        return cardView
    }

    // MARK: - Bottom Sheet Setup
    private func setupBottomSheet() {
        bottomSheetView.backgroundColor = .white
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

        bottomSheetTopConstraint = bottomSheetView.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -view.frame.height / 1.95)

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
        gridCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "GridCell")
        
        // Set delegate and data source
        gridCollectionView.delegate = self
        gridCollectionView.dataSource = self

        NSLayoutConstraint.activate([
            gridCollectionView.topAnchor.constraint(equalTo: topSegmentedControl.bottomAnchor, constant: 16),
            gridCollectionView.leadingAnchor.constraint(equalTo: bottomSheetView.leadingAnchor, constant: 16),
            gridCollectionView.trailingAnchor.constraint(equalTo: bottomSheetView.trailingAnchor, constant: -16),
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
                string: "Aman",
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
}

// MARK: - UICollectionView Delegate & Data Source
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gridItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridCell", for: indexPath)
        cell.backgroundColor = .systemBrown.withAlphaComponent(0.2)
        cell.layer.cornerRadius = 10
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 32) / 1.9 // 2 columns with some spacing
        return CGSize(width: width, height: width) // Rectangular cells
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2 // Horizontal spacing between items
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16 // Vertical spacing between rows
    }
}

