////  RoomScanView.swift
////  Sample
////
////  Created by Nishtha on 27/04/25.
//import SwiftUI
//import RoomPlan
//
//struct RoomScanView: View {
//    private var roomController = RoomController.shared
//    @State private var doneScanning = false
//    @State private var capturedRoom: CapturedRoom?
//    @State private var navigateToModelView = false
//    @State private var isAnimating = false
//    @State private var scanProgress: CGFloat = 0.0
//    @State private var progressTimer: Timer? = nil
//    
//    var body: some View {
//        NavigationStack {
//            ZStack {
//                RoomCaptureViewRepresentable()
//                    .onAppear {
//                        startScanning()
//                    }
//                    .onDisappear {
//                        // Make sure to invalidate timer and clean up when view disappears
//                        invalidateTimer()
//                        roomController.stopSession()
//                    }
//                
//                // Scanning overlay with animation
//                if !doneScanning {
//                    VStack {
//                        Spacer()
//                        
//                        // Scanning progress indicator
//                        ZStack {
//                            Circle()
//                                .stroke(lineWidth: 8)
//                                .opacity(0.3)
//                                .foregroundColor(.white)
//                            
//                            Circle()
//                                .trim(from: 0, to: scanProgress)
//                                .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round))
//                                .foregroundColor(.blue)
//                                .rotationEffect(.degrees(-90))
//                                .animation(.linear(duration: 1), value: scanProgress)
//                        }
//                        .frame(width: 80, height: 80)
//                        .padding(.bottom, 20)
//                        .opacity(isAnimating ? 1 : 0)
//                        .onAppear {
//                            // Simulate scanning progress with proper timer management
//                            startProgressTimer()
//                        }
//                        
//                        Button("Done Scanning") {
//                            // Properly stop the session and ensure ARSession is paused
//                            roomController.stopSession()
//                            
//                            // Invalidate the timer
//                            invalidateTimer()
//                            
//                            // Complete the progress circle
//                            withAnimation(.easeOut(duration: 0.5)) {
//                                scanProgress = 1.0
//                            }
//                            
//                            // Add a small delay to ensure session cleanup
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                                withAnimation(.spring()) {
//                                    doneScanning = true
//                                }
//                            }
//                            
//                            if let corners = capturedRoom?.walls.first?.polygonCorners {
//                                for corner in corners {
//                                    print("Corner at x:\(corner.x), y:\(corner.y), z:\(corner.z)")
//                                }
//                            }
//                        }
//                        .padding()
//                        .buttonStyle(.borderedProminent)
//                        .clipShape(Capsule())
//                        .padding(.bottom, 20)
//                        .scaleEffect(isAnimating ? 1.0 : 0.8)
//                        .opacity(isAnimating ? 1.0 : 0.0)
//                    }
//                } else {
//                    // Results view with animation
//                    VStack {
//                        Spacer()
//                        
//                        Text("Room Scan Complete!")
//                            .font(.headline)
//                            .padding()
//                            .background(Color.black.opacity(0.7))
//                            .foregroundColor(.white)
//                            .cornerRadius(10)
//                            .padding(.bottom, 20)
//                            .transition(.scale.combined(with: .opacity))
//                        
//                        Button("View Model") {
//                            withAnimation(.spring()) {
//                                // Button press animation
//                            }
//                            
//                            // Delay navigation for animation
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//                                navigateToModelView = true
//                            }
//                        }
//                        .padding()
//                        .buttonStyle(.borderedProminent)
//                        .clipShape(Capsule())
//                        .padding(.bottom, 20)
//                        .transition(.scale.combined(with: .opacity))
//                        
//                        NavigationLink(destination: CapturedRoomView(room: capturedRoom),
//                                       isActive: $navigateToModelView) {
//                            EmptyView()
//                        }
//                        .hidden()
//                    }
//                    .transition(.opacity.combined(with: .move(edge: .bottom)))
//                    .animation(.spring(), value: doneScanning)
//                }
//            }
//            .navigationTitle("Room Scan")
//            .navigationBarHidden(!doneScanning)
//            .toolbar {
//                if doneScanning {
//                    ToolbarItem(placement: .navigationBarTrailing) {
//                        Button("Scan Again") {
//                            withAnimation(.easeInOut) {
//                                // Reset animation before starting new scan
//                                isAnimating = false
//                            }
//                            
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                                startScanning()
//                            }
//                        }
//                        .transition(.scale.combined(with: .opacity))
//                    }
//                }
//            }
//            .onAppear {
//                // Start animations when view appears
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                    withAnimation(.spring()) {
//                        isAnimating = true
//                    }
//                }
//            }
//        }
//    }
//    
//    private func startProgressTimer() {
//        // Invalidate any existing timer first
//        invalidateTimer()
//        
//        // Create a new timer with proper reference
//        progressTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
//            if !doneScanning {
//                scanProgress = min(scanProgress + 0.1, 0.95)
//            } else {
//                invalidateTimer()
//                scanProgress = 1.0
//            }
//        }
//    }
//    
//    private func invalidateTimer() {
//        progressTimer?.invalidate()
//        progressTimer = nil
//    }
//    
//    private func startScanning() {
//        withAnimation {
//            doneScanning = false
//            scanProgress = 0.0
//        }
//        
//        capturedRoom = nil
//        
//        // Ensure any previous ARSessions are properly cleaned up
//        roomController.startSession { room in
//            self.capturedRoom = room
//            
//            // Invalidate the timer when room capture completes
//            invalidateTimer()
//            
//            // Complete the progress circle
//            withAnimation(.easeOut(duration: 0.5)) {
//                scanProgress = 1.0
//            }
//            
//            // Add a small delay before showing completion
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                withAnimation(.spring()) {
//                    self.doneScanning = true
//                }
//            }
//        }
//        
//        // Start animations again
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//            withAnimation(.spring()) {
//                isAnimating = true
//            }
//            
//            // Start the progress timer
//            startProgressTimer()
//        }
//    }
//}
//
//#Preview {
//    RoomScanView()
//}
//
//  RoomScanView.swift
//  Sample
//
//  Created by Nishtha on 27/04/25.
//  RoomScanView.swift
import SwiftUI
import RoomPlan

struct RoomScanView: View {
    @Environment(\.presentationMode) var presentationMode
    private var roomController = RoomController.shared
    @State private var doneScanning = false
    @State private var capturedRoom: CapturedRoom?
    @State private var navigateToModelView = false
    @State private var isAnimating = false
    @State private var scanProgress: CGFloat = 0.0
    @State private var progressTimer: Timer? = nil

    var body: some View {
        NavigationStack {
            ZStack {
                RoomCaptureViewRepresentable()
                    .onAppear {
                        startScanning()
                    }
                    .onDisappear {
                        // Make sure to invalidate timer and clean up when view disappears
                        invalidateTimer()
                        roomController.stopSession()
                    }

                // Scanning overlay with animation
                if !doneScanning {
                    VStack {
                        Spacer()
                        // Scanning progress indicator
                        ZStack {
                            Circle()
                                .stroke(lineWidth: 8)
                                .opacity(0.3)
                                .foregroundColor(.white)

                            Circle()
                                .trim(from: 0, to: scanProgress)
                                .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round))
                                .foregroundColor(.white)
                                .rotationEffect(.degrees(-90))
                                .animation(.linear(duration: 1), value: scanProgress)
                        }
                        .frame(width: 80, height: 80)
                        .padding(.bottom, 20)
                        .opacity(isAnimating ? 1 : 0)
                        .onAppear {
                            // Simulate scanning progress with proper timer management
                            startProgressTimer()
                        }
                    }
                } else {
                    // Results view with animation
                    VStack {
                        Spacer()

                        Text("Room Scan Complete!")
                            .font(.headline)
                            .padding()
                            .background(Color.black.opacity(0.7))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.bottom, 20)
                            .transition(.scale.combined(with: .opacity))

                        Button("View Model") {
                            withAnimation(.spring()) {
                                // Button press animation
                            }

                            // Delay navigation for animation
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                navigateToModelView = true
                            }
                        }
                        .padding()
                        .buttonStyle(.borderedProminent)
                        .clipShape(Capsule())
                        .padding(.bottom, 20)
                        .transition(.scale.combined(with: .opacity))

                        NavigationLink(destination: CapturedRoomView(room: capturedRoom),
                                       isActive: $navigateToModelView) {
                            EmptyView()
                        }
                        .hidden()
                    }
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                    .animation(.spring(), value: doneScanning)
                }
            }
            .navigationTitle("Room Scan")
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.white)
                }
                if !doneScanning {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done Scanning") {
                            roomController.stopSession()
                            invalidateTimer()
                            withAnimation(.easeOut(duration: 0.5)) {
                                scanProgress = 1.0
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                withAnimation(.spring()) {
                                    doneScanning = true
                                }
                            }
                            if let corners = capturedRoom?.walls.first?.polygonCorners {
                                for corner in corners {
                                    print("Corner at x:\(corner.x), y:\(corner.y), z:\(corner.z)")
                                }
                            }
                        }
                        .foregroundColor(.white)
                    }
                }
                if doneScanning {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Scan Again") {
                            withAnimation(.easeInOut) {
                                // Reset animation before starting new scan
                                isAnimating = false
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                startScanning()
                            }
                        }
                        .foregroundColor(.white)
                        .transition(.scale.combined(with: .opacity))
                    }
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    withAnimation(.spring()) {
                        isAnimating = true
                    }
                }
                let appearance = UINavigationBarAppearance()
                appearance.configureWithTransparentBackground()
                appearance.backgroundColor = .clear
                appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
                appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
                UINavigationBar.appearance().standardAppearance = appearance
                UINavigationBar.appearance().scrollEdgeAppearance = appearance
            }
        }
    }

    private func startProgressTimer() {
        // Invalidate any existing timer first
        invalidateTimer()
        // Create a new timer with proper reference
        progressTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            if !doneScanning {
                scanProgress = min(scanProgress + 0.1, 0.95)
            } else {
                invalidateTimer()
                scanProgress = 1.0
            }
        }
    }

    private func invalidateTimer() {
        progressTimer?.invalidate()
        progressTimer = nil
    }

    private func startScanning() {
        withAnimation {
            doneScanning = false
            scanProgress = 0.0
        }
        capturedRoom = nil
        roomController.startSession { room in
            self.capturedRoom = room
            invalidateTimer()
            withAnimation(.easeOut(duration: 0.5)) {
                scanProgress = 1.0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.spring()) {
                    self.doneScanning = true
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.spring()) {
                isAnimating = true
            }
            startProgressTimer()
        }
    }
}

#Preview {
    RoomScanView()
}
