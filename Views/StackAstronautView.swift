import SwiftUI

struct StackAstronautView: View {
    @State private var astronauts: [String] = []
    @State private var newAstronaut: String = ""
    @State private var showExplanation = true
    @State private var showingAnimation = false
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 20) {
                if showExplanation {
                    explanationView
                        .transition(.move(edge: .top))
                } else {
                    Text("Space Stack")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                }
                
                Text("Stack Size: \(astronauts.count)")
                    .foregroundColor(.white)
                    .font(.title3)
                
                // Stack visualization
                VStack(spacing: 10) {
                    ForEach(astronauts.reversed(), id: \.self) { astronaut in
                        AstronautCard(name: astronaut)
                            .transition(.move(edge: .top).combined(with: .opacity))
                    }
                }
                .padding()
                
                VStack(spacing: 15) {
                    HStack {
                        TextField("New astronaut name", text: $newAstronaut)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .foregroundColor(.white)
                        
                        Button("Push") {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                if !newAstronaut.isEmpty {
                                    astronauts.append(newAstronaut)
                                    newAstronaut = ""
                                }
                            }
                        }
                        .disabled(newAstronaut.isEmpty)
                    }
                    
                    Button("Pop") {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                            if !astronauts.isEmpty {
                                astronauts.removeLast()
                            }
                        }
                    }
                    .disabled(astronauts.isEmpty)
                }
                .padding()
                
                Button {
                    withAnimation {
                        showExplanation.toggle()
                    }
                } label: {
                    Text(showExplanation ? "Hide Explanation" : "Show Explanation")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.cyan.opacity(0.3))
                        .cornerRadius(10)
                }
            }
            .padding()
        }
    }
    
    private var explanationView: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("What is a Stack?")
                .font(.title)
                .foregroundColor(.white)
            
            Text("A stack is like a tower of astronauts in space. The last astronaut to enter is the first one to exit (LIFO).")
                .foregroundColor(.gray)
            
            Text("Key Features:")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.top)
            
            VStack(alignment: .leading, spacing: 10) {
                bulletPoint("Last In, First Out (LIFO) principle")
                bulletPoint("Push: Add to the top")
                bulletPoint("Pop: Remove from the top")
                bulletPoint("Perfect for tracking state and history")
            }
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(15)
    }
    
    private func bulletPoint(_ text: String) -> some View {
        HStack {
            Image(systemName: "circle.fill")
                .font(.system(size: 8))
                .foregroundColor(.cyan)
            Text(text)
                .foregroundColor(.gray)
        }
    }
}

struct AstronautCard: View {
    let name: String
    
    var body: some View {
        HStack {
            Image("astronautMenu")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
            
            Text(name)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.white)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.cyan.opacity(0.3))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.cyan, lineWidth: 2)
        )
    }
} 