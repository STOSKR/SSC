import SwiftUI

struct HomeView: View {
    @Binding var selectedStructure: ContentView.DataStructure?
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 40) {
                Text("Space Data Structures")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top, 50)
                
                Text("Explore and Learn")
                    .font(.title2)
                    .foregroundColor(.gray)
                
                LazyVGrid(columns: [
                    GridItem(.adaptive(minimum: 300), spacing: 20)
                ], spacing: 20) {
                    structureCard(
                        title: "Arrays",
                        description: "Learn how to store planets in a line",
                        icon: "planet",
                        color: .purple,
                        type: .arrays
                    )
                    
                    structureCard(
                        title: "Linked Lists",
                        description: "Connect stars in a chain",
                        icon: "star.fill",
                        color: .orange,
                        type: .linkedLists
                    )
                    
                    structureCard(
                        title: "Stacks",
                        description: "Stack astronauts one on top of another",
                        icon: "person.fill",
                        color: .blue,
                        type: .stacks
                    )
                    
                    structureCard(
                        title: "Queues",
                        description: "Line up spaceships for launch",
                        icon: "airplane",
                        color: .green,
                        type: .queues
                    )
                }
                .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    private func structureCard(title: String, description: String, icon: String, color: Color, type: ContentView.DataStructure) -> some View {
        Button {
            withAnimation {
                selectedStructure = type
            }
        } label: {
            VStack(spacing: 15) {
                Image(systemName: icon)
                    .font(.system(size: 40))
                    .foregroundColor(color)
                
                Text(title)
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding()
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