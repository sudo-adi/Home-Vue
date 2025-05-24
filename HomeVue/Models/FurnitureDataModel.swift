import Foundation
import UIKit
import CryptoKit

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
    static func createFurnitureItem(id: UUID,name: String, model3D: String, brandName: String, description: String, image: UIImage, availableColors: [String], dimensions: Dimension, providers: [Provider]) -> FurnitureItem {
        return FurnitureItem(id: id, name: name, model3D: model3D, brandName: brandName, description: description, image: image, availableColors: availableColors, dimensions: dimensions, providers: providers)
    }
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
                        id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!,
                        name: "Matte Planter",
                        model3D: "Decoration.usdz",
                        brandName: "UrbanLeaf",
                        description: "Material: ABS plastic (lightweight, non-toxic)\nA sleek and minimalistic flower pot in matte black finish, perfect for modern interiors. Its lightweight yet durable construction makes it ideal for both artificial and real indoor plants.",
                        image: UIImage(named: "DecorImg.jpg")!,
                        availableColors: ["White", "Black", "Sandstone Beige"],
                        dimensions: Dimension(depth: 80, width: 100, height: 70),
                        providers: [Provider(name: "Urban Outfitters Home")]
                    )
                ]
            ),
            FurnitureCategory(
                category: .seatingFurniture,
                furnitureItems: [
                    FurnitureItemManager.createFurnitureItem(
                        id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!,
                        name: "Single Seater",
                        model3D: "SeatingFurniture.usdz",
                        brandName: "IKEA STRANDMON",
                        description: "Material: \nArm & Base: Faux leather (PU)\nSeat & Backrest: High-resilience fabric (polyester blend)\nFrame: Solid wood with MDF reinforcement\nLegs: Wood (walnut finish)",
                        image: UIImage(named: "SeatingFurnitureImg.jpg")!,
                        availableColors: ["Brown", "Beige", "Velvet"],
                        dimensions: Dimension(depth: 85, width: 85, height: 100),
                        providers: [Provider(name: "Pepperfry"), Provider(name: "Amazon")]
                    )
                ]
            ),
            FurnitureCategory(
                category: .cabinetAndShelves,
                furnitureItems: [
                    FurnitureItemManager.createFurnitureItem(
                        id: UUID(uuidString: "00000000-0000-0000-0000-000000000007")!,
                        name: "4-Drawer Chest",
                        model3D: "CabinetsAndShelves.usdz",
                        brandName: "ScandiHome",
                        description: "Material: \n Drawer Fronts: Engineered wood with natural oak veneer\nFrame: MDF with matte white laminate\nLegs: Solid pine (white finish)\nA minimalist, Scandinavian-style chest with four spacious drawers, ideal for bedrooms or modern living spaces.",
                        image: UIImage(named: "CabinetsAndShelvesImg.jpg")!,
                        availableColors: ["Oak & White", "Walnut & Black", "Ash Gray & White"],
                        dimensions: Dimension(depth: 25, width: 50, height: 90),
                        providers: [Provider(name: "Wayfair"), Provider(name: "Urban Ladder")]
                    )
                ]
            ),
            FurnitureCategory(
                category: .tablesAndChairs,
                furnitureItems: [
                    FurnitureItemManager.createFurnitureItem(
                        id: UUID(uuidString: "00000000-0000-0000-0000-000000000004")!,
                        name: "Oslo Lounge Chair",
                        model3D: "Chair.usdz",
                        brandName: "UrbanNest Living",
                        description: "Material: Seat: PU Leather, Legs: Stainless steel (chrome finish)\nA modern, ergonomic swivel lounge chair with a contoured seat and high backrest, perfect for office or lounge settings. The minimalistic design is complemented by polished chrome legs and smooth leather upholstery.",
                        image: UIImage(named: "ChairImg.jpg")!,
                        availableColors: ["Tan Brown", "Charcoal Gray", "Off-White"],
                        dimensions: Dimension(depth: 75, width: 75, height: 80),
                        providers: [Provider(name: "IKEA"), Provider(name: "Urban Ladder"), Provider(name: "Wayfair"), Provider(name: "Pepperfry")]
                    ),
                    FurnitureItemManager.createFurnitureItem(
                        id: UUID(uuidString: "00000000-0000-0000-0000-000000000005")!,
                        name: "Office Table",
                        model3D: "Table.usdz",
                        brandName: "Ikea",
                        description: "Material: MDF with laminate finish\nSturdy metal legs for durability\nSpacious surface for a laptop and documents\nModern design, perfect for office or study",
                        image: UIImage(named: "TableImg.jpg")!,
                        availableColors: ["Black", "White"],
                        dimensions: Dimension(depth: 150, width: 90, height: 75),
                        providers: [Provider(name: "Ikea"), Provider(name: "Wayfair")]
                    )
                ]
            ),
            FurnitureCategory(
                category: .dining,
                furnitureItems: [
                    FurnitureItemManager.createFurnitureItem(
                        id: UUID(uuidString: "00000000-0000-0000-0000-000000000003")!,
                        name: "Dining Table",
                        model3D:"Dining.usdz",
                        brandName: "Ikea",
                        description: "Material: Solid wood with a durable finish\nSimple, modern design that fits any dining room\nComfortable for up to four people\nEasy to clean surface for everyday use\nAvailable in various colors to suit your decor",
                        image: UIImage(named: "DiningImg.jpg")!,
                        availableColors: ["Wood", "Black", "White"],
                        dimensions: Dimension(depth: 220, width: 120, height: 75),
                        providers: [Provider(name: "Ikea"), Provider(name: "Wayfair")]
                    )
                ]
            ),
            FurnitureCategory(category: .others,
                  furnitureItems: [
                    FurnitureItemManager.createFurnitureItem(
                        id: UUID(uuidString: "00000000-0000-0000-0000-000000000006")!,
                        name: "52' TV",
                        model3D: "Others.usdz",
                        brandName: "Samsung",
                        description: "Display: 4K Ultra HD resolution for crystal-clear visuals\nSound: Dolby Atmos surround sound for an immersive audio experience\nSmart Features: Built-in streaming apps like Netflix, YouTube, and Prime Video\nVoice Control: Compatible with Alexa, Google Assistant, and Siri for hands-free operation\nDesign: Slim, bezel-less frame for a modern and stylish look\nConnectivity: Multiple HDMI and USB ports for seamless device integration\n",
                        image: UIImage(named: "OthersImg.jpg")!,
                        availableColors:[],
                        dimensions: Dimension(depth: 5, width: 25, height: 20),
                        providers: [Provider(name: "Samsung"),Provider(name: "Sony")]
                    )
                ]
            ),
            
            FurnitureCategory(
                category: .kitchenFurniture,
                furnitureItems: [
                    FurnitureItemManager.createFurnitureItem(
                        id: UUID(uuidString: "00000000-0000-0000-0000-000000000008")!,
                        name: "Kitchen Sink",
                        model3D: "KitchenFurniture.usdz",
                        brandName: "Home Depot",
                        description: "Material: Stainless steel sink with wooden cabinetry\nGranite countertop for durability and elegance\nAmple storage space with soft-close drawers\nPerfect for central kitchen islands\nModern, sleek design that complements any kitchen",
                        image: UIImage(named: "KitchenFurnitureImg.jpg")!,
                        availableColors: ["Black", "White"],
                        dimensions: Dimension(depth: 180, width: 80, height: 80),
                        providers: [Provider(name: "Home Depot")]
                    )
                ]
            ),
            FurnitureCategory(
                category: .bed,
                furnitureItems: [
                    FurnitureItemManager.createFurnitureItem(
                        id: UUID(uuidString: "00000000-0000-0000-0000-000000000009")!,
                        name: "Queen Bed",
                        model3D: "Bed.usdz",
                        brandName: "Tempur-Pedic",
                        description: "Material: High-quality wooden frame with memory foam mattress\nSoft, breathable linen cover for ultimate comfort\nMemory foam provides pressure relief for better sleep\nElegant, neutral-colored fabric to complement any room\nPerfect for couples or individuals who need extra comfort",
                        image: UIImage(named: "BedImg.jpg")!,
                        availableColors: ["Brown", "Beige"],
                        dimensions: Dimension(depth: 220, width: 180, height: 45),
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
