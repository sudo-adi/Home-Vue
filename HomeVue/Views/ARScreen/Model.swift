//////  Model.swift
//////  Temp
//////
//////  Created by Bhumi on 07/04/25.
//
//import SwiftUI
//import RealityKit
//import Combine
//
//enum ModelCategory: String, CaseIterable, Codable {
//    case tablesAndChairs = "Tables and Chairs"
//    case seatingFurniture = "Seating Furniture"
//    case kitchenFurniture = "Kitchen Furniture"
//    case bed = "Bed"
//    case decor = "Decor"
//    case cabinetAndShelves = "Cabinet and Shelves"
//    case dining = "Dining"
//    case others = "Others"
//    
//    var label: String {
//        switch self {
//        case .tablesAndChairs: return "Tables and Chairs"
//        case .decor: return "Decoration"
//        case .seatingFurniture: return "Seating Furniture"
//        case .kitchenFurniture: return "Kitchen Furniture"
//        case .bed: return "Bed"
//        case .cabinetAndShelves: return "Cabinets and Shelves"
//        case .dining: return "Dining"
//        case .others: return "Others"
//        }
//    }
//}
//
//class Model: Codable, ObservableObject {
//    @Published var name: String
//    @Published var category: ModelCategory
//    @Published var thumbnail: String?
//    @Published var modelEntity: ModelEntity?
//    @Published var scaleCompensation: Float
//    
//    private var cancellables: Set<AnyCancellable> = []
//    
//    init(name: String, category: ModelCategory, thumbnail: String? = nil, modelEntity: ModelEntity? = nil, scaleCompensation: Float) {
//        self.name = name
//        self.category = category
//        self.thumbnail = thumbnail
//        self.modelEntity = modelEntity
//        self.scaleCompensation = scaleCompensation
//    }
//    
//    required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        name = try container.decode(String.self, forKey: .name)
//        let categoryString = try container.decode(String.self, forKey: .category)
//        category = ModelCategory(rawValue: categoryString) ?? .others
//        thumbnail = try container.decodeIfPresent(String.self, forKey: .thumbnail)
//        scaleCompensation = try container.decode(Float.self, forKey: .scaleCompensation)
//    }
//    
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(name, forKey: .name)
//        try container.encode(category.rawValue, forKey: .category)
//        try container.encodeIfPresent(thumbnail, forKey: .thumbnail)
//        try container.encode(scaleCompensation, forKey: .scaleCompensation)
//    }
//
////    @MainActor
////    func asyncLoadModelEntity(from urlString: String?) async throws {
////        guard let urlString = urlString, let remoteURL = URL(string: urlString) else {
////            print("❌ Invalid or missing URL for model \(name)")
////            throw URLError(.badURL)
////        }
////
////        let fileName = remoteURL.lastPathComponent
////        let localURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
////        print("📦 Downloading model to: \(localURL.path)")
////
////        // Download the .usdz file to local temp if not already cached
////        if !FileManager.default.fileExists(atPath: localURL.path) {
////            let (tempURL, _) = try await URLSession.shared.download(from: remoteURL)
////            try FileManager.default.copyItem(at: tempURL, to: localURL)
////        }
////
////        // Load the modelEntity from the local file
////        let modelEntity: ModelEntity = try await withCheckedThrowingContinuation { continuation in
////            var cancellable: AnyCancellable?
////
////            cancellable = ModelEntity.loadModelAsync(contentsOf: localURL)
////                .sink(receiveCompletion: { completion in
////                    if case let .failure(error) = completion {
////                        continuation.resume(throwing: error)
////                        cancellable?.cancel()
////                    }
////                }, receiveValue: { entity in
////                    continuation.resume(returning: entity)
////                    cancellable?.cancel()
////                })
////        }
////
////        // Apply scale and collision
////        modelEntity.scale *= self.scaleCompensation
////        modelEntity.generateCollisionShapes(recursive: true)
////        self.modelEntity = modelEntity
////
////        print("✅ ModelEntity loaded and scaled: \(name) \(modelEntity.scale)")
////    }
//    @MainActor
//        func asyncLoadModelEntity(from urlString: String?) async throws {
//            guard let urlString = urlString, let remoteURL = URL(string: urlString) else {
//                print("❌ Invalid or missing URL for model \(name)")
//                throw URLError(.badURL)
//            }
//
//            let fileName = remoteURL.lastPathComponent
//            let cacheURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent(fileName)
//            print("📍 Checking cache for model at: \(cacheURL.path)")
//
//            // Check if the model is already cached
//            if FileManager.default.fileExists(atPath: cacheURL.path) {
//                print("✅ Model found in cache: \(name)")
//                // Load the modelEntity from the cached file
//                let modelEntity = try await loadModelEntity(from: cacheURL)
//                self.modelEntity = modelEntity
//                print("✅ ModelEntity loaded from cache: \(name) \(modelEntity.scale)")
//                return
//            }
//
//            // Download the .usdz file to cache if not already cached
//            print("📦 Downloading model to: \(cacheURL.path)")
//            let (tempURL, _) = try await URLSession.shared.download(from: remoteURL)
//            try FileManager.default.copyItem(at: tempURL, to: cacheURL)
//
//            // Load the modelEntity from the cached file
//            let modelEntity = try await loadModelEntity(from: cacheURL)
//            self.modelEntity = modelEntity
//            print("✅ ModelEntity loaded and scaled: \(name) \(modelEntity.scale)")
//        }
//
//        @MainActor
//        private func loadModelEntity(from url: URL) async throws -> ModelEntity {
//            let modelEntity: ModelEntity = try await withCheckedThrowingContinuation { continuation in
//                var cancellable: AnyCancellable?
//                cancellable = ModelEntity.loadModelAsync(contentsOf: url)
//                    .sink(receiveCompletion: { completion in
//                        if case let .failure(error) = completion {
//                            continuation.resume(throwing: error)
//                            cancellable?.cancel()
//                        }
//                    }, receiveValue: { entity in
//                        entity.scale *= self.scaleCompensation
//                        entity.generateCollisionShapes(recursive: true)
//                        continuation.resume(returning: entity)
//                        cancellable?.cancel()
//                    })
//            }
//            return modelEntity
//        }
//
//    //TODO: Create a method to async load modelEntity
//   ////    func asyncLoadModelEntity(){
//   ////        let filename = self.name + ".usdz"
//   ////
//   ////        self.cancellables = ModelEntity.loadModelAsync(named: filename)
//   ////            .sink(receiveCompletion: { loadCompletion in
//   ////
//   ////                // Handle Error
//   ////                switch loadCompletion {
//   ////                case .failure(let error): print("Unable to load modelEntity for \(filename). Error: \(error.localizedDescription)")
//   ////                case .finished:
//   ////                    break
//   ////                }
//   ////
//   ////            }, receiveValue: { modelEntity in
//   ////
//   ////                self.modelEntity = modelEntity
//   ////                self.modelEntity?.scale *= self.scaleCompensation
//   ////                self.modelEntity?.generateCollisionShapes(recursive: true)
//   ////                print("modelEntity for \(self.name) has been loaded.")
//   ////            })
//   ////    }
//    ///
//
//
//    enum CodingKeys: String, CodingKey {
//        case name = "name"
//        case category = "furniture_category"
//        case thumbnail = "image_url"
//        case scaleCompensation = "scale_compensation"
//    }
//}
//
//struct Models {
//    var all: [Model] = []
//    
//    func get(category: ModelCategory) -> [Model] {
//        return all.filter { $0.category == category }
//    }
//}
//
import SwiftUI
import RealityKit
import Combine

