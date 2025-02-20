    import SwiftUI

    struct PlanetOption: Identifiable, Equatable {
        let id = UUID()
        let name: String
        let image: String
        let order: Int
        
        // Eliminamos la implementación explícita de Equatable ya que Swift puede
        // generar automáticamente la implementación correcta para todas las propiedades
    }

    struct ArrayPlanetView: View {
        @State private var planets: [PlanetOption] = []
        @State private var availablePlanets: [PlanetOption] = []
        @State private var selectedPlanetIndex: Int?
        @State private var currentLevel = 1
        @State private var showSuccess = false
        @State private var showHint = false
        @State private var showError = false
        @State private var errorMessage = ""
        
        init() {
            let allPlanets = [
                PlanetOption(name: "Sun", image: "sun", order: 0),
                PlanetOption(name: "Mercury", image: "mercury", order: 1),
                PlanetOption(name: "Venus", image: "venus", order: 2),
                PlanetOption(name: "Earth", image: "earth", order: 3),
                PlanetOption(name: "Mars", image: "mars", order: 4),
                PlanetOption(name: "Jupiter", image: "jupiter", order: 5),
                PlanetOption(name: "Saturn", image: "saturn", order: 6),
                PlanetOption(name: "Uranus", image: "uranus", order: 7),
                PlanetOption(name: "Neptune", image: "neptune", order: 8)
            ]
            _availablePlanets = State(initialValue: getLevelPlanets(level: 1, allPlanets: allPlanets))
        }
        
        var body: some View {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Text("Level \(currentLevel)")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                    
                    levelInstructions
                    
                    // Available planets
                    VStack(alignment: .leading) {
                        Text("Available Planets:")
                            .font(.title3)
                            .foregroundColor(.white)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
                                ForEach(availablePlanets) { planet in
                                    PlanetCard(
                                        name: planet.name,
                                        imageName: planet.image,
                                        isSelected: false
                                    )
                                    .onTapGesture {
                                        handlePlanetTap(planet)
                                    }
                                }
                            }
                            .padding()
                        }
                    }
                    
                    // Current array
                    VStack(alignment: .leading) {
                        Text("Your Solar System:")
                            .font(.title3)
                            .foregroundColor(.white)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
                                ForEach(Array(planets.enumerated()), id: \.element.id) { index, planet in
                                    PlanetCard(
                                        name: planet.name,
                                        imageName: planet.image,
                                        isSelected: selectedPlanetIndex == index
                                    )
                                    .onTapGesture {
                                        handleSelectionTap(at: index)
                                    }
                                }
                            }
                            .padding()
                        }
                    }
                    
                    if currentLevel > 1 {
                        HStack(spacing: 20) {
                            Button("Remove Selected") {
                                if let index = selectedPlanetIndex {
                                    planets.remove(at: index)
                                    selectedPlanetIndex = nil
                                }
                            }
                            .buttonStyle(SpaceButtonStyle(color: .red, isDisabled: selectedPlanetIndex == nil))
                            
                            Button("Remove Last") {
                                planets.removeLast()
                            }
                            .buttonStyle(SpaceButtonStyle(color: .orange, isDisabled: planets.isEmpty))
                        }
                    }
                    
                    if showHint {
                        Text("Hint: \(getCurrentLevelHint())")
                            .foregroundColor(.yellow)
                            .padding()
                    }
                    
                    Button("Need Help?") {
                        showHint.toggle()
                    }
                    .buttonStyle(SpaceButtonStyle(color: .blue, isDisabled: false))
                }
                .padding()
                
                if showSuccess {
                    LevelMessageView(
                        title: "Great Job! 🎉",
                        message: "You completed level \(currentLevel)",
                        buttonText: "Next Level",
                        buttonAction: {
                            advanceToNextLevel()
                        },
                        color: .green
                    )
                }
                
                if showError {
                    LevelMessageView(
                        title: "Oops!",
                        message: errorMessage,
                        buttonText: "Try Again",
                        buttonAction: {
                            showError = false
                        },
                        color: .red
                    )
                }
            }
        }
        
        private var levelInstructions: some View {
            Text(getCurrentLevelInstructions())
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding()
                .background(Color.blue.opacity(0.2))
                .cornerRadius(10)
        }
        
        private func getCurrentLevelInstructions() -> String {
            switch currentLevel {
            case 1:
                return "Tap on the Sun to add it to your solar system!"
            case 2:
                return "Add the Earth and try removing planets using both buttons"
            case 3:
                return "Create the inner solar system: Sun, Mercury, Venus, Earth, and Mars"
            default:
                return "Complete the solar system by adding all planets in order"
            }
        }
        
        private func getCurrentLevelHint() -> String {
            switch currentLevel {
            case 1:
                return "The Sun should be the first object in our solar system"
            case 2:
                return "Try selecting a planet and using both remove buttons"
            case 3:
                return "Remember: Mercury, Venus, Earth, Mars"
            default:
                return "The planets go from Mercury to Neptune"
            }
        }
        
        private func getLevelPlanets(level: Int, allPlanets: [PlanetOption]) -> [PlanetOption] {
            switch level {
            case 1:
                return [allPlanets[0]] // Just the Sun
            case 2:
                return [allPlanets[0], allPlanets[3]] // Sun and Earth
            case 3:
                return Array(allPlanets[0...4]) // Sun to Mars
            default:
                return allPlanets
            }
        }
        
        private func handlePlanetTap(_ planet: PlanetOption) -> Void {
            withAnimation {
                addPlanetToSystem(planet)
            }
        }
        
        private func handleSelectionTap(at index: Int) -> Void {
            withAnimation {
                selectPlanet(at: index)
            }
        }
        
        private func addPlanetToSystem(_ planet: PlanetOption) -> Void {
            if validateAddition(planet) {
                // Creamos una nueva instancia del planeta para evitar problemas de referencia
                let newPlanet = PlanetOption(
                    name: planet.name,
                    image: planet.image,
                    order: planet.order
                )
                planets.append(newPlanet)
                checkLevelCompletion()
            } else {
                errorMessage = "That's not the right planet for this step!"
                showError = true
            }
        }
        
        private func selectPlanet(at index: Int) -> Void {
            if currentLevel > 1 {
                selectedPlanetIndex = (selectedPlanetIndex == index) ? nil : index
            }
        }
        
        private func validateAddition(_ planet: PlanetOption) -> Bool {
            switch currentLevel {
            case 1:
                return planet.name == "Sun" && planets.isEmpty
            case 2:
                if planets.isEmpty {
                    return planet.name == "Sun"
                }
                return planets.count == 1 && planet.name == "Earth" && planets[0].name == "Sun"
            case 3:
                if planets.isEmpty {
                    return planet.name == "Sun"
                }
                let expectedOrder = [0, 1, 2, 3, 4]
                return planets.count < expectedOrder.count && planet.order == expectedOrder[planets.count]
            default:
                if planets.isEmpty {
                    return planet.name == "Sun"
                }
                return planets.count < 9 && planet.order == planets.count
            }
        }
        
        private func checkLevelCompletion() {
            let isCorrect: Bool
            
            switch currentLevel {
            case 1:
                isCorrect = planets.count == 1 && planets[0].name == "Sun"
            case 2:
                isCorrect = planets.count == 2 && 
                        planets[0].name == "Sun" && 
                        planets[1].name == "Earth"
            case 3:
                let expectedOrders = [0, 1, 2, 3, 4]
                let currentOrders = planets.map { $0.order }
                isCorrect = planets.count == 5 && currentOrders == expectedOrders
            default:
                let expectedOrders = Array(0...8)
                let currentOrders = planets.map { $0.order }
                isCorrect = planets.count == 9 && currentOrders == expectedOrders
            }
            
            if isCorrect {
                showSuccess = true
            }
        }
        
        private func advanceToNextLevel() {
            let allPlanets = [
                PlanetOption(name: "Sun", image: "sun", order: 0),
                PlanetOption(name: "Mercury", image: "mercury", order: 1),
                PlanetOption(name: "Venus", image: "venus", order: 2),
                PlanetOption(name: "Earth", image: "earth", order: 3),
                PlanetOption(name: "Mars", image: "mars", order: 4),
                PlanetOption(name: "Jupiter", image: "jupiter", order: 5),
                PlanetOption(name: "Saturn", image: "saturn", order: 6),
                PlanetOption(name: "Uranus", image: "uranus", order: 7),
                PlanetOption(name: "Neptune", image: "neptune", order: 8)
            ]
            
            currentLevel += 1
            planets = []
            selectedPlanetIndex = nil
            showSuccess = false
            showHint = false
            availablePlanets = getLevelPlanets(level: currentLevel, allPlanets: allPlanets)
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