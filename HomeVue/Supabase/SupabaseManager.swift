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

//let supabase = SupabaseClient(supabaseURL: URL(string: Constants.projectURLString)!,
//                              supabaseKey: Constants.projectAPIKeyString)

class SupabaseManager{
    static let shared = SupabaseManager()
    private let client: SupabaseClient
    
    private init() {
        client = SupabaseClient(supabaseURL: URL(string: Constants.projectURLString)!,
                                supabaseKey: Constants.projectAPIKeyString)
    }
    
    func fetchFurnitureCategories() async throws -> [FurnitureCategory] {
        let response: [FurnitureCategory] = try await client
            .from("furniture_categories")
            .select()
            .execute()
            .value
        
        return response
    }
    
    func fetchFurnitureItems(for categoryType: FurnitureCategoryType) async throws -> [FurnitureItem] {
        let response: [FurnitureItem] = try await client
            .from("furniture_items")
            .select()
            .eq("furniture_category", value: categoryType.rawValue)
            .execute()
            .value
        
        return response
    }
    
//    func fetchFurnitureItems(for categoryId: UUID) async throws -> [FurnitureItem] {
//        let response: [FurnitureItem] = try await client
//            .from("furniture_items")
//            .select()
//            .eq("furniture_category", value: categoryId.uuidString)
//            .execute()
//            .value
//        
//        return response
//    }
}
