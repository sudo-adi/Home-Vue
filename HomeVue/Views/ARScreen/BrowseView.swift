//////
//////  BrowseView.swift
//////  ARFurniture
//////
//////  Created by Bhumi on 07/04/25.
//////
////
////import SwiftUI
////
////struct BrowseView: View {
////    @Binding var showBrowse: Bool
////    
////    
////    var body: some View {
////        NavigationView{
////            ScrollView(showsIndicators: false){
////                ModelsByCategoryGrid(showBrowse: $showBrowse)
////            }
////            .navigationBarTitle(Text("Browse"),displayMode: .large)
////            .navigationBarItems(trailing:
////                Button(action: {
////                    self.showBrowse.toggle()
////                }) {
////                    Text("Done").bold()
////                })
////        }
////    }
////}
////
////struct ModelsByCategoryGrid: View{
////    @Binding var showBrowse: Bool
////
////       let models = Models()
////    
////    var body: some View {
////        VStack {
////            ForEach(ModelCategory.allCases, id: \.self){ category in
////                
////                let modelsByCategory = models.get(category: category)
////                if !modelsByCategory.isEmpty {
////                    HorizontalGrid(showBrowse: $showBrowse, title: category.label, items: modelsByCategory)
////                }
////
////            }
////        }
////    }
////}
////
////
////struct HorizontalGrid: View {
////    @EnvironmentObject var placementSettings: PlacementSettings
////    @Binding var showBrowse: Bool
////    var title: String
////    var items: [Model]
////    private let gridItemLayout = [GridItem(.fixed(150))]
////
////    var body: some View {
////        VStack(alignment: .leading) {
////            Seperator()
////
////            Text(title)
////                .font(.title2).bold()
////                .padding(.leading, 22)
////                .padding(.top, 10)
////
////            ScrollView(.horizontal, showsIndicators: false) {
////                LazyHGrid(rows: gridItemLayout, spacing: 30) {
////                    ForEach(0..<items.count, id: \.self) { index in
////                        let model = items[index]
////                        
////                        ItemButton(model: model) {
//////                            model.asyncLoadModelEntity(model.modelEntity)
////                            self.placementSettings.selectedModel = model
////                            print("BrowseView : select \(model.name) for the placement")
////                            self.showBrowse = false
////                        }
////                    }
////                }
////                .padding(.horizontal, 22)
////                .padding(.vertical, 10)
////            }
////        }
////    }
////}
////
////
////
//////struct ItemButton: View {
//////    let model: Model
//////    let action: () -> Void
//////    var body: some View {
//////        Button(action:{
//////            self.action()
//////        }) {
//////            Image(uiImage: self.model.)
//////                .resizable()
//////                .frame(height: 150)
//////                .aspectRatio(1/1, contentMode: .fit)
//////                .cornerRadius(8.0)
//////        }
//////    }
//////}
////struct ItemButton: View {
////    let model: Model
////    let action: () -> Void
////
////    @ViewBuilder
////    var imageView: some View {
////        if let urlString = model.thumbnail, let url = URL(string: urlString) {
////            AsyncImage(url: url) { phase in
////                switch phase {
////                case .empty:
////                    ProgressView()
////                        .frame(height: 150)
////                case .success(let image):
////                    image
////                        .resizable()
////                        .aspectRatio(1/1, contentMode: .fit)
////                        .frame(height: 150)
////                        .cornerRadius(8.0)
////                case .failure:
////                    placeholderImage
////                @unknown default:
////                    placeholderImage
////                }
////            }
////        } else {
////            placeholderImage
////        }
////    }
////
////    private var placeholderImage: some View {
////        Image(systemName: "photo")
////            .resizable()
////            .foregroundColor(.gray)
////            .aspectRatio(1/1, contentMode: .fit)
////            .frame(height: 150)
////            .cornerRadius(8.0)
////    }
////
////    var body: some View {
////        Button(action: {
////            self.action()
////        }) {
////            imageView
////        }
////    }
////}
////
////struct Seperator: View {
////    var body: some View {
////        Divider()
////            .padding(.horizontal, 20)
////            .padding(.vertical, 10)
////    }
////}
//// BrowseView.swift
//import SwiftUI
//
//struct BrowseView: View {
//    @Binding var showBrowse: Bool
//    @StateObject private var viewModel = BrowseViewModel()
//    
//    var body: some View {
//        NavigationView {
//            ScrollView(showsIndicators: false) {
//                ModelsByCategoryGrid(showBrowse: $showBrowse, viewModel: viewModel)
//            }
//            .navigationBarTitle(Text("Browse"), displayMode: .large)
//            .navigationBarItems(trailing:
//                Button(action: {
//                    self.showBrowse.toggle()
//                }) {
//                    Text("Done").bold()
//                })
//            .task {
//                await viewModel.loadModels()
//            }
//            .overlay {
//                if viewModel.isLoading {
//                    ProgressView("Loading models...")
//                }
//            }
//        }
//    }
//}
//
//@MainActor
//class BrowseViewModel: ObservableObject {
//    @Published var models: [ModelCategory: [Model]] = [:]
//    @Published var isLoading = false
//    
//    func loadModels() async {
//        isLoading = true
//        defer { isLoading = false }
//        
//        for category in ModelCategory.allCases {
//            do {
//                let fetchedModels = try await SupabaseManager.shared.fetchFurnitureItemModel(for: category)
//                models[category] = fetchedModels
//            } catch {
//                print("Failed to load models for \(category.rawValue): \(error)")
//            }
//        }
//    }
//}
//
//struct ModelsByCategoryGrid: View {
//    @Binding var showBrowse: Bool
//    @ObservedObject var viewModel: BrowseViewModel
//    
//    var body: some View {
//        VStack {
//            ForEach(ModelCategory.allCases, id: \.self) { category in
//                if let models = viewModel.models[category], !models.isEmpty {
//                    HorizontalGrid(showBrowse: $showBrowse, title: category.label, items: models)
//                }
//            }
//        }
//    }
//}
//
//struct HorizontalGrid: View {
//    @EnvironmentObject var placementSettings: PlacementSettings
//    @Binding var showBrowse: Bool
//    let title: String
//    let items: [Model]
//    private let gridItemLayout = [GridItem(.fixed(150))]
//    
//    var body: some View {
//        VStack(alignment: .leading) {
//            Seperator()
//            
//            Text(title)
//                .font(.title2).bold()
//                .padding(.leading, 22)
//                .padding(.top, 10)
//            
//            ScrollView(.horizontal, showsIndicators: false) {
//                LazyHGrid(rows: gridItemLayout, spacing: 30) {
//                    ForEach(items, id: \.name) { model in
//                        ItemButton(model: model) {
//                            placementSettings.selectedModel = model
//                            print("BrowseView: Selected \(model.name) for placement")
//                            showBrowse = false
//                        }
//                        .disabled(model.modelEntity == nil)
//                    }
//                }
//                .padding(.horizontal, 22)
//                .padding(.vertical, 10)
//            }
//        }
//    }
//}
//
//struct ItemButton: View {
//    @ObservedObject var model: Model
//    let action: () -> Void
//    
//    var body: some View {
//        Button(action: {
//            action()
//        }) {
//            if let urlString = model.thumbnail, let url = URL(string: urlString) {
//                AsyncImage(url: url) { phase in
//                    switch phase {
//                    case .empty:
//                        ProgressView()
//                            .frame(height: 150)
//                    case .success(let image):
//                        image
//                            .resizable()
//                            .aspectRatio(1/1, contentMode: .fit)
//                            .frame(height: 150)
//                            .cornerRadius(8.0)
//                    case .failure:
//                        placeholderImage
//                    @unknown default:
//                        placeholderImage
//                    }
//                }
//            } else {
//                placeholderImage
//            }
//        }
//        .disabled(model.modelEntity == nil)
//    }
//    
//    private var placeholderImage: some View {
//        Image(systemName: "photo")
//            .resizable()
//            .foregroundColor(.gray)
//            .aspectRatio(1/1, contentMode: .fit)
//            .frame(height: 150)
//            .cornerRadius(8.0)
//    }
//}
//
//struct Seperator: View {
//    var body: some View {
//        Divider()
//            .padding(.horizontal, 20)
//            .padding(.vertical, 10)
//    }
//}
import SwiftUI

