import SwiftUI

struct ToastView: View {
    let message: String
    
    var body: some View {
        Text(message)
            .foregroundColor(.white)
            .padding()
            .background(Color.black.opacity(0.75))
            .cornerRadius(10)
            .padding(.horizontal)
    }
}
