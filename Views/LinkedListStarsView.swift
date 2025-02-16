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
    @State private var starNames = ["Sirius", "Vega", "Polaris", "Antares"]
    
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
        VStack(alignment: .leading, spacing: 20) {
            Text("Linked Lists")
                .font(.system(size: 40, weight: .bold))
                .foregroundColor(.white)
                .padding(.horizontal)
            
            Text("A linked list is a linear data structure where each element (node) contains data and a reference to the next node.")
                .foregroundColor(.white)
                .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 15) {
                Text("Key Features:")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding(.horizontal)
                
                BulletPoint("Dynamic Memory: Nodes can be added or removed as needed")
                BulletPoint("Sequential Access: To access an element, we must traverse from the start")
                BulletPoint("No contiguous memory required unlike arrays")
                BulletPoint("Ideal for frequent insertions and deletions")
            }
            
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
                                    .foregroundColor(.orange)
                                    .font(.title2)
                            }
                        }
                    }
                }
                .padding()
            }
        }
        .padding(.vertical)
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
}

struct StarCard: View {
    let name: String
    let isSelected: Bool
    
    var body: some View {
        Text(name)
            .font(.system(size: 20, weight: .medium))
            .foregroundColor(.white)
            .padding()
            .frame(width: 120, height: 120)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(isSelected ? Color.orange : Color.gray.opacity(0.3))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.orange, lineWidth: isSelected ? 2 : 0)
            )
    }
} 