////
////  BrowseView.swift
////  ARFurniture
////
////  Created by Bhumi on 07/04/25.
////
//
//import SwiftUI
//
//struct BrowseView: View {
//    @Binding var showBrowse: Bool
//    
//    
//    var body: some View {
//        NavigationView{
//            ScrollView(showsIndicators: false){
//                ModelsByCategoryGrid(showBrowse: $showBrowse)
//            }
//            .navigationBarTitle(Text("Browse"),displayMode: .large)
//            .navigationBarItems(trailing:
//                Button(action: {
//                    self.showBrowse.toggle()
//                }) {
//                    Text("Done").bold()
//                })
//        }
//    }
//}
//
//struct ModelsByCategoryGrid: View{
//    @Binding var showBrowse: Bool
//
//       let models = Models()
//    
//    var body: some View {
//        VStack {
//            ForEach(ModelCategory.allCases, id: \.self){ category in
//                
//                let modelsByCategory = models.get(category: category)
//                if !modelsByCategory.isEmpty {
//                    HorizontalGrid(showBrowse: $showBrowse, title: category.label, items: modelsByCategory)
//                }
//
//            }
//        }
//    }
//}
//
//
//struct HorizontalGrid: View {
//    @EnvironmentObject var placementSettings: PlacementSettings
//    @Binding var showBrowse: Bool
//    var title: String
//    var items: [Model]
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
//                    ForEach(0..<items.count, id: \.self) { index in
//                        let model = items[index]
//                        
//                        ItemButton(model: model) {
//                            model.asyncLoadModelEntity()
//                            self.placementSettings.selectedModel = model
//                            print("BrowseView : select \(model.name) for the placement")
//                            self.showBrowse = false
//                        }
//                    }
//                }
//                .padding(.horizontal, 22)
//                .padding(.vertical, 10)
//            }
//        }
//    }
//}
//
//
//
//struct ItemButton: View {
//    let model: Model
//    let action: () -> Void
//    var body: some View {
//        Button(action:{
//            self.action()
//        }) {
//            Image(uiImage: self.model.thumbnail)
//                .resizable()
//                .frame(height: 150)
//                .aspectRatio(1/1, contentMode: .fit)
//                .cornerRadius(8.0)
//        }
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
//  BrowseView.swift
//  ARFurniture
//
//  Created by Bhumi on 07/04/25.
//

import SwiftUI

struct BrowseView: View {
    @Binding var showBrowse: Bool
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView{
            ScrollView(showsIndicators: false){
                ModelsByCategoryGrid(showBrowse: $showBrowse)
                    .padding(.bottom, 20)
            }
            .background(colorScheme == .dark ? Color.black.opacity(0.9) : Color.gray.opacity(0.1))
            .navigationBarTitle(Text("Browse"), displayMode: .large)
            .navigationBarItems(trailing:
                Button(action: {
                    self.showBrowse.toggle()
                }) {
                    Text("Done")
                        .fontWeight(.semibold)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                })
        }
    }
}

struct ModelsByCategoryGrid: View{
    @Binding var showBrowse: Bool
    let models = Models()
    
    var body: some View {
        VStack(spacing: 5) {
            ForEach(ModelCategory.allCases, id: \.self){ category in
                
                let modelsByCategory = models.get(category: category)
                if !modelsByCategory.isEmpty {
                    HorizontalGrid(showBrowse: $showBrowse, title: category.label, items: modelsByCategory)
                }
            }
        }
        .padding(.top, 10)
    }
}
struct HorizontalGrid: View {
    @EnvironmentObject var placementSettings: PlacementSettings
    @Binding var showBrowse: Bool
    var title: String
    var items: [Model]
    private let gridItemLayout = [GridItem(.fixed(120))]
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {

            Text(title)
                .font(.headline)
                .fontWeight(.bold)
                .padding(.leading, 22)
                .padding(.top, 8)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: gridItemLayout, spacing: 15) {
                    ForEach(0..<items.count, id: \.self) { index in
                        let model = items[index]
                        
                        ItemButton(model: model) {
                            model.asyncLoadModelEntity()
                            self.placementSettings.selectedModel = model
                            print("BrowseView : select \(model.name) for the placement")
                            self.showBrowse = false
                        }
                    }
                }
                .padding(.horizontal, 22)
                .padding(.vertical, 8)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(colorScheme == .dark ? Color.gray.opacity(0.15) : Color.white)
                .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
        )
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
    }
}

struct ItemButton: View {
    let model: Model
    let action: () -> Void
    @State private var isHovered = false
    
    var body: some View {
        Button(action:{
            self.action()
        }) {
            VStack {
                Image(uiImage: self.model.thumbnail)
                    .resizable()
                    .frame(width: 100, height: 100)
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(8.0)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.blue.opacity(isHovered ? 0.8 : 0), lineWidth: 2)
                    )
                    .shadow(color: Color.black.opacity(0.2), radius: 3, x: 0, y: 2)
                
                Text(model.name)
                    .font(.caption)
                    .foregroundColor(.primary)
                    .lineLimit(1)
            }
            .padding(5)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.1))
                    .opacity(isHovered ? 1 : 0)
            )
            .onHoverEffect(isHovered: $isHovered)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct Seperator: View {
    var body: some View {
        Divider()
            .padding(.horizontal, 20)
            .padding(.vertical, 5)
    }
}

extension View {
    func onHoverEffect(isHovered: Binding<Bool>) -> some View {
        #if os(macOS)
        return self.onHover { hovering in
            isHovered.wrappedValue = hovering
        }
        #else
        return self // iOS doesn't support hover, so return self
        #endif
    }
}
