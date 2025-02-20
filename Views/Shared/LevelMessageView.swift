import SwiftUI

struct LevelMessageView: View {
    let title: String
    let message: String
    let buttonText: String
    let buttonAction: () -> Void
    let color: Color
    
    var body: some View {
        VStack(spacing: 20) {
            Text(title)
                .font(.title)
                .foregroundColor(.white)
            
            Text(message)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            Button(buttonText) {
                buttonAction()
            }
            .buttonStyle(SpaceButtonStyle(color: color, isDisabled: false))
        }
        .padding(40)
        .background(Color.black.opacity(0.9))
        .cornerRadius(20)
        .shadow(radius: 10)
    }
} 