enum ModelCategory: String, CaseIterable, Codable {
    case tablesAndChairs = "Tables and Chairs"
    case seatingFurniture = "Seating Furniture"
    case kitchenFurniture = "Kitchen Furniture"
    case bed = "Bed"
    case decor = "Decor"
    case cabinetAndShelves = "Cabinet and Shelves"
    case dining = "Dining"
    case others = "Others"
    
    var label: String {
        switch self {
        case .tablesAndChairs: return "Tables and Chairs"
        case .decor: return "Decoration"
        case .seatingFurniture: return "Seating Furniture"
        case .kitchenFurniture: return "Kitchen Furniture"
        case .bed: return "Bed"
        case .cabinetAndShelves: return "Cabinets and Shelves"
        case .dining: return "Dining"
        case .others: return "Others"
        }
    }
}

class Model: Codable, ObservableObject {
    @Published var name: String
    @Published var category: ModelCategory
    @Published var thumbnail: String?
    @Published var modelEntity: ModelEntity?
    @Published var scaleCompensation: Float
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(name: String, category: ModelCategory, thumbnail: String? = nil, modelEntity: ModelEntity? = nil, scaleCompensation: Float) {
        self.name = name
        self.category = category
        self.thumbnail = thumbnail
        self.modelEntity = modelEntity
        self.scaleCompensation = scaleCompensation
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        let categoryString = try container.decode(String.self, forKey: .category)
        category = ModelCategory(rawValue: categoryString) ?? .others
        thumbnail = try container.decodeIfPresent(String.self, forKey: .thumbnail)
        scaleCompensation = try container.decode(Float.self, forKey: .scaleCompensation)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(category.rawValue, forKey: .category)
        try container.encodeIfPresent(thumbnail, forKey: .thumbnail)
        try container.encode(scaleCompensation, forKey: .scaleCompensation)
    }

