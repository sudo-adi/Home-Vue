//
//  SwiftUIView.swift
//  HomeVue
//
//  Created by Nishtha on 07/05/25.
//

import SwiftUI

struct ExperienceSelectionView: View {
//    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var placementSettings: PlacementSettings
    @StateObject var modelDeletionManager = ModelDeletionManager()
    @State private var showARView = false
    @State private var showRoomScan = false

    var body: some View {
        NavigationStack {
            ZStack(alignment: .topLeading) {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(UIColor.gradientStartColor),
                        Color(UIColor.gradientEndColor)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack(alignment: .leading, spacing: 32) {
//                    HStack {
//                        Button(action: {
//                            presentationMode.wrappedValue.dismiss()
//                        }) {
//                            Image(systemName: "chevron.left")
//                                .foregroundColor(.white)
//                                .padding(10)
//                                .background(Color.black.opacity(0.3))
//                                .clipShape(Circle())
//                        }
//                        Spacer()
//                    }
//                    .padding(.leading, 16)
//                    .padding(.top, 16)

                    Text("Choose Your Experience")
                        .font(.system(size: 32, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.top, 8)
                        .padding(.horizontal, 24)

                    Text("Select how you'd like to visualize your space")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(.white.opacity(0.8))
                        .padding(.horizontal, 24)

                    VStack(spacing: 24) {
                        Button(action: { showRoomScan = true }) {
                            ExperienceCard(
                                icon: Image(systemName: "cube"),
                                title: "Create Room Model",
                                subtitle: "Scan and create detailed 3D model of your room"
                            )
                        }
                        .fullScreenCover(isPresented: $showRoomScan) {
                            RoomScanView()
                        }
                        // NavigationLink(destination:
                        //                ContentView(allowBrowse: true)
                        //                    .environmentObject(PlacementSettings())
                        //                    .environmentObject(SessionSettings())
                        // ) {
                        //     ExperienceCard(
                        //         icon: Image(systemName: "arkit"),
                        //         title: "Try Furniture in AR",
                        //         subtitle: "Instantly place furniture in your space using AR"
                        //     )
                        // }
                        Button(action: { showARView = true }) {
                            ExperienceCard(
                                icon: Image(systemName: "arkit"),
                                title: "Try Furniture in AR",
                                subtitle: "Instantly place furniture in your space using AR"
                            )
                        }
                        .fullScreenCover(isPresented: $showARView) {
                            ContentView(allowBrowse: true)
                                .environmentObject(placementSettings)
                                .environmentObject(modelDeletionManager)
//                                .environmentObject(sessionSettings)
                        }
                    }
                    .padding(.horizontal, 16)
                    Spacer()
                }
                .padding(.top, 30)
            }
            .navigationBarHidden(true)
//            .onAppear {
//                UINavigationBar.appearance().isHidden = true
//                        }
//            .onDisappear {
//                UINavigationBar.appearance().isHidden = false
//            }
        }
    }
}

struct ExperienceCard: View {
    let icon: Image
    let title: String
    let subtitle: String

    var body: some View {
        HStack {
            icon
                .resizable()
                .scaledToFit()
                .frame(width: 36, height: 36)
                .foregroundColor(Color(UIColor.solidBackgroundColor))
                .padding(.trailing, 8)
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                Text(subtitle)
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.8))
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.white.opacity(0.7))
                .font(.system(size: 22, weight: .medium))
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.white.opacity(0.08))
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(Color.white.opacity(0.15), lineWidth: 1)
                )
        )
    }
}