struct BrowseView: View {
    @Binding var showBrowse: Bool
    @StateObject private var viewModel = BrowseViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                ModelsByCategoryGrid(showBrowse: $showBrowse, viewModel: viewModel)
            }
            .navigationBarTitle(Text("Browse"), displayMode: .large)
            .navigationBarItems(trailing:
                Button(action: {
                    self.showBrowse.toggle()
                }) {
                    Text("Done").bold()
                })
            .task {
                await viewModel.loadModels()
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView("Loading models...")
                }
            }
        }
    }
}

@MainActor
class BrowseViewModel: ObservableObject {
    @Published var models: [ModelCategory: [Model]] = [:]
    @Published var isLoading = false
    
    func loadModels() async {
        isLoading = true
        defer { isLoading = false }
        
        // Configure URLCache for image caching
        let cache = URLCache.shared
        let cacheSizeMemory = 100 * 1024 * 1024 // 100 MB
        let cacheSizeDisk = 500 * 1024 * 1024 // 500 MB
        URLCache.shared = URLCache(memoryCapacity: cacheSizeMemory, diskCapacity: cacheSizeDisk, diskPath: "thumbnailCache")
        
        for category in ModelCategory.allCases {
            do {
                let fetchedModels = try await SupabaseManager.shared.fetchFurnitureItemModel(for: category)
                models[category] = fetchedModels
            } catch {
                print("Failed to load models for \(category.rawValue): \(error)")
            }
        }
    }
}

