import SwiftUI

struct BrowseView: View {
    @Binding var showBrowse: Bool
    
    
    var body: some View {
        NavigationView{
            ScrollView(showsIndicators: false){
                ModelsByCategoryGrid(showBrowse: $showBrowse)
            }
            .navigationBarTitle(Text("Browse"),displayMode: .large)
            .navigationBarItems(trailing:
                Button(action: {
                    self.showBrowse.toggle()
                }) {
                    Text("Done").bold()
                })
        }
    }
}

struct ModelsByCategoryGrid: View{
    @Binding var showBrowse: Bool

       let models = Models()
    
    var body: some View {
        VStack {
            ForEach(ModelCategory.allCases, id: \.self){ category in
                
                let modelsByCategory = models.get(category: category)
                if !modelsByCategory.isEmpty {
                    HorizontalGrid(showBrowse: $showBrowse, title: category.label, items: modelsByCategory)
                }

            }
        }
    }
}


struct HorizontalGrid: View {
    @EnvironmentObject var placementSettings: PlacementSettings
    @Binding var showBrowse: Bool
    var title: String
    var items: [Model]
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
                .padding(.vertical, 10)
            }
        }
    }
}



struct ItemButton: View {
    let model: Model
    let action: () -> Void
    var body: some View {
        Button(action:{
            self.action()
        }) {
            Image(uiImage: self.model.thumbnail)
                .resizable()
                .frame(height: 150)
                .aspectRatio(1/1, contentMode: .fit)
                .cornerRadius(8.0)
        }
    }
}

struct Seperator: View {
    var body: some View {
        Divider()
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
    }
}
