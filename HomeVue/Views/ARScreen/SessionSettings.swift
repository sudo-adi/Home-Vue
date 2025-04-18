
import SwiftUI

class SessionSettings: ObservableObject {
    @Published var isMultiuserEnabled: Bool = false
    @Published var isPeopleOcclusionEnabled: Bool = false
    @Published var isObjectOcclusionEnabled: Bool = false
    @Published var isLidarDebugEnabled: Bool = false
}
