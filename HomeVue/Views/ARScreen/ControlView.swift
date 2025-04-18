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
    
     var body: some View{
        
        VStack{
            ControlVisibilityToggleButton(isControlVisible: $isControlVisible)
            
            Spacer()
            
            if isControlVisible{
                ControlButtonBar(showBrowse: $showBrowse, showSettings: $showSettings)
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
    @Binding var showBrowse: Bool
    @Binding var showSettings: Bool
    var body: some View {
        HStack {

            //MostRecentlyPLaced Button
            ControlButton(systemIconName: "clock.fill"){
                print("MostRecentlyPlaced button pressed")
            }
            
            Spacer()
            //Browse Button
            ControlButton(systemIconName: "square.grid.2x2"){
                print("Browse button pressed.")
                self.showBrowse.toggle()
            }.sheet(isPresented: $showBrowse, content: {
                BrowseView(showBrowse: $showBrowse)
            })
            
            Spacer()
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
