//
//  ControlView.swift
//  ARFurniture
//
//  Created by student-2 on 03/04/25.
//

import SwiftUI

struct ControlView: View{
    @Binding var isControlVisible: Bool
    @Binding var showBrowse: Bool
    @Binding var showSettings: Bool
    var allowBrowse: Bool
    
     var body: some View{
        
        VStack{
            ControlVisibilityToggleButton(isControlVisible: $isControlVisible)
            
            Spacer()
            
            if isControlVisible{
                ControlButtonBar(showBrowse: $showBrowse, showSettings: $showSettings, allowBrowse: allowBrowse)
            }
        }
    }
}

struct ControlVisibilityToggleButton: View {
    @Binding var isControlVisible: Bool
    
    var body: some View {
        HStack{
            Spacer()
            ZStack{
                Color.black.opacity(0.25)
                
                Button(action: {
                    print("Control visibility toggle button   pressed")
                    self.isControlVisible.toggle()
                }){
                    Image(systemName: self.isControlVisible ? "rectangle" : "slider.horizontal.below.rectangle")
                        .font(.system(size: 25))
                        .foregroundColor(.white)
                        .buttonStyle(PlainButtonStyle())
                }
            }
            .frame(width:50,height: 50)
            .cornerRadius(8.0)
        }
        .padding(.top,45)
        .padding(.trailing, 20)
    }
}

struct ControlButtonBar: View {
    @State private var toastMessage = ""
    @State private var showToast = false
    @Binding var showBrowse: Bool
    @Binding var showSettings: Bool
    var allowBrowse: Bool

    var body: some View {
        HStack {

            //Screenshot Button
            ControlButton(systemIconName: "camera.fill"){
                takeScreenshot()
            }
            
            Spacer()
            
            if allowBrowse {
                //Browse Button
                ControlButton(systemIconName: "square.grid.2x2"){
                    print("Browse button pressed.")
                    self.showBrowse.toggle()
                }.sheet(isPresented: $showBrowse, content: {
                    BrowseView(showBrowse: $showBrowse)
                })
                
                Spacer()
            }
            
            //Settings Button
            ControlButton(systemIconName: "slider.horizontal.3"){
                print("settings button pressed.")
                self.showSettings.toggle()
            }.sheet(isPresented: $showSettings){
                SettingsView(showSettings: $showSettings)
            }
            
            
        }.frame(maxWidth: 500)
            .padding(30)
            .background(Color.black.opacity(0.25))
        
//        ToastView(message: toastMessage, isShowing: $showToast)
    }
    
    private func takeScreenshot() {
            guard let window = UIApplication.shared.connectedScenes
                .filter({ $0.activationState == .foregroundActive })
                .compactMap({ $0 as? UIWindowScene })
                .first?.windows
                .first(where: { $0.isKeyWindow }) else {
                    toastMessage = "Error: Could not access window"
                    showToast = true
                    return
                }
            
            let renderer = UIGraphicsImageRenderer(size: window.bounds.size)
            let screenshotImage = renderer.image { _ in
                window.drawHierarchy(in: window.bounds, afterScreenUpdates: true)
            }
            
            let imageSaver = ImageSaver(
                onSuccess: { [self] in
                    self.toastMessage = "Screenshot saved to Photos"
                    self.showToast = true
                },
                onError: { [self] error in
                    self.toastMessage = "Error saving image: \(error.localizedDescription)"
                    self.showToast = true
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
        }){
            Image(systemName: systemIconName)
                .font(.system(size: 35))
                .foregroundColor(.white)
                .buttonStyle(PlainButtonStyle())
        }
        .frame(width: 50, height: 50)
        
    }
}


// Helper class to handle the UIKit callback
class ImageSaver: NSObject {
    private let onSuccess: () -> Void
    private let onError: (Error) -> Void
    
    init(onSuccess: @escaping () -> Void, onError: @escaping (Error) -> Void) {
        self.onSuccess = onSuccess
        self.onError = onError
    }
    
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }
    
    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            onError(error)
        } else {
            onSuccess()
        }
    }
}
