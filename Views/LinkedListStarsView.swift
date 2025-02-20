import SwiftUI

// Cambiamos StarNode a una clase en lugar de una estructura
class StarNode: Identifiable {
    let id = UUID()
    let name: String
    var next: StarNode?
    
    init(name: String, next: StarNode? = nil) {
        self.name = name
        self.next = next
    }
}

struct LinkedListStarsView: View {
    @State private var stars: StarNode?
    @State private var currentStar: StarNode?
    @State private var newStarName: String = ""
    @State private var showExplanation = true
    
    init() {
        // Creamos la lista enlazada de una manera más simple
        let head = StarNode(name: "Sirius")
        head.next = StarNode(name: "Vega")
        head.next?.next = StarNode(name: "Polaris")
        head.next?.next?.next = StarNode(name: "Antares")
        
        _stars = State(initialValue: head)
        _currentStar = State(initialValue: head)
    }
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 20) {
                if showExplanation {
                    explanationView
                        .transition(.move(edge: .top))
                } else {
                    Text("Linked Stars")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                }
                
                Text("Current Node: \(currentStar?.name ?? "None")")
                    .foregroundColor(.white)
                    .font(.title3)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(getStarList(), id: \.id) { star in
                            HStack(spacing: 5) {
                                StarCard(name: star.name, 
                                       isSelected: currentStar?.id == star.id)
                                    .onTapGesture {
                                        withAnimation {
                                            currentStar = star
                                        }
                                    }
                                
                                if star.next != nil {
                                    Image(systemName: "arrow.right")
                                        .foregroundColor(.purple)
                                        .font(.title2)
                                }
                            }
                        }
                    }
                    .padding()
                }
                
                VStack(spacing: 15) {
                    HStack {
                        TextField("New star name", text: $newStarName)
                            .textFieldStyle(SpaceTextFieldStyle())
                        
                        Button("Add Star") {
                            withAnimation {
                                if !newStarName.isEmpty {
                                    addStar(newStarName)
                                    newStarName = ""
                                }
                            }
                        }
                        .buttonStyle(SpaceButtonStyle(color: .purple, isDisabled: newStarName.isEmpty))
                    }
                    
                    Button("Remove Current Star") {
                        withAnimation {
                            removeCurrentStar()
                        }
                    }
                    .buttonStyle(SpaceButtonStyle(color: .red, isDisabled: currentStar == nil))
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
                        .background(Color.purple.opacity(0.3))
                        .cornerRadius(10)
                }
            }
            .padding()
        }
    }
    
    private var explanationView: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("What is a Linked List?")
                .font(.title)
                .foregroundColor(.white)
            
            Text("A linked list is like a chain of stars, where each star points to the next one. Unlike arrays, elements can be easily added or removed anywhere in the sequence.")
                .foregroundColor(.gray)
            
            Text("Key Features:")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.top)
            
            VStack(alignment: .leading, spacing: 10) {
                bulletPoint("Dynamic size and flexible structure")
                bulletPoint("Each node points to the next node")
                bulletPoint("Efficient insertions and deletions")
                bulletPoint("Sequential access to elements")
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
    
    private func getStarList() -> [StarNode] {
        var result: [StarNode] = []
        var current = stars
        while let star = current {
            result.append(star)
            current = star.next
        }
        return result
    }
    
    private func addStar(_ name: String) {
        let newNode = StarNode(name: name)
        if stars == nil {
            stars = newNode
        } else {
            var current = stars
            while current?.next != nil {
                current = current?.next
            }
            current?.next = newNode
        }
        currentStar = newNode
    }
    
    private func removeCurrentStar() {
        guard let current = currentStar else { return }
        
        if current.id == stars?.id {
            stars = stars?.next
            currentStar = stars
            return
        }
        
        var prev = stars
        while prev?.next != nil && prev?.next?.id != current.id {
            prev = prev?.next
        }
        
        prev?.next = current.next
        currentStar = prev
    }
}

struct StarCard: View {
    let name: String
    let isSelected: Bool
    
    var body: some View {
        VStack {
            Image("sparkling")  // Usando la imagen sparkling.png para las estrellas
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .brightness(0.3)
                .overlay(
                    Circle()
                        .stroke(isSelected ? Color.orange : Color.clear, lineWidth: 2)
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