import SwiftUI

struct FurnitureCatalogueView: View {
    @State private var isShowingCategories = true
    @State private var currentCategory: FurnitureCategoryType?
    @Binding var isToolbarVisible: Bool

    private let furnitureDataProvider = FurnitureDataProvider.shared

    // Callback to parent when a furniture item is added
    var onAddFurniture: ((FurnitureItem) -> Void)? = nil

    private let catalogueWidth = UIScreen.main.bounds.width * 0.35
    private let catalogueHeight = UIScreen.main.bounds.height * 0.5

    var body: some View {
        ZStack {
            if isToolbarVisible {
                toolbarContent
                    .transition(.move(edge: .trailing))
            }
        }
    }

    private var toolbarContent: some View {
        VStack(spacing: 0) {
            toolbarHeader
            Divider().background(Color.white.opacity(0.5))

            if isShowingCategories {
                categoriesView
            } else if let category = currentCategory {
                itemsView(for: category)
            }
        }
        .frame(width: catalogueWidth, height: catalogueHeight)
        .background(
            Color(hex: "#4a4551").opacity(0.8)
                .background(BlurView(style: .dark))
        )
        .cornerRadius(12)
        .padding(.top, 60)
        .position(x: UIScreen.main.bounds.width - (catalogueWidth / 2) - 10,
                  y: catalogueHeight / 2 + 60)
    }

    private var toolbarHeader: some View {
        HStack {
            Button(action: {
                withAnimation {
                    isToolbarVisible = false
                }
            }) {
                Text("×")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
            }
            Spacer()
            Text("Inventory")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
                .lineLimit(1)
            Spacer()
        }
        .padding()
        .padding(.leading,0)
    }

    private var categoriesView: some View {
        ScrollView {
            VStack(spacing: 10) {
                ForEach(FurnitureCategoryType.allCases, id: \.self) { category in
                    Button(action: {
                        withAnimation {
                            currentCategory = category
                            isShowingCategories = false
                        }
                    }) {
                        VStack {
                            Image(category.thumbnail)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 80)
                                .padding(.horizontal, 8)

                            Text(category.rawValue)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding(4)
                                .background(Color(hex: "#F0F0F0"))
                                .cornerRadius(5)
                        }
                        .frame(width: catalogueWidth - 20, height: 120)
                        .background(Color.white)
                        .cornerRadius(10)
                    }
                }
            }
            .padding(.horizontal, 10)
            .padding(.bottom, 20)
        }
    }

//    private func itemsView(for category: FurnitureCategoryType) -> some View {
//        let items = furnitureDataProvider.fetchFurnitureItems(for: category)
//
//        return ScrollView {
//            VStack(spacing: 10) {
//                Button(action: {
//                    withAnimation {
//                        isShowingCategories = true
//                    }
//                }) {
//                    HStack {
//                        Image(systemName: "arrow.left")
//                        Text("Back")
//                    }
//                    .foregroundColor(.white)
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .padding(.leading, 10)
//                }
//
//                ForEach(items, id: \.id) { item in
//                    VStack {
//                        HStack {
//                            Button(action: {
//                                onAddFurniture?(item)
//                            }) {
//                                Image(systemName: "plus")
//                                    .foregroundColor(.white)
//                                    .frame(width: 24, height: 24)
//                                    .background(Color(hex: "#393231"))
//                                    .cornerRadius(12)
//                            }
//                            Spacer()
//                        }
//                        .padding(.leading, 10)
//
//                        Image(uiImage: item.image)
//                            .resizable()
//                            .scaledToFit()
//                            .frame(height: 50)
//                            .padding(.horizontal, 10)
//
//                        Text(item.name)
//                            .font(.system(size: 12, weight: .medium))
//                            .foregroundColor(.black)
//                            .frame(maxWidth: .infinity)
//                            .padding(4)
//                            .background(Color(hex: "#F0F0F0"))
//                            .cornerRadius(5)
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 5)
//                                    .stroke(Color.black, lineWidth: 1)
//                            )
//                            .padding(.horizontal, 10)
//                    }
//                    .frame(width: catalogueWidth - 20, height: 120)
//                    .background(Color.white)
//                    .cornerRadius(10)
//                }
//            }
//            .padding(.horizontal, 10)
//        }
//    }
    private func itemsView(for category: FurnitureCategoryType) -> some View {
        let items = furnitureDataProvider.fetchFurnitureItems(for: category)

        return ScrollView {
            VStack(spacing: 10) {
                Button(action: {
                    withAnimation {
                        isShowingCategories = true
                    }
                }) {
                    HStack {
                        Image(systemName: "arrow.left")
                        Text("Back")
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 10)
                }

                ForEach(items, id: \.id) { item in
                    VStack {
                        HStack {
                            Button(action: {
                                onAddFurniture?(item)
                            }) {
                                Image(systemName: "plus")
                                    .foregroundColor(.white)
                                    .frame(width: 24, height: 24)
                                    .background(Color(hex: "#393231"))
                                    .cornerRadius(12)
                            }
                            Spacer()
                        }
                        .padding(.leading, 10)

                        let imageName = item.imageName
                        if let uiImage = UIImage(named: imageName) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 50)
                                .padding(.horizontal, 10)
                        } else {
                            Image("placeholder")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 50)
                                .padding(.horizontal, 10)
                        }

                        Text(item.name)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding(4)
                            .background(Color(hex: "#F0F0F0"))
                            .cornerRadius(5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.black, lineWidth: 1)
                            )
                            .padding(.horizontal, 10)
                    }
                    .frame(width: catalogueWidth - 20, height: 120)
                    .background(Color.white)
                    .cornerRadius(10)
                }
            }
            .padding(.horizontal, 10)
        }
    }
}
extension String {
    func removingFileExtension() -> String? {
        let components = self.split(separator: ".")
        return components.first.map { String($0) }
    }
}
// Helper extensions and blur view
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default: (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

struct BlurView: UIViewRepresentable {
    let style: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}
