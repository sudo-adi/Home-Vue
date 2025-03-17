// import UIKit

// class VirtualObjectSelectionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

// 	private var tableView: UITableView!
// 	private var size: CGSize!
// 	weak var delegate: VirtualObjectSelectionViewControllerDelegate?
// 	private var virtualObjects: [VirtualObject] = []

//     init(size: CGSize) {
//         super.init(nibName: nil, bundle: nil)
//         self.size = size
//         setupVirtualObjects()
//     }
    
//     private func setupVirtualObjects() {
//         virtualObjects = [
//             GenericVirtualObject(modelName: "candle", thumbnailName: "candle", particleSize: 0.018),
//             GenericVirtualObject(modelName: "cup", thumbnailName: "cup"),
//             GenericVirtualObject(modelName: "vase", thumbnailName: "vase"),
//             GenericVirtualObject(modelName: "lamp", thumbnailName: "lamp"),
//             GenericVirtualObject(modelName: "chair", thumbnailName: "chair"),
//             GenericVirtualObject(modelName: "sofa", thumbnailName: "sofa", initialScale: SCNVector3(0.1, 0.1, 0.1))
//         ]
//     }


// 	// init(size: CGSize) {
// 	// 	super.init(nibName: nil, bundle: nil)
// 	// 	self.size = size
// 	// }

// 	required init?(coder aDecoder: NSCoder) {
// 		fatalError("init(coder:) has not been implemented")
// 	}

// 	override func viewDidLoad() {
// 		super.viewDidLoad()

// 		tableView = UITableView()
// 		tableView.frame = CGRect(origin: CGPoint.zero, size: self.size)
// 		tableView.dataSource = self
// 		tableView.delegate = self
// 		tableView.backgroundColor = UIColor.clear
// 		tableView.separatorEffect = UIVibrancyEffect(blurEffect: UIBlurEffect(style: .light))
// 		tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
// 		tableView.bounces = false

// 		self.preferredContentSize = self.size

// 		self.view.addSubview(tableView)
// 	}

// 	func getObject(index: Int) -> VirtualObject {
//         return virtualObjects[index]
//     }

// 	// func getObject(index: Int) -> VirtualObject {
// 	// 	switch index {
// 	// 	case 0:
// 	// 		return Candle()
// 	// 	case 1:
// 	// 		return Cup()
// 	// 	case 2:
// 	// 		return Vase()
// 	// 	case 3:
// 	// 		return Lamp()
// 	// 	case 4:
// 	// 		return Chair()
//     //     case 5:
//     //         return Sofa()
// 	// 	default:
// 	// 		return Cup()
// 	// 	}
// 	// }

// 	static let COUNT_OBJECTS = 6

// 	// MARK: - UITableViewDelegate
// 	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
// 		delegate?.virtualObjectSelectionViewController(self, object: getObject(index: indexPath.row))
// 		self.dismiss(animated: true, completion: nil)
// 	}

// 	// MARK: - UITableViewDataSource
// 	// func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
// 	// 	return VirtualObjectSelectionViewController.COUNT_OBJECTS
// 	// }
// 	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//         return virtualObjects.count
//     }

// 	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
// 		let cell = UITableViewCell()
// 		let label = UILabel(frame: CGRect(x: 53, y: 10, width: 200, height: 30))
// 		let icon = UIImageView(frame: CGRect(x: 15, y: 10, width: 30, height: 30))

// 		cell.backgroundColor = UIColor.clear
// 		cell.selectionStyle = .none
// 		let vibrancyEffect = UIVibrancyEffect(blurEffect: UIBlurEffect(style: .extraLight))
// 		let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
// 		vibrancyView.frame = cell.contentView.frame
// 		cell.contentView.insertSubview(vibrancyView, at: 0)
// 		vibrancyView.contentView.addSubview(label)
// 		vibrancyView.contentView.addSubview(icon)

// 		// Fill up the cell with data from the object.
// 		let object = getObject(index: indexPath.row)
// 		var thumbnailImage = object.thumbImage!
// 		if let invertedImage = thumbnailImage.inverted() {
// 			thumbnailImage = invertedImage
// 		}
// 		label.text = object.title
// 		icon.image = thumbnailImage

// 		return cell
// 	}

// 	func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
// 		let cell = tableView.cellForRow(at: indexPath)
// 		cell?.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
// 	}

// 	func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
// 		let cell = tableView.cellForRow(at: indexPath)
// 		cell?.backgroundColor = UIColor.clear
// 	}
// }

// // MARK: - VirtualObjectSelectionViewControllerDelegate
// protocol VirtualObjectSelectionViewControllerDelegate: AnyObject {
// 	func virtualObjectSelectionViewController(_: VirtualObjectSelectionViewController, object: VirtualObject)
// }


