//
//  UserDataModel.swift
//  dummy
//
//  Created by student-2 on 15/01/25.
//

import Foundation
import UIKit

struct User {
    let id: UUID
    var name: String
    var email: String?
    var password: String
    var dateOfBirth: Date?
//    var phoneNumber: String?
    var profilePicture: UIImage?
    var createdDate: Date
    var isVerified: Bool
    var savedFurnitures: [FurnitureItem]
    private(set) var roomsByCategory: [RoomCategoryType: [RoomModel]]
    
    mutating func addRoom(_ room: RoomModel, category: RoomCategoryType) {
        if roomsByCategory[category] == nil {
            roomsByCategory[category] = []
        }
        roomsByCategory[category]?.append(room)
    }

    // Remove a room by ID and category
    mutating func removeRoom(byId roomId: UUID, category: RoomCategoryType) {
        roomsByCategory[category]?.removeAll { $0.details.id == roomId }
    }

    // List all rooms in a category associated with the user
    func listRooms(inCategory category: RoomCategoryType) -> [RoomModel] {
        return roomsByCategory[category] ?? []
    }
}

class UserDetails {
    static let shared = UserDetails()
    private(set) var user: User?
    private var favoriteFurnitures: Set<UUID> = []
    private init() {}

    func setUser(_ user: User) {
        var updatedUser = user
        // Load saved furniture IDs from UserDefaults
        let defaults = UserDefaults.standard
        let savedFurnitureIdsStrings = defaults.array(forKey: "savedFurnitureIds_\(user.id.uuidString)") as? [String] ?? []
        let savedFurnitureIds = savedFurnitureIdsStrings.compactMap { UUID(uuidString: $0) }
        
        // Reconstruct savedFurnitures by fetching items from FurnitureDataProvider
        var savedFurnitures: [FurnitureItem] = []
        let allCategories = FurnitureDataProvider.shared.getFurnitureCategories()
        for category in allCategories {
            for item in category.furnitureItems {
                if savedFurnitureIds.contains(item.id) {
                    savedFurnitures.append(item)
                }
            }
        }
        updatedUser.savedFurnitures = savedFurnitures
        self.user = updatedUser
    }

    func getUser() -> User? {
        return user
    }
    
    func addRoomToUser(_ room: RoomModel, category: RoomCategoryType) {
        user?.addRoom(room, category: category)
    }

    func removeRoomFromUser(byId roomId: UUID, category: RoomCategoryType) {
        user?.removeRoom(byId: roomId, category: category)
    }

    func listUserRooms(inCategory category: RoomCategoryType) -> [RoomModel] {
        return user?.listRooms(inCategory: category) ?? []
    }
    
    func toggleSave(furnitureItem: FurnitureItem)  {
        if var currentUser = user {
            // Check if furniture item is already in favorites
            if let index = currentUser.savedFurnitures.firstIndex(where: { $0.id == furnitureItem.id }) {
                // Remove from favorites if already exists
                currentUser.savedFurnitures.remove(at: index)
            } else {
                // Add to favorites if not exists
                currentUser.savedFurnitures.append(furnitureItem)
            }
            
            // Update user
            self.user = currentUser
            saveUserData()
        }
    }
    
    private func saveUserData() {
            guard let user = user else { return }
            let defaults = UserDefaults.standard
            let savedFurnitureIdsStrings = user.savedFurnitures.map { $0.id.uuidString }
            defaults.set(savedFurnitureIdsStrings, forKey: "savedFurnitureIds_\(user.id.uuidString)")
            defaults.synchronize()
        }
        
        func isFavoriteFurniture(furnitureID: UUID) -> Bool {
            return user?.savedFurnitures.contains(where: { $0.id == furnitureID }) ?? false
        }
        
        func getFavoriteFurnitures() -> [FurnitureItem] {
            return user?.savedFurnitures ?? []
        }
}




var User1 = User(id:UUID(), name: "Tim Cook", email: "cookedtim@apple.com", password: "54321", dateOfBirth: Date(), profilePicture: UIImage(named: "profileImage"), createdDate: Date(), isVerified: true, savedFurnitures: [], roomsByCategory: [:])
