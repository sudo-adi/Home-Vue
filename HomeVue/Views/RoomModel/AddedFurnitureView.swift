//  AddedFurnitureView.swift
//  Inventory
//
//  Created by Nishtha on 26/04/25.
//
import SwiftUI
import UIKit

struct AddedFurnitureView: View {
    var addedFurnitureItems: [FurnitureItem]
    var onRemove: (FurnitureItem) -> Void
    var onSelect: (FurnitureItem) -> Void

    @State private var showARView = false
    @State private var isAnimating = false
    @State private var selectedItemIndex: Int? = nil
    
    @EnvironmentObject var placementSettings: PlacementSettings
    @EnvironmentObject var sessionSettings: SessionSettings
    
    var body: some View {
        HStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(Array(addedFurnitureItems.enumerated()), id: \.element.id) { index, item in
                        VStack(spacing: 6) {
                            ZStack(alignment: .topTrailing) {
                                // Card background with gradient
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [Color.white, Color.gray.opacity(0.2)]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 70, height: 70)
                                    .shadow(color: Color.black.opacity(0.15), radius: 4, x: 0, y: 2)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(selectedItemIndex == index ? Color.blue : Color.clear, lineWidth: 2)
                                    )
                                
                                // Furniture image
                                let imageName = item.imageName
                                if let image = UIImage(named: imageName) {
                                    Image(uiImage: image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 50, height: 50)
                                        .padding(8)
                                }
                                
                                // Remove button
                                Button(action: {
                                    withAnimation(.spring()) {
                                        onRemove(item)
                                    }
                                }) {
                                    ZStack {
                                        Circle()
                                            .fill(Color.white)
                                            .frame(width: 22, height: 22)
                                            .shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 1)
                                        
                                        Image(systemName: "xmark")
                                            .font(.system(size: 10, weight: .bold))
                                            .foregroundColor(.brown)
                                    }
                                }
                                .offset(x: 8, y: -8)
                            }
                            .onTapGesture {
                                withAnimation(.spring()) {
                                    selectedItemIndex = index
                                    onSelect(item)
                                }
                            }
                            
                            // Item name with background
                            Text(item.name)
                                .font(.system(size: 10, weight: .medium))
                                .lineLimit(1)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(8)
                        }
                        .offset(y: isAnimating ? 0 : 50)
                        .opacity(isAnimating ? 1 : 0)
                        .animation(
                            .spring(response: 0.6, dampingFraction: 0.8)
                            .delay(Double(index) * 0.1),
                            value: isAnimating
                        )
                    }
                }
                .padding(.leading, 20)
                .padding(.vertical, 10)
            }
            .frame(height: 130)

            Button(action: {
                withAnimation(.spring()) {
                    // Trigger button animation
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    showARView = true
                }
            })
            {
                Divider().frame(height: 100)
                VStack(spacing: 4) {
                    Image(systemName: "arkit")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .padding(12)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(UIColor.gradientStartColor),
                                    Color(UIColor.gradientEndColor)
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .foregroundColor(.white)
                        .clipShape(Circle())
                        .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 3)
                    
                    Text("AR View")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.gray)
                }
                .scaleEffect(isAnimating ? 1.0 : 0.5)
                .opacity(isAnimating ? 1.0 : 0.0)
                .animation(.spring().delay(0.3), value: isAnimating)
            }
            .padding(.trailing, 20)
            .fullScreenCover(isPresented: $showARView) {
                ContentView(allowBrowse: true)
                    .environmentObject(PlacementSettings())
                    .environmentObject(SessionSettings())
            }
        }
        .background(
            Color(.systemGray6)
                .opacity(0.95)
                .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: -4)
        )
        .cornerRadius(24, corners: [.topLeft, .topRight])
        .padding(.horizontal, 0)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation {
                    isAnimating = true
                }
            }
        }
        .onDisappear {
            isAnimating = false
        }
    }
}

extension AnyTransition {
    static var slideUp: AnyTransition {
        AnyTransition.move(edge: .bottom).combined(with: .opacity)
    }
    
    static var slideDown: AnyTransition {
        AnyTransition.move(edge: .top).combined(with: .opacity)
    }
    
    static var fadeWithScale: AnyTransition {
        AnyTransition.opacity.combined(with: .scale)
    }
}