import UIKit
import SceneKit
class VirtualObjectSelectionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

	private var tableView: UITableView!
	private var size: CGSize!
	weak var delegate: VirtualObjectSelectionViewControllerDelegate?
    private var virtualObjects: [VirtualObject] = []

    init(size: CGSize) {
        super.init(nibName: nil, bundle: nil)
        self.size = size
        setupVirtualObjects()
    }
    
    private func setupVirtualObjects() {
        virtualObjects = [
            GenericVirtualObject(modelName: "candle", thumbnailName: "candle", particleSize: 0.018),
            GenericVirtualObject(modelName: "cup", thumbnailName: "cup"),
            GenericVirtualObject(modelName: "vase", thumbnailName: "vase"),
            GenericVirtualObject(modelName: "lamp", thumbnailName: "lamp"),
            GenericVirtualObject(modelName: "chair", thumbnailName: "chair"),
            GenericVirtualObject(modelName: "sofa", thumbnailName: "SeatingFurnitureImg", initialScale: SCNVector3(0.1, 0.1, 0.1)),
            GenericVirtualObject(modelName: "Bed", thumbnailName: "BedImg", initialScale: SCNVector3(0.1, 0.1, 0.1)),
            GenericVirtualObject(modelName: "CabinetsAndShelves", thumbnailName: "CabinetsAndShelvesImg", initialScale: SCNVector3(0.1, 0.1, 0.1)),
//            GenericVirtualObject(modelName: "sofa", thumbnailName: "ChairImg", initialScale: SCNVector3(0.1, 0.1, 0.1)),
            GenericVirtualObject(modelName: "Decoration", thumbnailName: "DecorImg", initialScale: SCNVector3(0.1, 0.1, 0.1)),
            GenericVirtualObject(modelName: "Dining", thumbnailName: "DiningImg", initialScale: SCNVector3(0.1, 0.1, 0.1)),
            GenericVirtualObject(modelName: "KitchenFurniture", thumbnailName: "KitchenFurnitureImg", initialScale: SCNVector3(0.1, 0.1, 0.1)),
            GenericVirtualObject(modelName: "Table", thumbnailName: "TableImg", initialScale: SCNVector3(0.1, 0.1, 0.1))
        ]
    }

//	init(size: CGSize) {
//		super.init(nibName: nil, bundle: nil)
//		self.size = size
//	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		tableView = UITableView()
		tableView.frame = CGRect(origin: CGPoint.zero, size: self.size)
		tableView.dataSource = self
		tableView.delegate = self
		tableView.backgroundColor = UIColor.clear
		tableView.separatorEffect = UIVibrancyEffect(blurEffect: UIBlurEffect(style: .light))
		tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		tableView.bounces = false

		self.preferredContentSize = self.size

		self.view.addSubview(tableView)
	}

    func getObject(index: Int) -> VirtualObject {
        return virtualObjects[index]
    }
    
//	func getObject(index: Int) -> VirtualObject {
//		switch index {
//		case 0:
//			return Candle()
//		case 1:
//			return Cup()
//		case 2:
//			return Vase()
//		case 3:
//			return Lamp()
//		case 4:
//			return Chair()
//        case 5:
//            return Sofa()
//		default:
//			return Cup()
//		}
//	}
//
//	static let COUNT_OBJECTS = 6

	// MARK: - UITableViewDelegate
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		delegate?.virtualObjectSelectionViewController(self, object: getObject(index: indexPath.row))
		self.dismiss(animated: true, completion: nil)
	}

	// MARK: - UITableViewDataSource
//	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//		return VirtualObjectSelectionViewController.COUNT_OBJECTS
//	}
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return virtualObjects.count
    }

//	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//		let cell = UITableViewCell()
//		let label = UILabel(frame: CGRect(x: 53, y: 10, width: 200, height: 30))
//		let icon = UIImageView(frame: CGRect(x: 15, y: 10, width: 30, height: 30))
//
//		cell.backgroundColor = UIColor.clear
//		cell.selectionStyle = .none
//		let vibrancyEffect = UIVibrancyEffect(blurEffect: UIBlurEffect(style: .extraLight))
//		let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
//		vibrancyView.frame = cell.contentView.frame
//		cell.contentView.insertSubview(vibrancyView, at: 0)
//		vibrancyView.contentView.addSubview(label)
//		vibrancyView.contentView.addSubview(icon)
//
//		// Fill up the cell with data from the object.
//		let object = getObject(index: indexPath.row)
//		var thumbnailImage = object.thumbImage!
//		if let invertedImage = thumbnailImage.inverted() {
//			thumbnailImage = invertedImage
//		}
//		label.text = object.title
//		icon.image = thumbnailImage
//
//		return cell
//	}
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let label = UILabel(frame: CGRect(x: 53, y: 10, width: 200, height: 30))
        let icon = UIImageView(frame: CGRect(x: 15, y: 10, width: 30, height: 30))

        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        let vibrancyEffect = UIVibrancyEffect(blurEffect: UIBlurEffect(style: .extraLight))
        let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyView.frame = cell.contentView.frame
        cell.contentView.insertSubview(vibrancyView, at: 0)
        vibrancyView.contentView.addSubview(label)
        vibrancyView.contentView.addSubview(icon)

        // Fill up the cell with data from the object.
        let object = getObject(index: indexPath.row)
        label.text = object.title
        
        if let thumbImage = object.thumbImage {
            icon.image = thumbImage.inverted() ?? thumbImage
        } else {
            // Set a default image or leave it empty
            icon.image = UIImage(named: "defaultThumbnail")
        }

        return cell
    }

	func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
		let cell = tableView.cellForRow(at: indexPath)
		cell?.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
	}

	func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
		let cell = tableView.cellForRow(at: indexPath)
		cell?.backgroundColor = UIColor.clear
	}
}

// MARK: - VirtualObjectSelectionViewControllerDelegate
protocol VirtualObjectSelectionViewControllerDelegate: AnyObject {
	func virtualObjectSelectionViewController(_: VirtualObjectSelectionViewController, object: VirtualObject)
}
