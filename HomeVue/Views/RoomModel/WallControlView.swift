////  WallColorView.swift
////  Sample
////
////  Created by Nishtha on 27/04/25.
//
//
//import SwiftUI
//
//struct WallControlView: View {
//    @Binding var showWalls: Bool
//    @Binding var wallColor: Color
//    @Binding var isVisible: Bool
//    
//    @Binding var wallTexture: String
//    
//    // Define available textures
//    private let availableTextures = [
//        ("Default", "DefaultTexture"),
//        ("Tiles", "Tiles"),
//        ("Brick", "BrickTexture"),
//        ("Wood", "WoodTexture")
//    ]
//
//    var body: some View {
//        if isVisible {
//            VStack(spacing: 6) {
//                HStack {
//                    Button(action: {
//                        withAnimation {
//                            isVisible = false
//                        }
//                    })
//                    {   Text("×")
//                        .font(.system(size: 20, weight: .bold))
//                        .foregroundColor(.white)
//                    }
//                    Spacer()
//                    Text("Wall Controls")
//                        .font(.system(size: 16, weight: .bold))
//                        .foregroundColor(.white)
//                        .lineLimit(1)
//                    
//                  
//                }
//                .padding(.horizontal)
//                .padding(.top,20)
//
//                Toggle(isOn: $showWalls) {
//                    Text("Show Walls")
//                        .foregroundColor(.white)
//                }
//                .padding(.horizontal)
//
//                HStack {
//                    Text("Wall Color")
//                        .foregroundColor(.white)
//                    Spacer()
//                    ColorPicker("", selection: $wallColor)
//                        .labelsHidden()
//                }
//                .padding(.horizontal)
//                
//                VStack(alignment: .leading) {
//                    Text("Wall Texture")
//                        .foregroundColor(.white)
//                        .padding(.horizontal)
//                    
//                    ScrollView(.horizontal, showsIndicators: false) {
//                        HStack(spacing: 12) {
//                            ForEach(availableTextures, id: \.1) { texture in
//                                TextureOption(
//                                    name: texture.0,
//                                    textureName: texture.1,
//                                    isSelected: wallTexture == texture.1,
//                                    onSelect: {
//                                        wallTexture = texture.1
//                                    }
//                                )
//                            }
//                        }
//                        .padding(.horizontal)
//                    }
//                    .frame(height: 80)
//                }
//
//                Spacer()
//            }
//            .frame(width: UIScreen.main.bounds.width * 0.40, height: 220) // Increased height for texture scroll
//            .background(Color(hex: "#4a4551").opacity(0.9))
//            .cornerRadius(12)
//            .padding()
//            .position(x: UIScreen.main.bounds.width - (UIScreen.main.bounds.width * 0.35 / 2) - 10,
//                      y: 220 / 2 + 60) // Adjusted position for new height
//            .transition(.move(edge: .trailing))
//        }
//    }
//}
//
//// Texture option component for the horizontal scroll
//// Update the TextureOption struct to display actual texture previews
//struct TextureOption: View {
//    let name: String
//    let textureName: String
//    let isSelected: Bool
//    let onSelect: () -> Void
//    
//    var body: some View {
//        Button(action: onSelect) {
//            VStack {
//                if textureName == "DefaultTexture" {
//                    RoundedRectangle(cornerRadius: 8)
//                        .fill(Color.gray)
//                        .frame(width: 60, height: 60)
//                } else if textureName == "Tiles" {
//                    Image("Tiles012_1K-JPG_Color")
//                        .resizable()
//                        .scaledToFill()
//                        .frame(width: 60, height: 60)
//                        .cornerRadius(8)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 8)
//                                .stroke(Color.gray, lineWidth: 1)
//                        )
//                } else if textureName == "BrickTexture" {
//                    Image("Brick023_1K-JPG_Color")
//                        .resizable()
//                        .scaledToFill()
//                        .frame(width: 60, height: 60)
//                        .cornerRadius(8)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 8)
//                                .stroke(Color.gray, lineWidth: 1)
//                        )
//                } else if textureName == "WoodTexture" {
//                    Image("Wood026_1K-JPG_Color")
//                        .resizable()
//                        .scaledToFill()
//                        .frame(width: 60, height: 60)
//                        .cornerRadius(8)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 8)
//                                .stroke(Color.gray, lineWidth: 1)
//                        )
//                }
//                
//                Text(name)
//                    .font(.caption)
//                    .foregroundColor(.white)
//            }
//            .padding(4)
//            .background(
//                RoundedRectangle(cornerRadius: 10)
//                    .stroke(isSelected ? Color.white : Color.clear, lineWidth: 2)
//            )
//        }
//    }
//}
//
//
import SwiftUI

