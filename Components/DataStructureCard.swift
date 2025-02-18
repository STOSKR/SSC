import SwiftUI

struct DataStructureCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let action: () -> Void
    let isSystemIcon: Bool
    
    init(title: String, subtitle: String, icon: String, color: Color, isSystemIcon: Bool = true, action: @escaping () -> Void) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.color = color
        self.isSystemIcon = isSystemIcon
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 20) {
                Group {
                    if isSystemIcon {
                        Image(systemName: icon)
                            .font(.system(size: 50))
                            .foregroundColor(color)
                    } else {
                        Image(icon)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 70)
                    }
                }
                
                Text(title)
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)
                
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            .padding()
            .frame(height: 200)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.gray.opacity(0.2))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(color, lineWidth: 2)
            )
        }
    }
} 