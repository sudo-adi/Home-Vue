//
//  FurnitureDataModel.swift
//  dummy
//
//  Created by student-2 on 15/01/25.
//

import Foundation
import UIKit

// Repesents furniture items present in a particular category
struct FurnitureCategory {
    let category: FurnitureCategoryType
    private(set) var furnitureItems: [FurnitureItem]

    // Add a furniture item to this category
    mutating func addFurnitureItem(_ item: FurnitureItem) {
        furnitureItems.append(item)
    }

    // Remove a furniture item from this category by ID
    mutating func removeFurnitureItem(byId id: UUID) {
        if let index = furnitureItems.firstIndex(where: { $0.id == id }) {
            furnitureItems.remove(at: index)
        }
    }

    // List all furniture items in this category
    func listFurnitureItems() -> [FurnitureItem] {
        return furnitureItems
    }
}

// MARK: - FurnitureCategoryType
// Represents predefined furniture categories.
// Used in catalogue section
enum FurnitureCategoryType: String, CaseIterable {
    case tablesAndChairs = "Tables and Chairs"
    case seatingFurniture = "Seating Furniture"
    case kitchenFurniture = "Kitchen Furniture"
    case bed = "Bed"
    case decor = "Decor"
    case cabinetAndShelves = "Cabinet and Shelves"
    case dining = "Dining"
    case others = "Others"

    var thumbnail: String {
        switch self {
            case .tablesAndChairs: return "TablesAndChair"
            case .seatingFurniture: return "SeatingFurniture"
            case .kitchenFurniture: return "KitchenFurniture"
            case .bed: return "Bed"
            case .decor: return "Decor"
            case .cabinetAndShelves: return "CabinetsAndShelves"
            case .dining: return "Dining"
            case .others: return "Others"
        }
    }
}

// MARK: - Furniture Dimension
struct Dimension {
    var depth: Double
    var width: Double
    var height: Double
}

// MARK: - Furniture Provider
struct Provider {
    var name: String
}

// MARK: - FurnitureItem
// Represents a single piece of furniture with its unique ID, name, and 3D model file reference.
// Will be used for presenting the furniture in AR view, or to add the model in a particular room
struct FurnitureItem {
    let id: UUID
    let name: String
    let model3D: String
    var brandName: String
    var description: String
    var image: UIImage
    var availableColors: [String]
    var dimensions: Dimension
    var providers: [Provider]
}


// MARK: - FurnitureItemManager
class FurnitureItemManager {
    static func createFurnitureItem(name: String, model3D: String, brandName: String, description: String, image: UIImage, availableColors: [String], dimensions: Dimension, providers: [Provider]) -> FurnitureItem {
        return FurnitureItem(id: UUID(), name: name, model3D: model3D, brandName: brandName, description: description, image: image, availableColors: availableColors, dimensions: dimensions, providers: providers)}
}

// MARK: - FurnitureDataProvider
class FurnitureDataProvider {
    static let shared = FurnitureDataProvider()
    private init() {}
    
