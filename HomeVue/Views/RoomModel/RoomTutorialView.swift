import SwiftUI
import AVKit

struct TutorialVideo {
    let fileName: String
    let title: String
    let caption: String
}

struct RoomTutorialView: View {
    @Binding var isPresented: Bool
    @State private var currentPage = 0
    
    private let tutorials: [TutorialVideo] = [
        TutorialVideo(
            fileName: "InsertFurniture",
            title: "Insert Furniture",
            caption: "Select the furniture from the inventory by clicking on the + button, Tap in the room model to place the furniture."
        ),
        TutorialVideo(
            fileName: "RotateFurniture",
            title: "Rotate Furniture",
            caption: "To select the model, Double tap on the model, or tap on the furniture in thr bottom bar. Drag the furniture to move it around the room. Use slider to rotate."
        ),
        TutorialVideo(
            fileName: "ChangeWallAndFloorTexture",
            title: "Change Wall & Floor",
            caption: "Explore wall color, wall textures and floor textures by clicking on the paintbrush icon."
        )
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                TabView(selection: $currentPage) {
                    ForEach(0..<tutorials.count, id: \.self) { index in
                        TutorialPageView(tutorial: tutorials[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .automatic))
                
                HStack {
                    if currentPage > 0 {
                        Button("Previous") {
                            withAnimation {
                                currentPage -= 1
                            }
                        }
                        .buttonStyle(.bordered)
                    }
                    
                    Spacer()
                    
                    if currentPage < tutorials.count - 1 {
                        Button("Next") {
                            withAnimation {
                                currentPage += 1
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    } else {
                        Button("Done") {
                            isPresented = false
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
                .padding()
            }
            .navigationTitle("Room Tutorial")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Skip") {
                        isPresented = false
                    }
                }
            }
        }
    }
}

//struct TutorialPageView: View {
//    let tutorial: TutorialVideo
//    @State private var player: AVQueuePlayer?
//    @State private var playerLooper: AVPlayerLooper?
//    
//    var body: some View {
//        VStack(spacing: 6) {
//            Text(tutorial.title)
//                .font(.title)
//                .fontWeight(.bold)
//            
//            Text(tutorial.caption)
//                .font(.body)
//                .multilineTextAlignment(.center)
//                .padding(.horizontal)
////                .padding(.top, 8)
//                .fixedSize(horizontal: false, vertical: true)
//
//            
//            let videoURL: URL? = Bundle.main.url(forResource: tutorial.fileName, withExtension: "mov")
//            if let videoURL = videoURL {
//                ZStack {
//                    VideoPlayer(player: player)
//                        .frame(width: 220, height: 475)
//                        .cornerRadius(33)
//                        .onAppear {
//                            player = AVQueuePlayer()
//                            let playerItem = AVPlayerItem(url: videoURL)
//                            playerLooper = AVPlayerLooper(player: player!, templateItem: playerItem)
//                            player?.play()
//                        }
//                        .onDisappear {
//                            player?.pause()
//                        }
//                    Image("iphone14")
//                        .resizable()
//                        .frame(width: 605, height: 644)
//                        .aspectRatio(contentMode: .fit)
//                        .allowsHitTesting(false)
//                }
//                .padding(.top,-30)
//                .frame(width: 260, height: 540)
//            } else {
//                Text("Video not found")
//                    .foregroundColor(.red)
//            }
//            
//        }
//        .padding()
//    }
//}

struct TutorialPageView: View {
    let tutorial: TutorialVideo
    @State private var player: AVQueuePlayer?
    @State private var playerLooper: AVPlayerLooper?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Video section first
                let videoURL: URL? = Bundle.main.url(forResource: tutorial.fileName, withExtension: "mov")
                if let videoURL = videoURL {
                    ZStack {
                        VideoPlayer(player: player)
                            .frame(width: 220, height: 475)
                            .cornerRadius(33)
                            .onAppear {
                                player = AVQueuePlayer()
                                let playerItem = AVPlayerItem(url: videoURL)
                                playerLooper = AVPlayerLooper(player: player!, templateItem: playerItem)
                                player?.play()
                            }
                            .onDisappear {
                                player?.pause()
                            }
                        
                        Image("iphone14")
                            .resizable()
                            .frame(width: 605, height: 644)
                            .aspectRatio(contentMode: .fit)
                            .allowsHitTesting(false)
                    }
                    .frame(width: 260, height: 540)
                } else {
                    Text("Video not found")
                        .foregroundColor(.red)
                }
                
                // Title & Caption
                VStack(spacing: 6) {
                    Text(tutorial.title)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text(tutorial.caption)
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .padding()
        }
    }
}

#Preview {
    RoomTutorialView(isPresented: .constant(true))
} 
