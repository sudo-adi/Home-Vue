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
        VStack {
            HStack {
                Text("Floor Textures")
                    .font(.headline)
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: {
                    withAnimation {
                        isVisible = false
                    }
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 22))
                }
            }
            .padding(.horizontal)
            .padding(.top, 12)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(availableTextures, id: \.0) { textureName, textureID in
                        FloorTextureOption(
                            name: textureName,
                            textureName: textureID,
                            isSelected: floorTexture == textureID,
                            onSelect: {
                                floorTexture = textureID
                            }
                        )
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
            }
        }
        .background(Color(hex: "#4a4551"))
        .cornerRadius(12)
        .shadow(radius: 5)
        .padding()
        .frame(maxWidth: .infinity)
        .transition(.move(edge: .bottom))
    }
}

struct FloorTextureOption: View {
    let name: String
    let textureName: String
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            VStack {
                if textureName == "DefaultTexture" {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.green.opacity(0.7))
                        .frame(width: 60, height: 60)
                } else if textureName == "WoodFloor" {
                    Image("WoodFloor054_1K-JPG_Color")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 60, height: 60)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                }
                    //else if textureName == "TilesFloor2"{
//                    Image("Tiles043_1K-JPG_Color")
//                        .resizable()
//                        .scaledToFill()
//                        .frame(width: 60, height: 60)
//                        .cornerRadius(8)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 8)
//                                .stroke(Color.gray, lineWidth: 1)
//                        )
//                }
                else if textureName == "TileFloor" {
                    Image("Tiles079_1K-JPG_Color")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 60, height: 60)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                } else if textureName == "MarbleFloor" {
                    Image("Marble014_1K-JPG_Color")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 60, height: 60)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                }
                
                Text(name)
                    .font(.caption)
                    .foregroundColor(.white)
            }
            .padding(4)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isSelected ? Color.white : Color.clear, lineWidth: 2)
            )
        }
    }
}
//#Preview {
//    
//}


