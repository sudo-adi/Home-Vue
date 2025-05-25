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
    
}
