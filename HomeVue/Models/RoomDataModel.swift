//
//  RoomDataModel.swift
//  dummy
//
//  Created by student-2 on 15/01/25.
//

import Foundation
import UIKit

// MARK: - RoomCategoryType

enum RoomCategoryType: String, CaseIterable {
    case livingRoom = "Living Room"
    case bedroom = "Bedroom"
    case kitchen = "Kitchen"
    case bathroom = "Bathroom"
    case others = "Other Spaces"
    
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

class RoomCategory {
    let category: RoomCategoryType
    private(set) var roomModels: [RoomModel]

    init(category: RoomCategoryType) {
        self.category = category
        self.roomModels = []
    }

    func addRoom(_ room: RoomModel) {
        roomModels.append(room)
    }

    func removeRoom(byId roomId: UUID) {
        if let index = roomModels.firstIndex(where: { $0.details.id == roomId }) {
            roomModels.remove(at: index)
        }
    }
    
    func listRooms() -> [RoomModel] {
        return roomModels
    }
}

// MARK: - RoomModel

struct RoomDetails {
    let id: UUID
    let name: String
    let model3D: String?
    let modelImage: UIImage?
    let createdDate: Date
}

class RoomModel {
    let details: RoomDetails
    private(set) var addedFurniture: [FurnitureItem]
    let userId: UUID
    let category: RoomCategoryType
    
    init(name: String, model3D: String?, modelImage: UIImage?, createdDate: Date, userId: UUID, category: RoomCategoryType) {
        self.details = RoomDetails(id: UUID(), name: name, model3D: model3D, modelImage: modelImage, createdDate: createdDate)
        self.addedFurniture = []
        self.userId = userId
        self.category = category
    }

    func addFurniture(_ furniture: FurnitureItem) {
        addedFurniture.append(furniture)
    }

    func removeFurniture(byId furnitureId: UUID) {
        if let index = addedFurniture.firstIndex(where: { $0.id == furnitureId }) {
            addedFurniture.remove(at: index)
        }
    }
    
    func listFurniture() -> [FurnitureItem] {
        return addedFurniture
    }
}

// MARK: - RoomDataProvider

class RoomDataProvider {
    static let shared = RoomDataProvider()
    private(set) var roomCategories: [RoomCategory]

    private init() {
        roomCategories = RoomDataProvider.getRoomCategories()
        addSampleRooms()
    }

    private func addSampleRooms() {
        let sampleRooms : [RoomModel] = []
        
        for room in sampleRooms {
            addRoom(to: room.category, room: room)
        }
    }

    static func getRoomCategories() -> [RoomCategory] {
        return RoomCategoryType.allCases.map { RoomCategory(category: $0) }
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
