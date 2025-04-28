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
    
    static func getScaleCompensation(_ model3D: String) -> Float {
        switch model3D {
        case "Table.usdz":
            return 9.0
        case "SeatingFurniture.usdz":
            return 0.40
        case "Bed.usdz":
            return 0.28
        case "CabinetsAndShelves.usdz":
            return 0.28
        case "Dining.usdz":
            return 0.50
        default:
            return 1.0
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
                self.modelEntity?.generateCollisionShapes(recursive: true)
                print("modelEntity for \(self.name) has been loaded.")
            })
    }
    
}

struct Models{
    var all: [Model] = []
    
    init() {
        let table = Model(name: "Table", category: .tablesAndChairs, scaleCompensation: Model.getScaleCompensation("Table.usdz"))
        let chair = Model(name: "Chair", category: .tablesAndChairs, scaleCompensation: Model.getScaleCompensation("Chair.usdz"))
        let bed = Model(name: "Bed", category: .bed, scaleCompensation: Model.getScaleCompensation("Bed.usdz"))
        let cabinetsAndShelves = Model(name: "CabinetsAndShelves", category: .cabinetsAndShelves, scaleCompensation: Model.getScaleCompensation("CabinetsAndShelves.usdz"))
        let seatingFurniture = Model(name: "SeatingFurniture", category: .seatingFurniture, scaleCompensation: Model.getScaleCompensation("SeatingFurniture.usdz"))
        let decoration = Model(name: "Decoration", category: .decor, scaleCompensation: Model.getScaleCompensation("Decoration.usdz"))
        let dining = Model(name: "Dining", category: .dining, scaleCompensation: Model.getScaleCompensation("Dining.usdz"))
        let kitchenFurniture = Model(name: "KitchenFurniture", category: .kitchenFurniture, scaleCompensation: Model.getScaleCompensation("KitchenFurniture.usdz"))
        let others = Model(name: "Others", category: .others, scaleCompensation: Model.getScaleCompensation("Others.usdz"))
        
        self.all += [table, chair, bed, seatingFurniture, decoration, cabinetsAndShelves, dining, kitchenFurniture, others]
    }
    
    
    func get(category: ModelCategory) -> [Model] {
        return all.filter { $0.category == category }
    }
}
