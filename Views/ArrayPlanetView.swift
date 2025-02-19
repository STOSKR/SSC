import SwiftUI

struct ArrayPlanetView: View {
    @State private var planets = [
        (name: "Mercury", image: "mercury"),
        (name: "Venus", image: "venus"),
        (name: "Earth", image: "earth"),
        (name: "Mars", image: "mars"),
        (name: "Jupiter", image: "jupiter"),
        (name: "Saturn", image: "saturn"),
        (name: "Uranus", image: "uranus"),
        (name: "Neptune", image: "neptune")
    ]
    @State private var selectedPlanetIndex: Int?
    @State private var showExplanation = true
    @State private var newPlanet: String = ""
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 20) {
                if showExplanation {
                    explanationView
                        .transition(.move(edge: .top))
                } else {
                    Text("Arrays in Space")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                }
                
                Text("Current Index: \(selectedPlanetIndex ?? 0)")
                    .foregroundColor(.white)
                    .font(.title3)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(planets.indices, id: \.self) { index in
                            PlanetCard(
                                name: planets[index].name,
                                imageName: planets[index].image,
                                isSelected: selectedPlanetIndex == index
                            )
                            .onTapGesture {
                                withAnimation {
                                    selectedPlanetIndex = index
                                }
                            }
                        }
                    }
                    .padding()
                }
                
                VStack(spacing: 15) {
                    HStack {
                        TextField("New planet name", text: $newPlanet)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .foregroundColor(.white)
                        
                        Button("Add Planet") {
                            withAnimation {
                                if !newPlanet.isEmpty {
                                    planets.append((name: newPlanet, image: ""))
                                    newPlanet = ""
                                }
                            }
                        }
                        .disabled(newPlanet.isEmpty)
                    }
                    
                    Button("Remove Last Planet") {
                        withAnimation {
                            if !planets.isEmpty {
                                planets.removeLast()
                                selectedPlanetIndex = min(selectedPlanetIndex ?? 0, planets.count - 1)
                            }
                        }
                    }
                    .disabled(planets.isEmpty)
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
                        .background(Color.blue.opacity(0.3))
                        .cornerRadius(10)
                }
            }
            .padding()
        }
    }
    
    private var explanationView: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("What is an Array?")
                .font(.title)
                .foregroundColor(.white)
            
            Text("An array is like a line of planets in space. Each planet has its own position (index), starting from 0.")
                .foregroundColor(.gray)
            
            Text("Key Features:")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.top)
            
            VStack(alignment: .leading, spacing: 10) {
                bulletPoint("Elements are stored in order")
                bulletPoint("Each element has an index")
                bulletPoint("Quick access to any element")
                bulletPoint("Fixed size in some languages")
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
                .foregroundColor(.purple)
            Text(text)
                .foregroundColor(.gray)
        }
    }
}

struct PlanetCard: View {
    let name: String
    let imageName: String
    let isSelected: Bool
    
    var body: some View {
        VStack {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .overlay(
                    Circle()
                        .stroke(isSelected ? Color.orange : Color.clear, lineWidth: 3)
                )
            
            Text(name)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.black.opacity(0.3))
        )
    }
} 