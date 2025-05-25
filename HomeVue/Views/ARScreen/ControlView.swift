import SwiftUI

struct ControlView: View {
    @Binding var showBrowse: Bool
    @State private var toastMessage: String = ""
    @State private var showToast: Bool = false
    var allowBrowse: Bool
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                
                // Always show ControlButtonBar
                ControlButtonBar(showBrowse: $showBrowse, allowBrowse: allowBrowse, onScreenshot: { message in
                    toastMessage = message
                    withAnimation {
                        showToast = true
                    }
                    // Hide toast after 2 seconds
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            showToast = false
                        }
                    }
                })
            }
            
            // Center toast overlay
            if showToast {
                ToastView(message: toastMessage)
                    .transition(.opacity)
                    .zIndex(1) // Ensure toast appears above other content
            }
        }
    }
}

struct ControlButtonBar: View {
    @Binding var showBrowse: Bool
    var allowBrowse: Bool
    let onScreenshot: (String) -> Void
    
    var body: some View {
        HStack {
            Spacer()
            
            //Screenshot Button
            ControlButton(systemIconName: "camera.fill") {
                print("Screenshot button pressed")
                takeScreenshot()
            }
            
            if(allowBrowse) {
                Spacer()
                //Browse Button
                ControlButton(systemIconName: "square.grid.2x2") {
                    print("Browse button pressed.")
                    self.showBrowse.toggle()
                }
                .sheet(isPresented: $showBrowse) {
                    BrowseView(showBrowse: $showBrowse)
                }
            }
            
            Spacer()
        }
        .frame(maxWidth: 500)
        .padding(30)
        .background(Color.black.opacity(0.25))
    }
    
    private func takeScreenshot() {
        print("Taking screenshot...")
        guard let window = UIApplication.shared.connectedScenes
            .filter({ $0.activationState == .foregroundActive })
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows
            .first(where: { $0.isKeyWindow }) else {
                print("Failed to get window")
                onScreenshot("Error: Could not access window")
                return
        }
        
        print("Got window, creating renderer...")
        let renderer = UIGraphicsImageRenderer(size: window.bounds.size)
        let screenshotImage = renderer.image { _ in
            window.drawHierarchy(in: window.bounds, afterScreenUpdates: true)
        }
        
        print("Screenshot taken, saving to photo album...")
        let imageSaver = ImageSaver(
            onSuccess: {
                print("Screenshot saved successfully")
                onScreenshot("Screenshot saved to Photos")
            },
            onError: { error in
                print("Error saving screenshot: \(error.localizedDescription)")
                onScreenshot("Error saving image: \(error.localizedDescription)")
            }
        )
        
        imageSaver.writeToPhotoAlbum(image: screenshotImage)
    }
}

struct ControlButton: View {
    let systemIconName: String
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            self.action()
        }) {
            Image(systemName: systemIconName)
                .font(.system(size: 35))
                .foregroundColor(.white)
                .buttonStyle(PlainButtonStyle())
        }
        .frame(width: 50, height: 50)
    }
}
