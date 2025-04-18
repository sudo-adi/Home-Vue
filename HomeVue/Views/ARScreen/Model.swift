//
//  Model.swift
//  Temp
//
//  Created by Bhumi on 07/04/25.
//

import SwiftUI
import RealityKit
import Combine

enum ModelCategory: CaseIterable{
    case tablesAndChairs
    case seatingFurniture
    case kitchenFurniture
    case bed
    case decor
    case cabinetsAndShelves
    case dining
    case others
    
    var label: String{
        switch self {
        case .tablesAndChairs:
            return "Tables and Chairs"
        case .decor:
            return "Decoration"
        case .seatingFurniture:
            return "Seating Furniture"
        case .kitchenFurniture:
            return "Kitchen Furniture"
        case .bed:
            return "Bed"
        case .cabinetsAndShelves:
            return "Cabinets and Shelves"
        case .dining:
            return "Dining"
        case .others:
            return "Others"
        }
    }
}

class Model {
    var name: String
    var category: ModelCategory
    var thumbnail: UIImage
    var modelEntity: ModelEntity?
    var scaleCompensation: Float
    
    private var cancellables: AnyCancellable?
    
    init(name: String, category: ModelCategory, scaleCompensation: Float = 1.0){
        self.name = name
        self.category = category
        self.thumbnail = UIImage(named: name) ?? UIImage(systemName : "person.circle")!
        self.scaleCompensation = scaleCompensation
    }
    
    // Helper function to get ModelCategory from model3D filename
    static func getCategoryFromModel3D(_ model3D: String) -> ModelCategory {
        switch model3D {
            case "Table.usdz":
                return .tablesAndChairs
            case "Chair.usdz":
                return .tablesAndChairs
            case "Bed.usdz":
                return .bed
            case "CabinetsAndShelves.usdz":
                return .cabinetsAndShelves
            case "SeatingFurniture.usdz":
                return .seatingFurniture
            case "Decoration.usdz":
                return .decor
            case "Dining.usdz":
                return .dining
            case "KitchenFurniture.usdz":
                return .kitchenFurniture
            case "Others.usdz":
                return .others
            default:
                return .others
        }
    }
    
    //TODO: Create a methof to sasync load modelEntity
    func asyncLoadModelEntity(){
        let filename = self.name + ".usdz"
        
        self.cancellables = ModelEntity.loadModelAsync(named: filename)
            .sink(receiveCompletion: { loadCompletion in
                
                // Handle Error
                switch loadCompletion {
                case .failure(let error): print("Unable to load modelEntity for \(filename). Error: \(error.localizedDescription)")
                case .finished:
                    break
                }
                
            }, receiveValue: { modelEntity in
                
                self.modelEntity = modelEntity
                self.modelEntity?.scale *= self.scaleCompensation
                
                print("modelEntity for \(self.name) has been loaded.")
            })
    }
    
}

struct Models{
    var all: [Model] = []
    
    init() {
        let table = Model(name: "Table", category: .tablesAndChairs, scaleCompensation: 10.0)
        let chair = Model(name: "Chair", category: .tablesAndChairs)
        let bed = Model(name: "Bed", category: .bed, scaleCompensation: 0.35)
        let cabinetsAndShelves = Model(name: "CabinetsAndShelves", category: .cabinetsAndShelves, scaleCompensation: 0.20)
        let seatingFurniture = Model(name: "SeatingFurniture", category: .seatingFurniture)
        let decoration = Model(name: "Decoration", category: .decor)
        let dining = Model(name: "Dining", category: .dining, scaleCompensation: 0.50)
        let kitchenFurniture = Model(name: "KitchenFurniture", category: .kitchenFurniture)
        let others = Model(name: "Others", category: .others)
        
        self.all += [table, chair, bed, seatingFurniture, decoration, cabinetsAndShelves, dining, kitchenFurniture, others]
    }
    
    
    func get(category: ModelCategory) -> [Model] {
        return all.filter { $0.category == category }
    }
}
