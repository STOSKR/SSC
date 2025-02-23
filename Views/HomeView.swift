import SwiftUI

struct Star: Equatable {
    var position: CGPoint
    var opacity: Double
    var size: CGFloat
    
    static func == (lhs: Star, rhs: Star) -> Bool {
        lhs.position.x == rhs.position.x &&
        lhs.position.y == rhs.position.y &&
        lhs.opacity == rhs.opacity &&
        lhs.size == rhs.size
    }
}

struct ShootingStar: Equatable {
    var start: CGPoint
    var end: CGPoint
    var progress: CGFloat
    var width: CGFloat
}

struct StarField: View {
    let starsCount: Int
    @State private var stars: [Star] = []
    @State private var shootingStar: ShootingStar?
    let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    let shootingStarTimer = Timer.publish(every: 15, on: .main, in: .common).autoconnect()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Estrellas normales
                ForEach(0..<starsCount, id: \.self) { index in
                    Circle()
                        .fill(Color.white)
                        .frame(width: stars[safe: index]?.size ?? 1,
                               height: stars[safe: index]?.size ?? 1)
                        .opacity(stars[safe: index]?.opacity ?? 0.5)
                        .position(stars[safe: index]?.position ?? .zero)
                        .animation(.easeInOut(duration: 2), value: stars[safe: index]?.position)
                }
                
                // Estrella fugaz
                if let shootingStar = shootingStar {
                    Path { path in
                        path.move(to: shootingStar.start)
                        path.addLine(to: CGPoint(
                            x: shootingStar.start.x + (shootingStar.end.x - shootingStar.start.x) * shootingStar.progress,
                            y: shootingStar.start.y + (shootingStar.end.y - shootingStar.start.y) * shootingStar.progress
                        ))
                    }
                    .stroke(Color.white, lineWidth: shootingStar.width)
                    .opacity(0.8)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear {
                initializeStars(in: geometry)
            }
            .onReceive(timer) { _ in
                updateStars(in: geometry)
            }
            .onReceive(shootingStarTimer) { _ in
                createShootingStar(in: geometry)
            }
        }
        .ignoresSafeArea()
    }
    
    private func initializeStars(in geometry: GeometryProxy) {
        stars = (0..<starsCount).map { _ in
            Star(
                position: CGPoint(
                    x: CGFloat.random(in: -20...geometry.size.width + 20),
                    y: CGFloat.random(in: -20...geometry.size.height + 20)
                ),
                opacity: Double.random(in: 0.2...1),
                size: CGFloat.random(in: 1...4)
            )
        }
    }
    
    private func updateStars(in geometry: GeometryProxy) {
        for i in 0..<stars.count {
            if Int.random(in: 0...5) == 0 {
                stars[i].opacity = Double.random(in: 0.2...1)
            }
            
            if Int.random(in: 0...10) == 0 {
                withAnimation(.easeInOut(duration: 2)) {
                    let newX = stars[i].position.x + CGFloat.random(in: -30...30)
                    let newY = stars[i].position.y + CGFloat.random(in: -30...30)
                    
                    if newX < -20 {
                        stars[i].position.x = geometry.size.width + 20
                    } else if newX > geometry.size.width + 20 {
                        stars[i].position.x = -20
                    } else {
                        stars[i].position.x = newX
                    }
                    
                    if newY < -20 {
                        stars[i].position.y = geometry.size.height + 20
                    } else if newY > geometry.size.height + 20 {
                        stars[i].position.y = -20
                    } else {
                        stars[i].position.y = newY
                    }
                }
            }
        }
        
        // Actualizar la estrella fugaz si existe
        if var star = shootingStar {
            star.progress += 0.05
            if star.progress >= 1 {
                shootingStar = nil
            } else {
                shootingStar = star
            }
        }
    }
    
    private func createShootingStar(in geometry: GeometryProxy) {
        let start = CGPoint(
            x: CGFloat.random(in: 0...geometry.size.width),
            y: CGFloat.random(in: 0...geometry.size.height/2)
        )
        let end = CGPoint(
            x: start.x + CGFloat.random(in: 100...200),
            y: start.y + CGFloat.random(in: 100...200)
        )
        
        shootingStar = ShootingStar(
            start: start,
            end: end,
            progress: 0,
            width: CGFloat.random(in: 1...3)
        )
    }
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

struct HomeView: View {
    @Binding var selectedStructure: ContentView.DataStructure?
    
    private let dataStructures: [(title: String, icon: String, subtitle: String, color: Color)] = [
        ("Arrays", "solar-system", "Sequential Collection", .orange),
        ("Linked Lists", "starMenu", "Connected Nodes", .purple),
        ("Stacks", "astronautMenu", "LIFO Structure", .cyan),
        ("Queues", "rocketMenu", "FIFO Structure", .green)
    ]
    
    var body: some View {
        ZStack {
            // Fondo negro con estrellas
            Color.black.ignoresSafeArea()
            StarField(starsCount: 100)
                .opacity(0.6)
            
            // Contenido principal
            VStack {
                Text("Data Structures")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 40)
                
                Spacer()
                
                if selectedStructure == nil {
                    // Grid view con tamaños fijos
                    VStack(spacing: 25) {
                        HStack(spacing: 25) {
                            cardFor(index: 0)
                                .frame(width: 160, height: 200)
                            cardFor(index: 1)
                                .frame(width: 160, height: 200)
                        }
                        HStack(spacing: 25) {
                            cardFor(index: 2)
                                .frame(width: 160, height: 200)
                            cardFor(index: 3)
                                .frame(width: 160, height: 200)
                        }
                    }
                } else {
                    // Lista compacta
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
                    .frame(maxWidth: .infinity)
                }
                
                Spacer()
            }
            .padding(.horizontal, 25)
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