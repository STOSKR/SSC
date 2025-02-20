import SwiftUI

struct ContentView: View {
    @State private var selectedStructure: DataStructure?
    @State private var homeWidth: CGFloat = .zero
    
    enum DataStructure {
        case arrays, linkedLists, stacks, queues
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Fondo con estrellas que siempre ocupa toda la pantalla
                Color.black.ignoresSafeArea()
                StarField(starsCount: 300)
                    .opacity(0.7)
                    .ignoresSafeArea()
                
                // Contenido que se ajusta
                HStack(spacing: 0) {
                    // Home View
                    HomeView(selectedStructure: $selectedStructure)
                        .frame(width: homeWidth == .zero ? geometry.size.width : homeWidth)
                        .animation(.spring(), value: homeWidth)
                    
                    // Detail View
                    if let structure = selectedStructure {
                        structureView(for: structure)
                            .frame(
                                width: geometry.size.width - homeWidth,
                                height: geometry.size.height
                            )
                            .transition(.move(edge: .trailing))
                            .background(Color.black.opacity(0.01)) // Fondo transparente
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .onAppear {
                homeWidth = geometry.size.width
            }
            .onChange(of: selectedStructure) { newValue in
                withAnimation(.spring()) {
                    homeWidth = newValue == nil ? geometry.size.width : geometry.size.width * 0.3
                }
            }
        }
        .ignoresSafeArea()
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
                    ArrayPlanetView()
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