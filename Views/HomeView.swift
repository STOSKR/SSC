import SwiftUI

struct HomeView: View {
    @Binding var selectedStructure: ContentView.DataStructure?
    
    private let dataStructures: [(title: String, icon: String, subtitle: String, color: Color)] = [
        ("Arrays", "solar-system", "Sequential Collection", .orange),
        ("Linked Lists", "starMenu", "Connected Nodes", .purple),
        ("Stacks", "astronautMenu", "LIFO Structure", .cyan),
        ("Queues", "rocketMenu", "FIFO Structure", .green)
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                Text("Data Structures")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: selectedStructure == nil ? .center : .leading)
                    .padding(.horizontal, 25)
                    .padding(.top, 20)
                
                if selectedStructure == nil {
                    gridView
                } else {
                    listView
                }
            }
            .padding(.horizontal, 25)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: selectedStructure == nil ? .center : .top)
            .padding(.vertical, 20)
        }
        .background(Color.black)
    }
    
    private var gridView: some View {
        VStack(spacing: 25) {
            HStack(spacing: 25) {
                cardFor(index: 0)
                cardFor(index: 1)
            }
            HStack(spacing: 25) {
                cardFor(index: 2)
                cardFor(index: 3)
            }
        }
        .frame(maxHeight: .infinity)
    }
    
    private var listView: some View {
        VStack(spacing: 15) {
            ForEach(0..<dataStructures.count, id: \.self) { index in
                let item = dataStructures[index]
                CompactDataStructureCard(
                    title: item.title,
                    subtitle: item.subtitle,
                    icon: item.icon,
                    color: item.color,
                    isSelected: selectedStructure == getStructure(for: item.title)
                ) {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                        selectedStructure = getStructure(for: item.title)
                    }
                }
            }
        }
    }
    
    private func cardFor(index: Int) -> some View {
        let item = dataStructures[index]
        return DataStructureCard(
            title: item.title,
            subtitle: item.subtitle,
            icon: item.icon,
            color: item.color,
            isSystemIcon: false
        ) {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                selectedStructure = getStructure(for: item.title)
            }
        }
    }
    
    private func getStructure(for title: String) -> ContentView.DataStructure? {
        switch title {
        case "Arrays": return .arrays
        case "Linked Lists": return .linkedLists
        case "Stacks": return .stacks
        case "Queues": return .queues
        default: return nil
        }
    }
}

// Nueva vista compacta para cuando hay selección
struct CompactDataStructureCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 15) {
                Image(icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.gray.opacity(0.2))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(isSelected ? color : color.opacity(0.5), lineWidth: isSelected ? 2 : 1)
            )
        }
    }
} 