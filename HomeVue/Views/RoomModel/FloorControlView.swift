//
//  FloorControlView.swift
//  HomeVue
//
//  Created by Nishtha on 02/05/25.
import SwiftUI

struct FloorControlView: View {
    @Binding var floorTexture: String
    @Binding var isVisible: Bool

    private let availableTextures = [
        ("Default", "DefaultTexture"),
        ("Wood", "WoodFloor"),
        ("Tiles", "TileFloor"),
        ("Marble", "MarbleFloor")
    ]

    var body: some View {
        VStack(spacing: 0) {
            Text("Floor Textures")
                .font(.headline)
                .foregroundColor(.black)
                .padding(.bottom, 12)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 28) {
                    ForEach(availableTextures, id: \.0) { textureName, textureID in
                        VStack(spacing: 8) {
                            FloorTextureOption(
                                name: textureName,
                                textureName: textureID,
                                isSelected: floorTexture == textureID,
                                onSelect: {
                                    floorTexture = textureID
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
        .padding(8)
        .frame(height:300)
        .padding(.bottom,-33)
    }
}
struct FloorTextureOption: View {
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
                } else if textureName == "WoodFloor" {
                    Image("WoodFloor054_1K-JPG_Color")
                        .resizable()
                        .scaledToFill()
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                } else if textureName == "TileFloor" {
                    Image("Tiles079_1K-JPG_Color")
                        .resizable()
                        .scaledToFill()
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                } else if textureName == "MarbleFloor" {
                    Image("Marble014_1K-JPG_Color")
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



