//
//  RoomDataModel.swift
//  dummy
//
//  Created by student-2 on 15/01/25.
//

import Foundation
import UIKit

// MARK: - RoomCategoryType

// Available room categories
enum RoomCategoryType: String, CaseIterable {
    case livingRoom = "Living Room"
    case bedroom = "Bedroom"
    case kitchen = "Kitchen"
    case bathroom = "Bathroom"
    case others = "Other Rooms"
    
    var thumbnail: String {
        switch self {
        case .livingRoom: return "Living Room"
        case .bedroom: return "Bedroom"
        case .kitchen: return "Kitchen"
        case .bathroom: return "Bathroom"
        case .others: return "Other"
        }
    }
}

// MARK: - RoomCategory

// Represents a specific room category containing multiple rooms.
class RoomCategory {
    let category: RoomCategoryType
    private(set) var roomModels: [RoomModel]

    init(category: RoomCategoryType) {
        self.category = category
        self.roomModels = []
    }

    // Add a room to this specific category
    func addRoom(_ room: RoomModel) {
        roomModels.append(room)
    }

    // Remove a room from this specific category by ID
    func removeRoom(byId roomId: UUID) {
        if let index = roomModels.firstIndex(where: { $0.details.id == roomId }) {
            roomModels.remove(at: index)
        }
    }
    
    // Lists all rooms in this category.
    func listRooms() -> [RoomModel] {
        return roomModels
    }
}

// MARK: - RoomModel

// Represents a room with its details and furniture.
struct RoomDetails {
    let id: UUID
    let name: String
    let model3D: String
    let createdDate: Date
}


// addFurniture, removeFurniture, listFurniture - are used to get the details of the furniture models added to the room model.
class RoomModel {
    let details: RoomDetails
    private(set) var addedFurniture: [FurnitureItem]
    let userId: UUID
    let category: RoomCategoryType
    
    init(name: String, model3D: String, createdDate: Date, userId: UUID, category: RoomCategoryType) {
        self.details = RoomDetails(id: UUID(), name: name, model3D: model3D, createdDate: createdDate)
        self.addedFurniture = []
        self.userId = userId
        self.category = category
    }

    // Add furniture to this room
    func addFurniture(_ furniture: FurnitureItem) {
        addedFurniture.append(furniture)
    }

    // Remove furniture from this room by furniture ID
    func removeFurniture(byId furnitureId: UUID) {
        if let index = addedFurniture.firstIndex(where: { $0.id == furnitureId }) {
            addedFurniture.remove(at: index)
        }
    }
    
    // List all furniture in this room
    func listFurniture() -> [FurnitureItem] {
        return addedFurniture
    }
}

// MARK: - RoomDataProvider

class RoomDataProvider {
    static let shared = RoomDataProvider()
    private(set) var roomCategories: [RoomCategory]

    private init() {
        roomCategories = RoomCategoryType.allCases.map { RoomCategory(category: $0) }
    }

    func addRoom(to category: RoomCategoryType, room: RoomModel) {
        if let roomCategory = roomCategories.first(where: { $0.category == category }) {
            roomCategory.addRoom(room)
        }
    }

    func removeRoom(from category: RoomCategoryType, byId roomId: UUID) {
        if let roomCategory = roomCategories.first(where: { $0.category == category }) {
            roomCategory.removeRoom(byId: roomId)
        }
    }

    func getRooms(for category: RoomCategoryType) -> [RoomModel] {
        return roomCategories.first(where: { $0.category == category })?.roomModels ?? []
    }
}