struct ModelsByCategoryGrid: View {
    @Binding var showBrowse: Bool
    @ObservedObject var viewModel: BrowseViewModel
    
    var body: some View {
        VStack {
            ForEach(ModelCategory.allCases, id: \.self) { category in
                if let models = viewModel.models[category], !models.isEmpty {
                    HorizontalGrid(showBrowse: $showBrowse, title: category.label, items: models)
                }
            }
        }
    }
}

struct HorizontalGrid: View {
    @EnvironmentObject var placementSettings: PlacementSettings
    @Binding var showBrowse: Bool
    let title: String
    let items: [Model]
    private let gridItemLayout = [GridItem(.fixed(150))]
    
    var body: some View {
        VStack(alignment: .leading) {
            Seperator()
            
            Text(title)
                .font(.title2).bold()
                .padding(.leading, 22)
                .padding(.top, 10)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: gridItemLayout, spacing: 30) {
                    ForEach(items, id: \.name) { model in
                        ItemButton(model: model) {
                            Task {
                                if model.modelEntity == nil {
                                    do {
                                        try await model.asyncLoadModelEntity(from: model.thumbnail)
                                    } catch {
                                        print("Failed to load model entity for \(model.name): \(error)")
                                    }
                                }
                                if let modelEntity = model.modelEntity {
                                    // Apply scaling when the model is selected for placement
                                    print(model.name)
                                    print(model.scaleCompensation)
                                    modelEntity.scale *= model.scaleCompensation
                                    print("Applied scale \(model.scaleCompensation) to \(model.name) \(modelEntity.scale) at placement")
                                }
                                placementSettings.selectedModel = model
                                print("BrowseView: Selected \(model.name) for placement")
                                showBrowse = false
                            }
                        }
                        .disabled(model.modelEntity == nil && model.thumbnail == nil)
                    }
                }
                .padding(.horizontal, 22)
                .padding(.vertical, 10)
            }
        }
    }
}

struct ItemButton: View {
    @ObservedObject var model: Model
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }) {
            if let urlString = model.thumbnail, let url = URL(string: urlString) {
                AsyncImage(url: url, transaction: Transaction(animation: .easeInOut)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(height: 150)
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(1/1, contentMode: .fit)
                            .frame(height: 150)
                            .cornerRadius(8.0)
                    case .failure:
                        placeholderImage
                    @unknown default:
                        placeholderImage
                    }
                }
            } else {
                placeholderImage
            }
        }
        .disabled(model.modelEntity == nil && model.thumbnail == nil)
    }
    
    private var placeholderImage: some View {
        Image(systemName: "photo")
            .resizable()
            .foregroundColor(.gray)
            .aspectRatio(1/1, contentMode: .fit)
            .frame(height: 150)
            .cornerRadius(8.0)
    }
}

struct Seperator: View {
    var body: some View {
        Divider()
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
    }
}
