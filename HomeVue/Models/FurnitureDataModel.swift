import Foundation
import UIKit
import CryptoKit

struct FurnitureCategory:Codable {
//    let id:UUID
    let category: FurnitureCategoryType
    private(set) var furnitureItems: [FurnitureItem]
    
    enum CodingKeys: String, CodingKey {
        case category = "category_type"
        case furnitureItems = "items"
    }
    // Add a furniture item to this category
//    mutating func addFurnitureItem(_ item: FurnitureItem) {
//        furnitureItems.append(item)
//    }
//
//    // Remove a furniture item from this category by ID
//    mutating func removeFurnitureItem(byId id: UUID) {
//        if let index = furnitureItems.firstIndex(where: { $0.id == id }) {
//            furnitureItems.remove(at: index)
//        }
//    }
//
//    // List all furniture items in this category
//    func listFurnitureItems() -> [FurnitureItem] {
//        return furnitureItems
//    }
}

// MARK: - FurnitureCategoryType
// Represents predefined furniture categories.
// Used in catalogue section
enum FurnitureCategoryType: String, CaseIterable, Codable {
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

struct FurnitureItem: Codable, Identifiable {
    let id: UUID
    let name: String
    let model3D: String
    var brandName: String
    var description: String
    var imageName: String
    var availableColors: [String]
    var dimensions: [Double]
    var providers: [String]
    
    enum CodingKeys: String, CodingKey {
        case id
        case name = "name"
        case model3D = "model_3d"
        case brandName = "brand_name"
        case description = "description"
        case imageName = "image_name"
        case availableColors = "available_colors"
        case dimensions = "dimensions"
        case providers = "providers"
    }
}



// MARK: - FurnitureItemManager
class FurnitureItemManager {
    static func createFurnitureItem(id: UUID,name: String, model3D: String, brandName: String, description: String, imageName: String, availableColors: [String], dimensions: [Double], providers: [String]) -> FurnitureItem {
        return FurnitureItem(id: id, name: name, model3D: model3D, brandName: brandName, description: description, imageName: imageName , availableColors: availableColors, dimensions: dimensions, providers: providers)
    }
}

// MARK: - FurnitureDataProvider
class FurnitureDataProvider {
    static let shared = FurnitureDataProvider()
    private init() {}
    