struct WallControlView: View {
    @Binding var showWalls: Bool
    @Binding var wallColor: Color
    @Binding var isVisible: Bool
    @Binding var wallTexture: String

    // Define available textures
//    private let availableTextures = [
//        ("Brick", "BrickTexture"),
//        ("Wood", "WoodTexture"),
//        ("Wallpaper", "WallpaperTexture"),
//        ("Paint", "DefaultTexture")
//    ]
    private let availableTextures = [
           ("Default", "DefaultTexture"),
           ("Tiles", "Tiles"),
           ("Brick", "BrickTexture"),
           ("PavingStone", "PavingStoneTexture")
       ]

    var body: some View {
        if isVisible {
            VStack(alignment: .leading, spacing: 24) {
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation {
                            isVisible = false
                        }
                    }) {
                        Text("×")
                            .font(.system(size: 30, weight: .bold))
                            .foregroundColor(.gray)
                    }
                }
                .padding(.top, 30)
                .padding(.trailing, 15)

                // Hide Walls Toggle
                HStack(spacing: 12) {
                    Image(systemName: "eye")
                        .foregroundColor(.primary)
                        .font(.system(size: 22))
                    Text("Hide Walls")
                        .foregroundColor(.primary)
                        .font(.system(size: 18))
                    Spacer()
                    Toggle(isOn: $showWalls) {
                                        Text("Show Walls")
                                            .foregroundColor(.white)
                                    }
                    .labelsHidden()
                    .toggleStyle(SwitchToggleStyle(tint: Color.green))
                }
                .padding(.horizontal)

                // Wall Color
                HStack(spacing: 12) {
                    Image(systemName: "paintpalette")
                        .foregroundColor(.brown)
                        .font(.system(size: 22))
                    Text("Wall Color")
                        .foregroundColor(.primary)
                        .font(.system(size: 18))
                    Spacer()
                        .frame(width: 48, height: 48)
                    ColorPicker("", selection: $wallColor)
                                           .labelsHidden()
                }
                .padding(.horizontal)

                // Wall Textures
                VStack(alignment: .leading, spacing: 8) {
                    Text("Wall Textures")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.primary)
                        .padding(.leading, 12)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 24) {
                            ForEach(availableTextures, id: \.1) { texture in
                                TextureOption(
                                    name: texture.0,
                                    textureName: texture.1,
                                    isSelected: wallTexture == texture.1,
                                    onSelect: {
                                        wallTexture = texture.1
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, 12)
                    }
                    .frame(height: 100)
                }
                Spacer()
            }
            .frame(width: UIScreen.main.bounds.width * 0.95, height: 320)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 10)
            .padding(.top, 24)
            .padding(.horizontal, 8)
            .transition(.move(edge: .bottom))
        }
    }
}

// Texture option component for the horizontal scroll
struct TextureOption: View {
    let name: String
    let textureName: String
    let isSelected: Bool
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            VStack(spacing: 8) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.systemGray6))
                        .frame(width: 72, height: 72)
                    if textureName == "DefaultTexture" {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.systemGray4))
                            .frame(width: 64, height: 64)
                    } else if textureName == "BrickTexture" {
                        Image("PaintedBricks001_1K-JPG_Color")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 64, height: 64)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                        else if textureName == "Tiles" {
                        Image("Tiles039_1K-JPG_Color")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 64, height: 64)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    else if textureName == "PavingStoneTexture" {
                        Image("PavingStones128_1K-JPG_Color")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 64, height: 64)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    if isSelected {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.blue, lineWidth: 3)
                            .frame(width: 72, height: 72)
                    }
                }
                Text(name)
                    .font(.caption)
                    .foregroundColor(.primary)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}