    @MainActor
    func asyncLoadModelEntity(from urlString: String?) async throws {
        guard let urlString = urlString, let remoteURL = URL(string: urlString) else {
            print("❌ Invalid or missing URL for model \(name)")
            throw URLError(.badURL)
        }

        let fileName = remoteURL.lastPathComponent
        let cacheURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent(fileName)
        print("📍 Checking cache for model at: \(cacheURL.path)")

        // Check if the model is already cached
        if FileManager.default.fileExists(atPath: cacheURL.path) {
            print("✅ Model found in cache: \(name)")
            // Load the modelEntity from the cached file
            let modelEntity = try await loadModelEntity(from: cacheURL)
            self.modelEntity = modelEntity
            print("✅ ModelEntity loaded from cache: \(name) \(modelEntity.scale)")
            return
        }

        // Download the .usdz file to cache if not already cached
        print("📦 Downloading model to: \(cacheURL.path)")
        let (tempURL, _) = try await URLSession.shared.download(from: remoteURL)
        try FileManager.default.copyItem(at: tempURL, to: cacheURL)

        // Load the modelEntity from the cached file
        let modelEntity = try await loadModelEntity(from: cacheURL)
        self.modelEntity = modelEntity
        print("✅ ModelEntity loaded: \(name) \(modelEntity.scale)")
    }

    @MainActor
    private func loadModelEntity(from url: URL) async throws -> ModelEntity {
        let modelEntity: ModelEntity = try await withCheckedThrowingContinuation { continuation in
            var cancellable: AnyCancellable?
            cancellable = ModelEntity.loadModelAsync(contentsOf: url)
                .sink(receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        continuation.resume(throwing: error)
                        cancellable?.cancel()
                    }
                }, receiveValue: { entity in
                    entity.generateCollisionShapes(recursive: true)
                    continuation.resume(returning: entity)
                    cancellable?.cancel()
                })
        }
        return modelEntity
    }

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case category = "furniture_category"
        case thumbnail = "image_url"
        case scaleCompensation = "scale_compensation"
    }
}

struct Models {
    var all: [Model] = []
    
    func get(category: ModelCategory) -> [Model] {
        return all.filter { $0.category == category }
    }
}
