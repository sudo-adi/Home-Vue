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
    var phoneNumber: String?
    var profilePicture: UIImage?
    var createdDate: Date
    var isVerified: Bool
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

    private init() {}

    func setUser(_ user: User) {
        self.user = user
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
}




var User1 = User(id:UUID(), name: "Tim Cook", email: "cookedtim@apple.com", password: "54321", dateOfBirth: Date(), phoneNumber: "0911911911", profilePicture: UIImage(named: "profileImage"), createdDate: Date(), isVerified: true, roomsByCategory: [:])
