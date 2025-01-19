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
    case decoration = "Decoration"
    case cabinetAndShelves = "Cabinet and Shelves"
    case dining = "Dining"
    case others = "Others"
}

// MARK: - Furniture Dimension
struct Dimension {
    var length: Double
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
    var imageUrl: String
    var availableColors: [String]
    var dimensions: Dimension
    var providers: [Provider]
}


// MARK: - FurnitureItemManager
class FurnitureItemManager {
    static func createFurnitureItem(name: String, model3D: String, brandName: String, description: String, imageUrl: String, availableColors: [String], dimensions: Dimension, providers: [Provider]) -> FurnitureItem {
        return FurnitureItem(id: UUID(), name: name, model3D: model3D, brandName: brandName, description: description, imageUrl: imageUrl, availableColors: availableColors, dimensions: dimensions, providers: providers)}
}

// MARK: - FurnitureDataProvider
class FurnitureDataProvider {
    static let shared = FurnitureDataProvider()
    private init() {}
    
    func getFurnitureCategories() -> [FurnitureCategory] {
        return [
            FurnitureCategory(
                category: .tablesAndChairs,
                furnitureItems: [
                    FurnitureItemManager.createFurnitureItem(
                        name: "Dining Table",
                        model3D: "dining_table_3d_model",
                        brandName: "Ikea",
                        description: "A modern dining table for 6 people.",
                        imageUrl: "https://example.com/dining_table.jpg",
                        availableColors: ["Wood", "Black", "White"],
                        dimensions: Dimension(length: 200, width: 100, height: 75),
                        providers: [Provider(name: "Ikea"), Provider(name: "Wayfair")]
                    ),
                    FurnitureItemManager.createFurnitureItem(
                        name: "Office Chair",
                        model3D: "office_chair_3d_model",
                        brandName: "Herman Miller",
                        description: "An ergonomic office chair for all-day comfort.",
                        imageUrl: "https://example.com/office_chair.jpg",
                        availableColors: ["Black", "Grey", "Blue"],
                        dimensions: Dimension(length: 60, width: 60, height: 120),
                        providers: [Provider(name: "Herman Miller")]
                    )
                ]
            ),
            FurnitureCategory(
                category: .seatingFurniture,
                furnitureItems: [
                    FurnitureItemManager.createFurnitureItem(
                        name: "Sofa",
                        model3D: "sofa_3d_model",
                        brandName: "Ashley",
                        description: "A comfortable sectional sofa for living rooms.",
                        imageUrl: "https://example.com/sofa.jpg",
                        availableColors: ["Gray", "Beige", "Dark Blue"],
                        dimensions: Dimension(length: 250, width: 90, height: 85),
                        providers: [Provider(name: "Ashley Furniture"), Provider(name: "Amazon")]
                    ),
                    FurnitureItemManager.createFurnitureItem(
                        name: "Armchair",
                        model3D: "armchair_3d_model",
                        brandName: "La-Z-Boy",
                        description: "A recliner armchair for ultimate relaxation.",
                        imageUrl: "https://example.com/armchair.jpg",
                        availableColors: ["Brown", "Black", "Red"],
                        dimensions: Dimension(length: 85, width: 85, height: 100),
                        providers: [Provider(name: "La-Z-Boy")]
                    )
                ]
            ),
            FurnitureCategory(
                category: .kitchenFurniture,
                furnitureItems: [
                    FurnitureItemManager.createFurnitureItem(
                        name: "Kitchen Island",
                        model3D: "kitchen_island_3d_model",
                        brandName: "Home Depot",
                        description: "A central kitchen island with ample storage.",
                        imageUrl: "https://example.com/kitchen_island.jpg",
                        availableColors: ["Wood", "White", "Gray"],
                        dimensions: Dimension(length: 180, width: 90, height: 95),
                        providers: [Provider(name: "Home Depot")]
                    ),
                    FurnitureItemManager.createFurnitureItem(
                        name: "Bar Stool",
                        model3D: "bar_stool_3d_model",
                        brandName: "Wayfair",
                        description: "Adjustable bar stool for kitchen islands or counters.",
                        imageUrl: "https://example.com/bar_stool.jpg",
                        availableColors: ["Black", "Chrome", "Wood"],
                        dimensions: Dimension(length: 35, width: 35, height: 75),
                        providers: [Provider(name: "Wayfair")]
                    )
                ]
            ),
            FurnitureCategory(
                category: .bed,
                furnitureItems: [
                    FurnitureItemManager.createFurnitureItem(
                        name: "Queen Bed",
                        model3D: "queen_bed_3d_model",
                        brandName: "Tempur-Pedic",
                        description: "A premium queen-sized bed with memory foam.",
                        imageUrl: "https://example.com/queen_bed.jpg",
                        availableColors: ["White", "Gray", "Beige"],
                        dimensions: Dimension(length: 200, width: 160, height: 30),
                        providers: [Provider(name: "Tempur-Pedic"), Provider(name: "Amazon")]
                    ),
                    FurnitureItemManager.createFurnitureItem(
                        name: "Bunk Bed",
                        model3D: "bunk_bed_3d_model",
                        brandName: "Ikea",
                        description: "Space-saving bunk bed with ladder and safety rails.",
                        imageUrl: "https://example.com/bunk_bed.jpg",
                        availableColors: ["White", "Wood"],
                        dimensions: Dimension(length: 200, width: 90, height: 160),
                        providers: [Provider(name: "Ikea")]
                    )
                ]
            ),
            FurnitureCategory(
                category: .decoration,
                furnitureItems: [
                    FurnitureItemManager.createFurnitureItem(
                        name: "Vase",
                        model3D: "vase_3d_model",
                        brandName: "Target",
                        description: "A beautiful ceramic vase perfect for flowers.",
                        imageUrl: "https://example.com/vase.jpg",
                        availableColors: ["White", "Blue", "Green"],
                        dimensions: Dimension(length: 20, width: 20, height: 40),
                        providers: [Provider(name: "Target")]
                    ),
                    FurnitureItemManager.createFurnitureItem(
                        name: "Wall Art",
                        model3D: "wall_art_3d_model",
                        brandName: "Society6",
                        description: "A stunning piece of wall art to add color to your home.",
                        imageUrl: "https://example.com/wall_art.jpg",
                        availableColors: ["Multicolor", "Black and White", "Gold"],
                        dimensions: Dimension(length: 80, width: 2, height: 60),
                        providers: [Provider(name: "Society6")]
                    )
                ]
            ),
            FurnitureCategory(
                category: .cabinetAndShelves,
                furnitureItems: [
                    FurnitureItemManager.createFurnitureItem(
                        name: "Bookshelf",
                        model3D: "bookshelf_3d_model",
                        brandName: "Wayfair",
                        description: "A sturdy bookshelf with ample storage for books.",
                        imageUrl: "https://example.com/bookshelf.jpg",
                        availableColors: ["Wood", "Black", "White"],
                        dimensions: Dimension(length: 100, width: 30, height: 180),
                        providers: [Provider(name: "Wayfair")]
                    ),
                    FurnitureItemManager.createFurnitureItem(
                        name: "Wardrobe",
                        model3D: "wardrobe_3d_model",
                        brandName: "Ikea",
                        description: "A spacious wardrobe with hanging and shelf space.",
                        imageUrl: "https://example.com/wardrobe.jpg",
                        availableColors: ["White", "Oak", "Grey"],
                        dimensions: Dimension(length: 120, width: 60, height: 200),
                        providers: [Provider(name: "Ikea")]
                    )
                ]
            ),
            FurnitureCategory(
                category: .dining,
                furnitureItems: [
                    FurnitureItemManager.createFurnitureItem(
                        name: "Dining Set",
                        model3D: "dining_set_3d_model",
                        brandName: "Crate & Barrel",
                        description: "A stylish dining set with a table and chairs.",
                        imageUrl: "https://example.com/dining_set.jpg",
                        availableColors: ["Wood", "Black", "White"],
                        dimensions: Dimension(length: 200, width: 100, height: 75),
                        providers: [Provider(name: "Crate & Barrel")]
                    ),
                    FurnitureItemManager.createFurnitureItem(
                        name: "Sideboard",
                        model3D: "sideboard_3d_model",
                        brandName: "West Elm",
                        description: "A sleek sideboard perfect for dining rooms.",
                        imageUrl: "https://example.com/sideboard.jpg",
                        availableColors: ["Wood", "Grey"],
                        dimensions: Dimension(length: 160, width: 45, height: 90),
                        providers: [Provider(name: "West Elm")]
                    )
                ]
            )
        ]
    }
}
