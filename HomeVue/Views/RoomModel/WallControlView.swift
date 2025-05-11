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
            Text("Wall Textures")
                .font(.headline)
                .foregroundColor(.black)
                .padding(.bottom, 12)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 28) {
                    ForEach(availableTextures, id: \.0) { textureName, textureID in
                        VStack(spacing: 8) {
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
            .padding(.horizontal, 24)
            .padding(.vertical, 8)

            HStack {
                Text("Wall Color")
                    .foregroundColor(.black)
                    .font(.system(size: 18))
                Spacer()
                ColorPicker("", selection: $wallColor)
                    .labelsHidden()
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 8)
        }
        .frame(height: 300)
    }
}

enum ControlSegment: String, CaseIterable {
    case floor = "Floor"
    case wall = "Wall"
}

struct FloorAndWallSegmentedControlView: View {
    @Binding var floorTexture: String
    @Binding var wallTexture: String
    @Binding var wallColor: Color
    @Binding var showWalls: Bool
    @Binding var isVisible: Bool

    @State private var selectedSegment: ControlSegment = .floor
    @State private var dragOffset: CGFloat = 0

    var body: some View {
        VStack(spacing: 0) {
            // Drag indicator
            RoundedRectangle(cornerRadius: 2.5)
                .fill(Color.black.opacity(0.15))
                .frame(width: 40, height: 5)
                .padding(.top, 12)
                .padding(.bottom, 8)

            Picker("", selection: $selectedSegment) {
                ForEach(ControlSegment.allCases, id: \.self) { segment in
                    Text(segment.rawValue).tag(segment)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal, 24)
            .padding(.bottom, 12)

            if selectedSegment == .floor {
                FloorControlView(
                    floorTexture: $floorTexture,
                    isVisible: $isVisible
                )
            } else {
                WallControlView(
                    showWalls: $showWalls,
                    wallColor: $wallColor,
                    isVisible: $isVisible,
                    wallTexture: $wallTexture
                )
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
                    Image("PaintedBricks001_1K-JPG_Color")
                        .resizable()
                        .scaledToFill()
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                } else if textureName == "Tiles" {
                    Image("Tiles039_1K-JPG_Color")
                        .resizable()
                        .scaledToFill()
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                } else if textureName == "PavingStoneTexture" {
                    Image("PavingStones128_1K-JPG_Color")
                        .resizable()
                        .scaledToFill()
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 3)
            }
        }
        .frame(width: 70, height: 70)
    }
}
