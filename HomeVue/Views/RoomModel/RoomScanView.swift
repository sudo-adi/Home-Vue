////  RoomScanView.swift
////  Sample
////
////  Created by Nishtha on 27/04/25.
import SwiftUI
import RoomPlan

struct RoomScanView: View {
    @Environment(\.presentationMode) var presentationMode
    private var roomController = RoomController.shared
    @State private var doneScanning = false
    @State private var capturedRoom: CapturedRoom?
    @State private var navigateToModelView = false
    @State private var isAnimating = false

    var body: some View {
        NavigationStack {
            ZStack {
                RoomCaptureViewRepresentable()
                    .onAppear {
                        startScanning()
                    }
                    .onDisappear {
                        roomController.stopSession()
                    }

                if doneScanning {
                    VStack {
                        Spacer()
                        // Removed Edit Model button from here
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
            .onAppear {
                setNavigationBarHidden(true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    withAnimation(.spring()) {
                        isAnimating = true
                    }
                }
            }
            .onDisappear {
                setNavigationBarHidden(true)
            }
            .toolbarBackground(Color.clear, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                // Only show Cancel when not done scanning
//                if !doneScanning {
//                    ToolbarItem(placement: .navigationBarLeading) {
//                        Button("Cancel") {
//                            presentationMode.wrappedValue.dismiss()
//                        }
//                        .foregroundColor(.black)
//                    }
//                }
                if !doneScanning {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") {
                            roomController.stopSession()
                            withAnimation(.spring()) {
                                doneScanning = true
                            }
                            if let corners = capturedRoom?.walls.first?.polygonCorners {
                                for corner in corners {
                                    print("Corner at x:\(corner.x), y:\(corner.y), z:\(corner.z)")
                                }
                            }
                        }
                        .foregroundColor(.black)
                    }
                }
                if doneScanning {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Scan Again") {
                            withAnimation(.easeInOut) {
                                isAnimating = false
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                startScanning()
                            }
                        }
                        .foregroundColor(.black)
                        .transition(.scale.combined(with: .opacity))
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Edit Model") {
                            withAnimation(.spring()) {}
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                navigateToModelView = true
                            }
                        }
                        .foregroundColor(.black)
                    }
                }
            }
        }
    }

    private func setNavigationBarHidden(_ hidden: Bool) {
        UIApplication.shared.windows.first?.rootViewController?
            .navigationController?.navigationBar.isTranslucent = true
    }

    private func startScanning() {
        withAnimation {
            doneScanning = false
        }
        capturedRoom = nil
        roomController.startSession { room in
            self.capturedRoom = room
            withAnimation(.spring()) {
                self.doneScanning = true
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.spring()) {
                isAnimating = true
            }
        }
    }
}

#Preview {
    RoomScanView()
}
