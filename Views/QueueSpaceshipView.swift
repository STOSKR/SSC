import SwiftUI

struct QueueSpaceshipView: View {
    @State private var spaceships: [String] = []
    @State private var newSpaceship: String = ""
    @State private var showExplanation = true
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 20) {
                if showExplanation {
                    explanationView
                        .transition(.move(edge: .top))
                } else {
                    Text("Queues in Space")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                }
                
                Text("Current Queue Size: \(spaceships.count)")
                    .foregroundColor(.white)
                    .font(.title3)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(spaceships, id: \.self) { spaceship in
                            SpaceshipCard(name: spaceship)
                                .transition(.slide)
                        }
                    }
                    .padding()
                }
                
                VStack(spacing: 15) {
                    HStack {
                        TextField("New spaceship name", text: $newSpaceship)
                            .textFieldStyle(SpaceTextFieldStyle())
                        
                        Button("Enqueue") {
                            withAnimation {
                                if !newSpaceship.isEmpty {
                                    spaceships.append(newSpaceship)
                                    newSpaceship = ""
                                }
                            }
                        }
                        .buttonStyle(SpaceButtonStyle(color: .green, isDisabled: newSpaceship.isEmpty))
                    }
                    
                    Button("Dequeue") {
                        withAnimation {
                            if !spaceships.isEmpty {
                                spaceships.removeFirst()
                            }
                        }
                    }
                    .buttonStyle(SpaceButtonStyle(color: .red, isDisabled: spaceships.isEmpty))
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
                        .background(Color.green.opacity(0.3))
                        .cornerRadius(10)
                }
            }
            .padding()
        }
    }
    
    private var explanationView: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("What is a Queue?")
                .font(.title)
                .foregroundColor(.white)
            
            Text("A queue is like a line of spaceships waiting to launch. The first spaceship to join the line is the first one to take off (FIFO).")
                .foregroundColor(.gray)
            
            Text("Key Features:")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.top)
            
            VStack(alignment: .leading, spacing: 10) {
                bulletPoint("First In, First Out (FIFO) principle")
                bulletPoint("Elements are added at the end (enqueue)")
                bulletPoint("Elements are removed from the front (dequeue)")
                bulletPoint("Useful for managing ordered tasks")
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
                .foregroundColor(.green)
            Text(text)
                .foregroundColor(.gray)
        }
    }
}

struct SpaceshipCard: View {
    let name: String
    
    var body: some View {
        VStack {
            Image("rocket")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 60)
            
            Text(name)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white)
        }
        .padding()
        .frame(width: 150, height: 120)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.green.opacity(0.3))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.green, lineWidth: 2)
        )
    }
} 