    func getFurnitureCategories() -> [FurnitureCategory] {
        return [
            FurnitureCategory(
                category: .decor,
                furnitureItems: [
                    FurnitureItemManager.createFurnitureItem(
                        name: "Flower Pot",
                        model3D: "Decoration.usdz",
                        brandName: "Target",
                        description: "Material: Ceramic with intricate designs\nPerfect for displaying fresh flowers or plants\nAvailable in multiple sizes for different uses\nElegant and decorative for home or office spaces\nAdds a touch of nature to any room",
                        image: UIImage(named: "DecorImg.jpg")!,
                        availableColors: ["White", "Blue", "Green"],
                        dimensions: Dimension(depth: 25, width: 25, height: 50),
                        providers: [Provider(name: "Target")]
                    )
                ]
            ),
            FurnitureCategory(
                category: .seatingFurniture,
                furnitureItems: [
                    FurnitureItemManager.createFurnitureItem(
                        name: "Single Seater",
                        model3D: "SeatingFurniture.usdz",
                        brandName: "Ashley",
                        description: "Material: Soft cushions with premium fabric upholstery\nWooden frame for added strength and durability\nIdeal for living rooms",
                        image: UIImage(named: "SeatingFurnitureImg.jpg")!,
                        availableColors: ["White", "Beige", "Dark Blue"],
                        dimensions: Dimension(depth: 85, width: 90, height: 85),
                        providers: [Provider(name: "Ashley Furniture"), Provider(name: "Amazon")]
                    )
                ]
            ),
            FurnitureCategory(
                category: .dining,
                furnitureItems: [
                    FurnitureItemManager.createFurnitureItem(
                        name: "Dining Table",
                        model3D:"Dining.usdz",
                        brandName: "Ikea",
                        description: "Material: Solid wood with a durable finish\nSimple, modern design that fits any dining room\nComfortable for up to four people\nEasy to clean surface for everyday use\nAvailable in various colors to suit your decor",
                        image: UIImage(named: "DiningImg.jpg")!,
                        availableColors: ["Wood", "Black", "White"],
                        dimensions: Dimension(depth: 200, width: 100, height: 75),
                        providers: [Provider(name: "Ikea"), Provider(name: "Wayfair")]
                    )
                ]
            ),
            FurnitureCategory(
                category: .tablesAndChairs,
                furnitureItems: [
                    FurnitureItemManager.createFurnitureItem(
                        name: "Gaming Chair",
                        model3D: "Chair.usdz",
                        brandName: "Herman Miller",
                        description: "Material: Premium leather and breathable mesh\nErgonomic design for all-day comfort\nAdjustable armrests and lumbar support\nHeight and tilt adjustable for personalized comfort\nPerfect for gaming or long office hours",
                        image: UIImage(named: "ChairImg.jpg")!,
                        availableColors: ["Purple", "Grey", "Blue"],
                        dimensions: Dimension(depth: 65, width: 65, height: 125),
                        providers: [Provider(name: "Herman Miller")]
                    ),
                    FurnitureItemManager.createFurnitureItem(
                        name: "Office Table",
                        model3D: "Table.usdz",
                        brandName: "Ikea",
                        description: "Material: MDF with laminate finish\nSturdy metal legs for durability\nSpacious surface for a laptop and documents\nModern design, perfect for office or study",
                        image: UIImage(named: "TableImg.jpg")!,
                        availableColors: ["Black", "White"],
                        dimensions: Dimension(depth: 160, width: 80, height: 75),
                        providers: [Provider(name: "Ikea"), Provider(name: "Wayfair")]
                    )
                ]
            ),
            FurnitureCategory(category: .others,
                              furnitureItems: [
                                FurnitureItemManager.createFurnitureItem(
                                    name: "52' TV",
                                    model3D: "Others.usdz",
                                    brandName: "Samsung",
                                    description: "Display: 4K Ultra HD resolution for crystal-clear visuals\nSound: Dolby Atmos surround sound for an immersive audio experience\nSmart Features: Built-in streaming apps like Netflix, YouTube, and Prime Video\nVoice Control: Compatible with Alexa, Google Assistant, and Siri for hands-free operation\nDesign: Slim, bezel-less frame for a modern and stylish look\nConnectivity: Multiple HDMI and USB ports for seamless device integration\n",
                                    image: UIImage(named: "OthersImg.jpg")!,
                                    availableColors:[],
                                    dimensions: Dimension(depth: 7.5, width: 43.5, height: 72.4),
                                    providers: [Provider(name: "Samsung"),Provider(name: "Sony")]
                    )
                ]
            ),
            FurnitureCategory(
                category: .cabinetAndShelves,
                furnitureItems: [
                    FurnitureItemManager.createFurnitureItem(
                        name: "Long Cabinet",
                        model3D: "CabinetsAndShelves.usdz",
                        brandName: "Wayfair",
                        description: "Material: Solid oak wood with smooth matte finish\nFive spacious shelves for ample storage\nSturdy construction, perfect for books or decorative items\nMinimalist design fits seamlessly in modern spaces\nAvailable in multiple colors to suit your home",
                        image: UIImage(named: "CabinetsAndShelvesImg.jpg")!,
                        availableColors: ["Wood", "Black", "White"],
                        dimensions: Dimension(depth: 120, width: 35, height: 180),
                        providers: [Provider(name: "Wayfair")]
                    )
                ]
            ),
            FurnitureCategory(
                category: .kitchenFurniture,
                furnitureItems: [
                    FurnitureItemManager.createFurnitureItem(
                        name: "Kitchen Sink",
                        model3D: "KitchenFurniture.usdz",
                        brandName: "Home Depot",
                        description: "Material: Stainless steel sink with wooden cabinetry\nGranite countertop for durability and elegance\nAmple storage space with soft-close drawers\nPerfect for central kitchen islands\nModern, sleek design that complements any kitchen",
                        image: UIImage(named: "KitchenFurnitureImg.jpg")!,
                        availableColors: ["Black", "White"],
                        dimensions: Dimension(depth: 220, width: 90, height: 100),
                        providers: [Provider(name: "Home Depot")]
                    )
                ]
            ),
            FurnitureCategory(
                category: .bed,
                furnitureItems: [
                    FurnitureItemManager.createFurnitureItem(
                        name: "Queen Bed",
                        model3D: "Bed.usdz",
                        brandName: "Tempur-Pedic",
                        description: "Material: High-quality wooden frame with memory foam mattress\nSoft, breathable linen cover for ultimate comfort\nMemory foam provides pressure relief for better sleep\nElegant, neutral-colored fabric to complement any room\nPerfect for couples or individuals who need extra comfort",
                        image: UIImage(named: "BedImg.jpg")!,
                        availableColors: ["Brown", "Beige"],
                        dimensions: Dimension(depth: 210, width: 160, height: 35),
                        providers: [Provider(name: "Tempur-Pedic"), Provider(name: "Amazon")]
                    )
                ]
            ),
           
        ]
    }
    
    func fetchFurnitureItems(for categoryType: FurnitureCategoryType) -> [FurnitureItem] {
        let allCategories = getFurnitureCategories()
        return allCategories.first(where: { $0.category == categoryType })?.furnitureItems ?? []
    }
}

// MARK: - Ad Section
//var adCards: [FurnitureItem] = [
//    FurnitureItem(id: UUID(), name: "Gaming Chair", model3D: "Chair.usdz", brandName: "", description: "", image: UIImage(named: "ChairImg.jpg")!, availableColors: [], dimensions: Dimension(depth: 85, width: 90, height: 85), providers: []),
//    FurnitureItem(id: UUID(), name: "Flower Pot", model3D: "Decoration.usdz", brandName: "", description: "", image: UIImage(named: "DecorImg.jpg")!, availableColors: [], dimensions: Dimension(depth: 85, width: 90, height: 85), providers: []),
//    FurnitureItem(id: UUID(), name: "Single Sofa", model3D: "SeatingFurniture.usdz", brandName: "", description: "", image: UIImage(named: "SeatingFurnitureImg.jpg")!, availableColors: [], dimensions: Dimension(depth: 85, width: 90, height: 85), providers: []),
//    FurnitureItem(id: UUID(), name: "52' TV", model3D: "Others.usdz", brandName: "", description: "", image: UIImage(named: "OthersImg.jpg")!, availableColors: [], dimensions: Dimension(depth: 85, width: 90, height: 85), providers: [])
//]
