////
////  UserDataModel.swift
////  dummy
////
////  Created by student-2 on 15/01/25.
////
//
import Foundation
import Supabase


struct User: Identifiable, Codable {
    let id: UUID
    var name: String?
    var email: String
    var dateOfBirth: String?
    var profilePicture: String?
    var createdDate: Date?
    var isVerified: Bool?
    var savedFurnitures: [FurnitureItem]?
    private(set) var roomsByCategory: [RoomCategoryType: [RoomModel]]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
        case dateOfBirth = "date_of_birth"
        case profilePicture = "profile_picture"
        case createdDate = "created_date"
        case isVerified = "is_verified"
        case savedFurnitures = "saved_furnitures"
        case roomsByCategory = "rooms_by_category"
    }
    
    // Fetch user profile from Supabase
    static func fetchUser(withId id: UUID, client: SupabaseClient, completion: @escaping (Result<User, Error>) -> Void) {
        Task {
            do {
                let response: [User] = try await client
                    .from("profiles")
                    .select()
                    .eq("id", value: id.uuidString)
                    .limit(1)
                    .execute()
                    .value
                
                if let user = response.first {
                    completion(.success(user))
                } else {
                    completion(.failure(NSError(domain: "Supabase", code: 404, userInfo: [NSLocalizedDescriptionKey: "User profile not found"])))
                }
            } catch {
                print("Error fetching user: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    // Update user profile in Supabase
    func updateUser(client: SupabaseClient, completion: @escaping (Result<Void, Error>) -> Void) {
        Task {
            do {
                try await client
                    .from("profiles")
                    .update(self)
                    .eq("id", value: id.uuidString)
                    .execute()
                
                completion(.success(()))
            } catch {
                print("Error updating user: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    mutating func addRoom(_ room: RoomModel, category: RoomCategoryType) {
        if roomsByCategory == nil {
            roomsByCategory = [:]
        }
        if roomsByCategory![category] == nil {
            roomsByCategory![category] = []
        }
        roomsByCategory![category]?.append(room)
    }
    
    mutating func removeRoom(byId roomId: UUID, category: RoomCategoryType) {
        roomsByCategory?[category]?.removeAll { $0.details.id == roomId }
    }
    
    func listRooms(inCategory category: RoomCategoryType) -> [RoomModel] {
        return roomsByCategory?[category] ?? []
    }
    }

class UserDetails {
    static let shared = UserDetails()
    private(set) var user: User?
    private var favoriteFurnitures: Set<UUID> = []
    private init() {}
    
    func setUser(_ user: User?) {
        if let user = user {
            let defaults = UserDefaults.standard
            let savedFurnitureIdsStrings = defaults.array(forKey: "savedFurnitureIds_\(user.id.uuidString)") as? [String] ?? []
            let savedFurnitureIds = savedFurnitureIdsStrings.compactMap { UUID(uuidString: $0) }
            
            var savedFurnitures: [FurnitureItem] = []
//            let allCategories = FurnitureDataProvider.shared.getFurnitureCategories()
//            for category in allCategories {
//                for item in category.furnitureItems {
//                    if savedFurnitureIds.contains(item.id) {
//                        savedFurnitures.append(item)
//                    }
//                }
//            }
            var updatedUser = user
            updatedUser.savedFurnitures = savedFurnitures
            self.user = updatedUser
        } else {
            self.user = nil
        }
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
    
    func toggleSave(furnitureItem: FurnitureItem) {
        if var currentUser = user {
            if let index = currentUser.savedFurnitures?.firstIndex(where: { $0.id == furnitureItem.id }) {
                currentUser.savedFurnitures?.remove(at: index)
            } else {
                if currentUser.savedFurnitures == nil {
                    currentUser.savedFurnitures = []
                }
                currentUser.savedFurnitures?.append(furnitureItem)
            }
            self.user = currentUser
            saveUserData()
        }
    }
    
    private func saveUserData() {
        guard let user = user else { return }
        let defaults = UserDefaults.standard
        let savedFurnitureIdsStrings = user.savedFurnitures?.map { $0.id!.uuidString } ?? []
        defaults.set(savedFurnitureIdsStrings, forKey: "savedFurnitureIds_\(user.id.uuidString)")
        defaults.synchronize()
    }
    
    func isFavoriteFurniture(furnitureID: UUID) -> Bool {
        return user?.savedFurnitures?.contains(where: { $0.id == furnitureID }) ?? false
    }
    
    func getFavoriteFurnitures() -> [FurnitureItem] {
        return user?.savedFurnitures ?? []
    }
}

