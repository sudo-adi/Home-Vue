import Foundation
import UIKit
//import CryptoKit

// MARK: - FurnitureCategoryType
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
    let id: UUID?
    let name: String?
    let category: FurnitureCategoryType
    let model3D: String?
    var brandName: String?
    var description: String?
    var imageURL: String?
    var availableColors: [String]?
    var dimensions: [Double]
    var providers: [String]?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case category = "furniture_category"
        case model3D = "model3d"
        case brandName = "brand_name"
        case description = "description"
        case imageURL = "image_url"
        case availableColors = "available_colors"
        case dimensions = "dimensions"
        case providers = "providers"
    }
}



// MARK: - FurnitureItemManager
class FurnitureItemManager {
    static func createFurnitureItem(id: UUID,name: String,category:FurnitureCategoryType, model3D: String, brandName: String, description: String, imageURL: String, availableColors: [String], dimensions: [Double], providers: [String]) -> FurnitureItem {
        return FurnitureItem(id: id, name: name,category:category, model3D: model3D, brandName: brandName, description: description, imageURL:imageURL , availableColors: availableColors, dimensions: dimensions, providers: providers)
    }
}

