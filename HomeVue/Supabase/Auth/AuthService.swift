//
//  AuthService.swift
//  HomeVue
//
//  Created by Nishtha on 15/05/25.

import Foundation
import Supabase
import Storage
import UIKit

struct SupabaseAuthService {
    private let client: SupabaseClient
    
    init() {
        self.client = SupabaseClient(
            supabaseURL: URL(string: Constants.projectURLString)!,
            supabaseKey: Constants.projectAPIKeyString
        )
    }
    
    // Signup with email, password, and name
    func signUp(email: String, password: String, name: String, completion: @escaping (Result<User, Error>) -> Void) {
        Task {
            do {
                let response = try await client.auth.signUp(email: email, password: password)
                print("SignUp response: \(response.user)")
                
                guard let email = response.user.email else {
                    throw NSError(domain: "Supabase", code: 400, userInfo: [NSLocalizedDescriptionKey: "Email not found"])
                }
                
                let newUser = User(
                    id: response.user.id,
                    name: name,
                    email: email,
                    dateOfBirth: nil,
                    profilePicture: nil,
                    createdDate: Date(),
                    isVerified: false,
                    savedFurnitures: [],
                    roomsByCategory: [:]
                )
                
                try await saveUserProfile(user: newUser)
                UserDefaults.standard.set(response.user.id.uuidString.lowercased(), forKey: "supabaseAuthId")
                completion(.success(newUser))
            } catch {
                print("SignUp Error: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    // Sign in with email and password
    func signIn(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Task {
            do {
                let response = try await client.auth.signIn(email: email, password: password)
                print("SignIn response: \(response.user)")
                
                guard let email = response.user.email else {
                    throw NSError(domain: "Supabase", code: 400, userInfo: [NSLocalizedDescriptionKey: "Email not found"])
                }
                
                // Fetch user profile from profiles table
                let user = try await fetchUserProfile(userId: response.user.id, email: email)
                UserDefaults.standard.set(response.user.id.uuidString.lowercased(), forKey: "supabaseAuthId")
                completion(.success(user))
            } catch {
                print("SignIn Error: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    // Sign out
    func signOut(completion: @escaping (Result<Void, Error>) -> Void) {
        Task {
            do {
                try await client.auth.signOut()
                UserDefaults.standard.removeObject(forKey: "supabaseAuthId")
                completion(.success(()))
            } catch {
                print("SignOut Error: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    // Check if user is authenticated
    func isAuthenticated() async -> Bool {
        do {
            let session = try await client.auth.session
            return session != nil
        } catch {
            return false
        }
    }
    
    // Restore session
    func restoreSession() async throws {
        let session = try await client.auth.session
        UserDefaults.standard.set(session.user.id.uuidString.lowercased(), forKey: "supabaseAuthId")
    }
    
    // Check and restore session, fetch user profile
    func checkAndRestoreSession(completion: @escaping (Result<User?, Error>) -> Void) {
        Task {
            do {
                let isAuth = await isAuthenticated()
                guard isAuth else {
                    print("No active session found")
                    completion(.success(nil))
                    return
                }
                
                try await restoreSession()
                
                guard let authIdString = UserDefaults.standard.string(forKey: "supabaseAuthId"),
                      let authId = UUID(uuidString: authIdString) else {
                    print("No auth ID found in UserDefaults")
                    completion(.success(nil))
                    return
                }
                
                let response: [User] = try await client
                    .from("profiles")
                    .select()
                    .eq("id", value: authIdString)
                    .limit(1)
                    .execute()
                    .value
                
                guard let user = response.first else {
                    throw NSError(domain: "Supabase", code: 404, userInfo: [NSLocalizedDescriptionKey: "User profile not found"])
                }
                
                print("Session restored for user ID: \(authId)")
                completion(.success(user))
            } catch {
                print("Failed to restore session: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    // Get current user
    func getCurrentUser(completion: @escaping (Result<User?, Error>) -> Void) {
        Task {
            do {
                let supabaseUser = try await client.auth.session.user
                guard let email = supabaseUser.email else {
                    throw NSError(domain: "Supabase", code: 400, userInfo: [NSLocalizedDescriptionKey: "Email not found"])
                }
                let user = try await fetchUserProfile(userId: supabaseUser.id, email: email)
                completion(.success(user))
            } catch {
                print("GetCurrentUser Error: \(error)")
                completion(.failure(error))
            }
        }
    }

    // MARK: - Profile Image CRUD Operations
    func uploadProfileImage(userId: UUID, image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        Task {
            do {
                let isAuth = await isAuthenticated()
                guard isAuth else {
                    completion(.failure(NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])))
                    return
                }

                guard let imageData = image.jpegData(compressionQuality: 0.8) else {
                    completion(.failure(NSError(domain: "ImageConversion", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to data"])))
                    return
                }

                let fileName = "\(userId.uuidString)_profile.jpg"
                let filePath = "ProfileImages/\(fileName)"

                // Upload the image to the "users" bucket
                try await client.storage
                    .from("users")
                    .upload(filePath, data: imageData, options: FileOptions(upsert: true))

                // Get public URL
                guard let publicURL = try? client.storage
                        .from("users")
                        .getPublicURL(path: filePath)
                        .absoluteString else {
                    completion(.failure(NSError(domain: "URLGeneration", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to generate public URL"])))
                    return
                }

                // Update profile
                try await client
                    .from("profiles")
                    .update(["profile_picture": publicURL])
                    .eq("id", value: userId.uuidString)
                    .execute()

                completion(.success(publicURL))
            } catch {
                print("UploadProfileImage Error: \(error)")
                completion(.failure(error))
            }
        }


    }

    // Read: Fetch the profile image URL from the profiles table
    func fetchProfileImageURL(userId: UUID, completion: @escaping (Result<String?, Error>) -> Void) {
        Task {
            do {
                let isAuth = await isAuthenticated()
                guard isAuth else {
                    completion(.failure(NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])))
                    return
                }
                
                let response: [User] = try await client
                    .from("profiles")
                    .select("profile_picture")
                    .eq("id", value: userId.uuidString)
                    .limit(1)
                    .execute()
                    .value
                
                if let profile = response.first, let profilePicture = profile.profilePicture {
                    completion(.success(profilePicture))
                } else {
                    completion(.success(nil)) // No profile picture found
                }
            } catch {
                print("FetchProfileImageURL Error: \(error)")
                completion(.failure(error))
            }
        }
    }

    // Fetch user profile from profiles table
    private func fetchUserProfile(userId: UUID, email: String) async throws -> User {
        let response: [User] = try await client
            .from("profiles")
            .select()
            .eq("id", value: userId.uuidString)
            .execute()
            .value
        
        print("Profile fetch response: \(response)")
        
        if let profile = response.first {
            return profile
        } else {
            // Create a default profile if none exists
            let defaultUser = User(
                id: userId,
                name: nil,
                email: email,
                dateOfBirth: nil,
                profilePicture: nil,
                createdDate: Date(),
                isVerified: false,
                savedFurnitures: [],
                roomsByCategory: [:]
            )
            try await saveUserProfile(user: defaultUser)
            return defaultUser
        }
    }
    
    // Save user profile to profiles table
    func saveUserProfile(user: User) async throws {
        let profileData: [String: Any] = [
            "id": user.id.uuidString,
            "name": user.name as Any,
            "email": user.email as Any,
            "date_of_birth": user.dateOfBirth as Any,
            /*user.dateOfBirth?.ISO8601Format() as Any*/
            "profile_picture": user.profilePicture as Any,
            "created_date": user.createdDate?.ISO8601Format() as Any,
            "is_verified": user.isVerified as Any,
            "saved_furnitures": try? JSONEncoder().encode(user.savedFurnitures),
            "rooms_by_category": try? JSONEncoder().encode(user.roomsByCategory)
        ]
        
        try await client
            .from("profiles")
            .upsert(user)
            .execute()
    }
}
