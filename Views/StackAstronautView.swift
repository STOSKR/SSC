import SwiftUI

struct StackAstronautView: View {
    @State private var astronauts: [String] = []
    @State private var newAstronaut: String = ""
    @State private var showingAnimation = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Stacks")
                .font(.system(size: 40, weight: .bold))
                .foregroundColor(.white)
                .padding(.horizontal)
            
            Text("A stack is a LIFO (Last In, First Out) data structure where elements are added and removed from the same end.")
                .foregroundColor(.white)
                .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 15) {
                Text("Main Operations:")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding(.horizontal)
                
                BulletPoint("Push: Add an element to the top of the stack")
                BulletPoint("Pop: Remove and return the top element")
                BulletPoint("Peek: View the top element without removing it")
                BulletPoint("isEmpty: Check if the stack is empty")
            }
            
            Text("Common Use Cases:")
                .font(.title2)
                .foregroundColor(.white)
                .padding(.horizontal)
            
            BulletPoint("Function call management")
            BulletPoint("Undo/Redo in editors")
            BulletPoint("Mathematical expression evaluation")
            
            // Stack visualization
            VStack(spacing: 10) {
                ForEach(astronauts.reversed(), id: \.self) { astronaut in
                    AstronautCard(name: astronaut)
                        .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
        }
        .padding(.vertical)
    }
}

struct AstronautCard: View {
    let name: String
    
    var body: some View {
        Text(name)
            .font(.system(size: 20, weight: .medium))
            .foregroundColor(.white)
            .padding()
            .frame(width: 200, height: 60)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.blue.opacity(0.3))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.blue, lineWidth: 2)
            )
    }
} 