    func getFurnitureCategories() -> [FurnitureCategory] {
        return [
//            FurnitureCategory(
//                category: .decor,
//                furnitureItems: [
//                    FurnitureItemManager.createFurnitureItem(
//                        id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!,
//                        name: "Matte Planter",
//                        model3D: "Decoration.usdz",
//                        brandName: "UrbanLeaf",
//                        description: "Material: ABS plastic (lightweight, non-toxic)\nA sleek and minimalistic flower pot in matte black finish, perfect for modern interiors. Its lightweight yet durable construction makes it ideal for both artificial and real indoor plants.",
//                        imageName:  "DecorImg.jpg",
//                        availableColors: ["White", "Black", "Sandstone Beige"],
//                        dimensions: Dimension(depth: 15, width: 20, height: 15),
//                        providers: [ "Urban Outfitters Home"]
//                    )
//                ]
//            ),
//            FurnitureCategory(
//                category: .seatingFurniture,
//                furnitureItems: [
//                    FurnitureItemManager.createFurnitureItem(
//                        id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!,
//                        name: "Single Seater",
//                        model3D: "SeatingFurniture.usdz",
//                        brandName: "IKEA STRANDMON",
//                        description: "Material: \nArm & Base: Faux leather (PU)\nSeat & Backrest: High-resilience fabric (polyester blend)\nFrame: Solid wood with MDF reinforcement\nLegs: Wood (walnut finish)",
//                        imageName:  "SeatingFurnitureImg.jpg",
//                        availableColors: ["Brown", "Beige", "Velvet"],
//                        dimensions: Dimension(depth: 18),
//                        providers: ["Pepperfry", "Amazon"]
//                    )
//                ]
//            ),
//            FurnitureCategory(
//                category: .cabinetAndShelves,
//                furnitureItems: [
//                    FurnitureItemManager.createFurnitureItem(
//                        id: UUID(uuidString: "00000000-0000-0000-0000-000000000007")!,
//                        name: "4-Drawer Chest",
//                        model3D: "CabinetsAndShelves.usdz",
//                        brandName: "ScandiHome",
//                        description: "Material: \n Drawer Fronts: Engineered wood with natural oak veneer\nFrame: MDF with matte white laminate\nLegs: Solid pine (white finish)\nA minimalist, Scandinavian-style chest with four spacious drawers, ideal for bedrooms or modern living spaces.",
//                        imageName:  "CabinetsAndShelvesImg.jpg",
//                        availableColors: ["Oak & White", "Walnut & Black", "Ash Gray & White"],
//                        dimensions: Dimension(depth: 45, width: 90, height: 180),
//                        providers: ["Wayfair","Urban Ladder"]
//                    )
//                ]
//            ),
//            FurnitureCategory(
//                category: .tablesAndChairs,
//                furnitureItems: [
//                    FurnitureItemManager.createFurnitureItem(
//                        id: UUID(uuidString: "00000000-0000-0000-0000-000000000004")!,
//                        name: "Oslo Lounge Chair",
//                        model3D: "Chair.usdz",
//                        brandName: "UrbanNest Living",
//                        description: "Material: Seat: PU Leather, Legs: Stainless steel (chrome finish)\nA modern, ergonomic swivel lounge chair with a contoured seat and high backrest, perfect for office or lounge settings. The minimalistic design is complemented by polished chrome legs and smooth leather upholstery.",
//                        imageName:  "ChairImg.jpg",
//                        availableColors: ["Tan Brown", "Charcoal Gray", "Off-White"],
//                        dimensions: Dimension(depth: 70, width: 68, height: 105),
//                        providers: [ "IKEA","Urban Ladder","Wayfair", "Pepperfry"]
//                    ),
//                    FurnitureItemManager.createFurnitureItem(
//                        id: UUID(uuidString: "00000000-0000-0000-0000-000000000005")!,
//                        name: "Office Table",
//                        model3D: "Table.usdz",
//                        brandName: "Ikea",
//                        description: "Material: MDF with laminate finish\nSturdy metal legs for durability\nSpacious surface for a laptop and documents\nModern design, perfect for office or study",
//                        imageName:  "TableImg.jpg",
//                        availableColors: ["Black", "White"],
//                        dimensions: Dimension(depth: 160, width: 80, height: 75),
//                        providers: ["Ikea","Wayfair"]
//                    )
//                ]
//            ),
//            FurnitureCategory(
//                category: .dining,
//                furnitureItems: [
//                    FurnitureItemManager.createFurnitureItem(
//                        id: UUID(uuidString: "00000000-0000-0000-0000-000000000003")!,
//                        name: "Dining Table",
//                        model3D:"Dining.usdz",
//                        brandName: "Ikea",
//                        description: "Material: Solid wood with a durable finish\nSimple, modern design that fits any dining room\nComfortable for up to four people\nEasy to clean surface for everyday use\nAvailable in various colors to suit your decor",
//                        imageName:  "DiningImg.jpg",
//                        availableColors: ["Wood", "Black", "White"],
//                        dimensions: Dimension(depth: 200, width: 100, height: 75),
//                        providers: ["Ikea", "Wayfair"]
//                    )
//                ]
//            ),
//            FurnitureCategory(category: .others,
//                  furnitureItems: [
//                    FurnitureItemManager.createFurnitureItem(
//                        id: UUID(uuidString: "00000000-0000-0000-0000-000000000006")!,
//                        name: "52' TV",
//                        model3D: "Others.usdz",
//                        brandName: "Samsung",
//                        description: "Display: 4K Ultra HD resolution for crystal-clear visuals\nSound: Dolby Atmos surround sound for an immersive audio experience\nSmart Features: Built-in streaming apps like Netflix, YouTube, and Prime Video\nVoice Control: Compatible with Alexa, Google Assistant, and Siri for hands-free operation\nDesign: Slim, bezel-less frame for a modern and stylish look\nConnectivity: Multiple HDMI and USB ports for seamless device integration\n",
//                        imageName:  "OthersImg.jpg",
//                        availableColors:[],
//                        dimensions: Dimension(depth: 7.5, width: 43.5, height: 72.4),
//                        providers: ["Samsung", "Sony"]
//                    )
//                ]
//            ),
//            
//            FurnitureCategory(
//                category: .kitchenFurniture,
//                furnitureItems: [
//                    FurnitureItemManager.createFurnitureItem(
//                        id: UUID(uuidString: "00000000-0000-0000-0000-000000000008")!,
//                        name: "Kitchen Sink",
//                        model3D: "KitchenFurniture.usdz",
//                        brandName: "Home Depot",
//                        description: "Material: Stainless steel sink with wooden cabinetry\nGranite countertop for durability and elegance\nAmple storage space with soft-close drawers\nPerfect for central kitchen islands\nModern, sleek design that complements any kitchen",
//                        imageName:  "KitchenFurnitureImg.jpg",
//                        availableColors: ["Black", "White"],
//                        dimensions: Dimension(depth: 220, width: 90, height: 100),
//                        providers: ["Home Depot"]
//                    )
//                ]
//            ),
//            FurnitureCategory(
//                category: .bed,
//                furnitureItems: [
//                    FurnitureItemManager.createFurnitureItem(
//                        id: UUID(uuidString: "00000000-0000-0000-0000-000000000009")!,
//                        name: "Queen Bed",
//                        model3D: "Bed.usdz",
//                        brandName: "Tempur-Pedic",
//                        description: "Material: High-quality wooden frame with memory foam mattress\nSoft, breathable linen cover for ultimate comfort\nMemory foam provides pressure relief for better sleep\nElegant, neutral-colored fabric to complement any room\nPerfect for couples or individuals who need extra comfort",
//                        imageName:  "BedImg.jpg",
//                        availableColors: ["Brown", "Beige"],
//                        dimensions: Dimension(depth: 210, width: 160, height: 35),
//                        providers: ["Tempur-Pedic", "Amazon"]
//                    )
//                ]
//            ),
//           
        ]
    }
    
    func fetchFurnitureItems(for categoryType: FurnitureCategoryType) -> [FurnitureItem] {
        let allCategories = getFurnitureCategories()
        return allCategories.first(where: { $0.category == categoryType })?.furnitureItems ?? []
    }
}
