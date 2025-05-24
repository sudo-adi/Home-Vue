import SwiftUI
import RealityKit
import Combine

class PlacementSettings: ObservableObject {
    
    //when the user selects a model in browseView, this property is set.
    @Published var selectedModel: Model? {
        willSet(newValue){
            print("Setting selectedModel to \(String(describing: newValue?.name))")
        }
    }
    //Whne the user taps confirm in PlacementView, the value of selectedModel is assigned to confir
    @Published var confirmedModel: Model? {
        willSet(newValue){
            guard let model = newValue else {
                print("Clearing confirmedModel")
                return
            }
            
            print("Setting confirmedModel to \(model.name)")
        }
    }
    
    
    //THis property retains the cancellable object for our SceneEventUpdate subscriber
    var sceneObserver: Cancellable?
}
