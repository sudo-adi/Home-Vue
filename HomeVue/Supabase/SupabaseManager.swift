//
//  Supabase.swift
//  HomeVue
//
//  Created by SuperCharge on 13/05/25.
//

import Supabase
import Foundation
enum Constants{
    static let projectURLString = "https://idgndjdksopovczqdeby.supabase.co"
    static let projectAPIKeyString = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlkZ25kamRrc29wb3ZjenFkZWJ5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDcxMjgxMTAsImV4cCI6MjA2MjcwNDExMH0.SMe_3Ebz2P1oc-poMLYBTaDn6s7ew8AHqRrPbPdlzUY"
}

class SupabaseManager{
    static let shared = SupabaseManager()
    private let client: SupabaseClient
    
    private init() {
        client = SupabaseClient(supabaseURL: URL(string: Constants.projectURLString)!,
                                supabaseKey: Constants.projectAPIKeyString)
    }
    
    func fetchFurnitureItems(for categoryType: FurnitureCategoryType) async throws -> [FurnitureItem] {
    print("Fetching furniture items for category: \(categoryType.rawValue)")
    let response: [FurnitureItem] = try await client
        .from("furniture_items")
        .select()
        .eq("furniture_category", value: "\(categoryType.rawValue)")
        .execute()
        .value
    print("Fetched \(response.count) items")
    return response
}
    func fetchFurnitureItemModel(for category: ModelCategory) async throws -> [Model] {
        print("📡 Fetching furniture items for category: \(category.rawValue)")

        let response: [FurnitureItem] = try await client
            .from("furniture_items")
            .select()
            .eq("furniture_category", value: category.rawValue)
            .execute()
            .value

        var models: [Model] = []

        // Use TaskGroup for parallel model loading
        try await withThrowingTaskGroup(of: Model?.self) { group in
            for item in response {
                guard
                    let name = item.name,
                    let modelURL = item.model3D
                else {
                    print("⚠️ Skipping invalid item: \(item)")
                    continue
                }

                let modelCategory = ModelCategory(rawValue: item.category.rawValue) ?? .others
                let model = Model(
                    name: name,
                    category: modelCategory,
                    thumbnail: item.imageURL,
                    scaleCompensation: Float(item.scaleCompenstation)
                )

                group.addTask {
                    do {
                        try await model.asyncLoadModelEntity(from: modelURL)
                        return model
                    } catch {
                        print("❌ Failed to load modelEntity for \(name): \(error.localizedDescription)")
                        return nil
                    }
                }
            }

            // Collect results
            for try await model in group {
                if let model = model {
                    models.append(model)
                }
            }
        }

        print("✅ Fetched and loaded \(models.count) models for \(category.label)")
        return models
    }
//    func fetchFurnitureItemModel(for category: ModelCategory) async throws -> [Model] {
//        print("📡 Fetching furniture items for category: \(category.rawValue)")
//
//        let response: [FurnitureItem] = try await client
//            .from("furniture_items")
//            .select()
//            .eq("furniture_category", value: category.rawValue)
//            .execute()
//            .value
//
//        var models: [Model] = []
//
//        for item in response {
//            guard
//                let name = item.name,
//                let modelURL = item.model3D
//            else {
//                print("⚠️ Skipping invalid item: \(item)")
//                continue
//            }
//
//            let modelCategory = ModelCategory(rawValue: item.category.rawValue) ?? .others
//
//            let model = Model(
//                name: name,
//                category: modelCategory,
//                thumbnail: item.imageURL,
//                scaleCompensation: Float(item.scaleCompenstation)
//            )
//
//            do {
//                try await model.asyncLoadModelEntity(from: modelURL)
//                models.append(model)
//            } catch {
//                print("❌ Failed to load modelEntity for \(name): \(error.localizedDescription)")
//            }
//        }
//
//        print("✅ Fetched and loaded \(models.count) models for \(category.label)")
//        return models
//    }

//    func fetchFurnitureItemModel(for category: ModelCategory) async throws -> [Model] {
//            print("Fetching furniture items for category: \(category.rawValue)")
//            let response: [FurnitureItem] = try await client
//                .from("furniture_items")
//                .select()
//                .eq("furniture_category", value: category.rawValue)
//                .execute()
//                .value
//            
//            var models: [Model] = []
//            for item in response {
//                let category = Model.getCategoryFromModel3D(item.model3D ?? "Others.usdz")
//                let scale = Model.getScaleCompensation(item.model3D ?? "Others.usdz")
//                let model = Model(
//                    name: item.name ?? "Unnamed",
//                    category: category,
//                    thumbnail: item.imageURL,
//                    scaleCompensation: scale
//                )
//                try await model.asyncLoadModelEntity(from: item.model3D!)
//                models.append(model)
//            }
//            
//            print("Fetched and loaded \(models.count) models")
//            return models
//        }
//
    
}
