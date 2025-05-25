//  AddedFurnitureView.swift
//  Inventory
//
//  Created by Nishtha on 26/04/25.
//
import SwiftUI
import UIKit

struct AddedFurnitureView: View {
    let addedFurnitureItems: [FurnitureItem]
    let onRemove: (FurnitureItem) -> Void
    let onSelect: (FurnitureItem) -> Void
    
    @State private var isAnimating = false
    @State private var selectedItemIndex: Int? = nil
    
    
    var body: some View {
        HStack {
            furnitureScrollView
        }
        .background(backgroundView)
        .cornerRadius(24, corners: [.topLeft, .topRight])
        .ignoresSafeArea(.keyboard)
        .padding(.horizontal, 0)
        .onAppear {
            withAnimation {
                isAnimating = true
            }
        }
        .onDisappear {
            isAnimating = false
        }
    }
    
    private var furnitureScrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(Array(addedFurnitureItems.enumerated()), id: \.element.id) { index, item in
                    furnitureItemView(index: index, item: item)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
        }
        .frame(height: 100)
    }
    
    private func furnitureItemView(index: Int, item: FurnitureItem) -> some View {
        VStack(spacing: 6) {
            ZStack(alignment: .topTrailing) {
                cardBackground(isSelected: selectedItemIndex == index)
                imageView(for: URL(string: item.imageURL ?? ""))
                removeButton(for: item, index: index)
            }
            .onTapGesture {
                withAnimation(.spring()) {
                    selectedItemIndex = index
                    onSelect(item)
                }
            }
            itemNameView(name: item.name!)
        }
        .offset(y: isAnimating ? 0 : 50)
        .opacity(isAnimating ? 1 : 0)
        .animation(
            .spring(response: 0.6, dampingFraction: 0.8)
            .delay(Double(index) * 0.1),
            value: isAnimating
        )
    }
    
    private func cardBackground(isSelected: Bool) -> some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(
                LinearGradient(
                    gradient: Gradient(colors: [.white, .gray.opacity(0.2)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(width: 70, height: 70)
            .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? .brown : .clear, lineWidth: 2)
            )
    }
    
    private func removeButton(for item: FurnitureItem, index: Int) -> some View {
        Button(action: {
            withAnimation(.spring()) {
                onRemove(item)
                if selectedItemIndex == index {
                    selectedItemIndex = nil
                }
            }
        }) {
            ZStack {
                Circle()
                    .fill(.white)
                    .frame(width: 22, height: 22)
                    .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
                
                Image(systemName: "xmark")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.red)
            }
        }
        .offset(x: 8, y: -8)
    }
    
    private func itemNameView(name: String) -> some View {
        Text(name)
            .font(.caption2)
            .lineLimit(1)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(.white.opacity(0.9))
            .clipShape(Capsule())
    }
    
    
    private var backgroundView: some View {
        Color(.systemBackground)
            .opacity(0.95)
            .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: -4)
    }
    
    @ViewBuilder
    private func imageView(for url: URL?) -> some View {
        if let url = url {
            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .padding(8)
                case .empty:
                    ProgressView()
                        .frame(width: 50, height: 50)
                        .padding(8)
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .padding(8)
                        .foregroundColor(.gray)
                @unknown default:
                    EmptyView()
                }
            }
        } else {
            Image(systemName: "photo")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .padding(8)
                .foregroundColor(.gray)
        }
    }
}
