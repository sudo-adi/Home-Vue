////  WallColorView.swift
////  Sample
////
////  Created by Nishtha on 27/04/25.
//
//
import SwiftUI
struct WallControlView: View {
    @Binding var showWalls: Bool
    @Binding var wallColor: Color
    @Binding var isVisible: Bool
    @Binding var wallTexture: String

    private let availableTextures = [
        ("Default", "DefaultTexture"),
        ("Tiles", "Tiles"),
        ("Brick", "BrickTexture"),
        ("PavingStone", "PavingStoneTexture")
    ]

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Show Walls")
                    .foregroundColor(.black)
                    .font(.system(size: 18))
                Spacer()
                Toggle(isOn: $showWalls) {
                    EmptyView()
                }
                .labelsHidden()
                .toggleStyle(SwitchToggleStyle(tint: Color.green))
            }
            .padding(.horizontal, 30)
            .padding(.vertical, 10)

            HStack {
                Text("Wall Color")
                    .foregroundColor(.black)
                    .font(.system(size: 18))
                Spacer()
                ColorPicker("", selection: $wallColor)
                    .labelsHidden()
            }
            .padding(.horizontal, 30)
            .padding(.vertical, 10)
            VStack{
                Text("Wall Textures")
//                    .font(.headline)
                    .foregroundColor(.black)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(availableTextures, id: \.0) { textureName, textureID in
                            VStack(spacing: 5) {
                                WallTextureOption(
                                    name: textureName,
                                    textureName: textureID,
                                    isSelected: wallTexture == textureID,
                                    onSelect: {
                                        wallTexture = textureID
                                    }
                                )
                                .frame(width: 70, height: 70)
                                Text(textureName)
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 8)
                }
            }
        }
        .frame(height: 300)
    }
}

enum ControlSegment: String, CaseIterable {
    case wall = "Wall"
    case floor = "Floor"
}

struct FloorAndWallSegmentedControlView: View {
    @Binding var wallTexture: String
    @Binding var wallColor: Color
    @Binding var showWalls: Bool
    @Binding var floorTexture: String
    @Binding var isVisible: Bool

    @State private var selectedSegment: ControlSegment = .wall
    @State private var dragOffset: CGFloat = 0

    var body: some View {
        VStack(spacing: 0) {
            
            RoundedRectangle(cornerRadius: 3)
                .fill(Color.black.opacity(0.15))
                .frame(width: 70, height: 5)
                .padding(.top, 12)
                .padding(.bottom, 10)

            Picker("", selection: $selectedSegment) {
                ForEach(ControlSegment.allCases, id: \.self) { segment in
                    Text(segment.rawValue).tag(segment)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal, 24)
//            .padding(.bottom, 12)

            if selectedSegment == .wall{
                WallControlView(
                    showWalls: $showWalls,
                    wallColor: $wallColor,
                    isVisible: $isVisible,
                    wallTexture: $wallTexture
                )
                .frame(height: 300)
            } else {
                FloorControlView(
                    floorTexture: $floorTexture,
                    isVisible: $isVisible
                )
                .frame(height: 200)
            }
        }
        .background(
            Color.white
                .clipShape(RoundedCorner(radius: 24, corners: [.topLeft, .topRight]))
        )
        .padding(.top, 0)
        .edgesIgnoringSafeArea(.bottom)
        .shadow(radius: 5)
        .frame(maxWidth: .infinity)
        .transition(.move(edge: .bottom))
        .offset(y: dragOffset)
        .gesture(
            DragGesture()
                .onChanged { value in
                    if value.translation.height > 0 {
                        dragOffset = value.translation.height
                    }
                }
                .onEnded { value in
                    if value.translation.height > 80 {
                        isVisible = false
                    }
                    dragOffset = 0
                }
        )
    }
}

// Reuse your existing FloorTextureOption and WallTextureOption views here
struct WallTextureOption: View {
    let name: String
    let textureName: String
    let isSelected: Bool
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            ZStack {
                if textureName == "DefaultTexture" {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.green.opacity(0.15))
                } else if textureName == "BrickTexture" {
                    Image("PaintedBricks001")
                        .resizable()
                        .scaledToFill()
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                } else if textureName == "Tiles" {
                    Image("Tiles039")
                        .resizable()
                        .scaledToFill()
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                } else if textureName == "PavingStoneTexture" {
                    Image("PavingStones128")
                        .resizable()
                        .scaledToFill()
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
//                RoundedRectangle(cornerRadius: 16)
                Circle()
                    .stroke(isSelected ? Color.white : Color.clear, lineWidth: 3)
            }
        }
        .frame(width: 70, height: 70)
        .padding(20)
    }
}
