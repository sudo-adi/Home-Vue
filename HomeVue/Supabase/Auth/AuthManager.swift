////
////  Manager.swift
////  HomeVue
////
////  Created by SuperCharge on 15/05/25.
////
//
//import Foundation
//
//class AuthManager{
//    private let authServices: SupabaseAuthService
//    var currentUser: User?
//    
//    init (authServices: SupabaseAuthService = SupabaseAuthService()) {
//        self.authServices = authServices
//    }
//    
//    func signUp(email: String, password: String) async  {
//        do {
//            self.currentUser = try await authServices.signUp(email: email, password: password)
//        } catch{
//            print("DEBUG: SignUp Error: \(error.localizedDescription)")
//        }
//    }
////    func isVerified() -> Bool {
////        
////    }
//    func signIn(email: String, password: String,completion: @escaping (Result<User, Error>) -> Void) async  {
//        do {
//           self.currentUser = try await authServices.signIn(email: email, password: password)
//        } catch{
//            print("DEBUG: SignIn Error: \(error.localizedDescription)")
//        }
//    }
//    func signOut() async  {
//        do {
//            try await authServices.signOut()
//            currentUser = nil
//        } catch{
//            print("DEBUG: SignOut Error: \(error.localizedDescription)")
//        }
//    }
//    func refreshUser() async  {
//        do{
//            self.currentUser = try await authServices.getCurrentUser()
//        } catch{
//            print("RefreshUser Error: \(error)")
//            currentUser = nil
//        }
//    }
//    func updateUserProfile(user: User) async throws {
//            self.currentUser = user
//            UserDetails.shared.setUser(user)
//            try await authServices.saveUserProfile(user: user)
//        }
//    
//}
import Foundation
import UIKit
class AuthManager {
    private let authServices: SupabaseAuthService
    var currentUser: User?
    
    init(authServices: SupabaseAuthService = SupabaseAuthService()) {
        self.authServices = authServices
    }
    
    // Signup with email, password, and name
    func signUp(email: String, password: String, name: String, completion: @escaping (Result<User, Error>) -> Void) {
        Task {
            authServices.signUp(email: email, password: password, name: name) { result in
                switch result {
                case .success(let user):
                    self.currentUser = user
                    UserDetails.shared.setUser(user)
                    completion(.success(user))
                case .failure(let error):
                    print("DEBUG: SignUp Error: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
        }
    }
    
    // Sign in with email and password
    func signIn(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Task {
            authServices.signIn(email: email, password: password) { result in
                switch result {
                case .success(let user):
                    self.currentUser = user
                    UserDetails.shared.setUser(user)
                    completion(.success(user))
                case .failure(let error):
                    print("DEBUG: SignIn Error: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
        }
    }
    
    // Sign out
    func signOut(completion: @escaping (Result<Void, Error>) -> Void) {
        Task {
            authServices.signOut { result in
                switch result {
                case .success:
                    self.currentUser = nil
                    UserDetails.shared.setUser(nil)
                    completion(.success(()))
                case .failure(let error):
                    print("DEBUG: SignOut Error: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
        }
    }
    
    // Refresh user data
    func refreshUser(completion: @escaping (Result<User?, Error>) -> Void) {
        Task {
            authServices.getCurrentUser { result in
                switch result {
                case .success(let user):
                    self.currentUser = user
                    if let user = user {
                        UserDetails.shared.setUser(user)
                    } else {
                        UserDetails.shared.setUser(nil)
                    }
                    completion(.success(user))
                case .failure(let error):
                    print("RefreshUser Error: \(error)")
                    self.currentUser = nil
                    UserDetails.shared.setUser(nil)
                    completion(.failure(error))
                }
            }
        }
    }
    
    // Check and restore session (used at app launch)
    func checkAndRestoreSession(completion: @escaping (Result<User?, Error>) -> Void) {
        Task {
            authServices.checkAndRestoreSession { result in
                switch result {
                case .success(let user):
                    self.currentUser = user
                    if let user = user {
                        UserDetails.shared.setUser(user)
                    } else {
                        UserDetails.shared.setUser(nil)
                    }
                    completion(.success(user))
                case .failure(let error):
                    print("CheckAndRestoreSession Error: \(error)")
                    self.currentUser = nil
                    UserDetails.shared.setUser(nil)
                    completion(.failure(error))
                }
            }
        }
    }
    
    // Update user profile
    func updateUserProfile(user: User, completion: @escaping (Result<Void, Error>) -> Void) {
        Task {
            do {
                try await authServices.saveUserProfile(user: user)
                self.currentUser = user
                UserDetails.shared.setUser(user)
                completion(.success(()))
            } catch {
                print("UpdateUserProfile Error: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    //
    
    // Upload profile image
    func uploadProfileImage(userId: UUID, image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        authServices.uploadProfileImage(userId: userId, image: image) { result in
            switch result {
            case .success(let url):
                // Optionally update currentUser's profilePicture
                if var user = self.currentUser {
                    user.profilePicture = url
                    self.currentUser = user
                    UserDetails.shared.setUser(user)
                }
                completion(.success(url))
            case .failure(let error):
                print("UploadProfileImage Error: \(error)")
                completion(.failure(error))
            }
        }
    }

    // Fetch profile image URL
    func fetchProfileImageURL(userId: UUID, completion: @escaping (Result<String?, Error>) -> Void) {
        authServices.fetchProfileImageURL(userId: userId) { result in
            switch result {
            case .success(let url):
                completion(.success(url))
            case .failure(let error):
                print("FetchProfileImageURL Error: \(error)")
                completion(.failure(error))
            }
        }
    }
}
