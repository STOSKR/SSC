import SwiftUI

struct ContentView: View {
    @State private var selectedStructure: DataStructure?
    @State private var completedStructures: Set<DataStructure> = []
    @State private var homeWidth: CGFloat = .zero
    
    var body: some View {
        if let structure = selectedStructure {
            structureView(for: structure)
        } else {
            HomeView(selectedStructure: $selectedStructure, completedStructures: $completedStructures)
        }
    }
    
    @ViewBuilder
    private func structureView(for structure: DataStructure) -> some View {
        VStack(spacing: 0) {
            HStack {
                Button {
                    withAnimation {
                        selectedStructure = nil
                    }
                } label: {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding()
                }
                Spacer()
            }
            .background(Color.black)
            
            ScrollView {
                switch structure {
                case .arrays:
                    ArrayPlanetView(
                        selectedStructure: $selectedStructure,
                        completedStructures: $completedStructures
                    )
                case .linkedLists:
                    LinkedListStarsView()
                case .stacks:
                    StackAstronautView()
                case .queues:
                    QueueSpaceshipView()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
    }
} 