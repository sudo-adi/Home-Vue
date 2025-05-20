//
//  RoomDataModel.swift
//  dummy
//
//  Created by student-2 on 15/01/25.
//

import Foundation
import UIKit


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
struct RoomDetails: Codable {
    let id: UUID
    let name: String
    let model3D: String?
    let modelImageName: String?
    let createdDate: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case model3D = "model_3d"
        case modelImageName = "model_image_name"
        case createdDate = "created_date"
    }
}
// MARK: - RoomCategoryType
enum RoomCategoryType: String, Codable, CaseIterable {
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
struct RoomModel: Codable, Identifiable {
    let details: RoomDetails
    private(set) var addedFurniture: [FurnitureItem]
    let userId: UUID
    let category: RoomCategoryType
    
    var id: UUID { details.id } // For Identifiable
    
    enum CodingKeys: String, CodingKey {
        case details
        case addedFurniture = "added_furniture"
        case userId = "user_id"
        case category
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        details = try container.decode(RoomDetails.self, forKey: .details)
        addedFurniture = try container.decode([FurnitureItem].self, forKey: .addedFurniture)
        userId = try container.decode(UUID.self, forKey: .userId)
        category = try container.decode(RoomCategoryType.self, forKey: .category)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(details, forKey: .details)
        try container.encode(addedFurniture, forKey: .addedFurniture)
        try container.encode(userId, forKey: .userId)
        try container.encode(category, forKey: .category)
    }
    
    init(name: String, model3D: String?, modelImageName: String?, createdDate: Date, userId: UUID, category: RoomCategoryType) {
        self.details = RoomDetails(id: UUID(), name: name, model3D: model3D, modelImageName: modelImageName, createdDate: createdDate)
        self.addedFurniture = []
        self.userId = userId
        self.category = category
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
