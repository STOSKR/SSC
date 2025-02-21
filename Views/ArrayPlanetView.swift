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
        @State private var maxLevelReached = 1
        @State private var selectedAvailablePlanets: Set<UUID> = []
        
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
                
                ScrollView {
                    VStack(spacing: 15) {
                        // Level navigation
                        HStack {
                            Button(action: { changeLevel(decrease: true) }) {
                                Image(systemName: "chevron.left.circle.fill")
                                    .font(.system(size: 24))
                            }
                            .disabled(currentLevel == 1)
                            
                            Spacer()
                            
                            Text("Level \(currentLevel)")
                                .font(.system(size: 32, weight: .bold))
                            
                            Spacer()
                            
                            Button(action: { changeLevel(decrease: false) }) {
                                Image(systemName: "chevron.right.circle.fill")
                                    .font(.system(size: 24))
                            }
                            .disabled(currentLevel >= maxLevelReached)
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        
                        levelInstructions
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                        
                        // Available planets
                        VStack(alignment: .leading) {
                            Text("Available Planets:")
                                .font(.title3)
                                .foregroundColor(.white)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15) {
                                    ForEach(availablePlanets.filter { !selectedAvailablePlanets.contains($0.id) }) { planet in
                                        PlanetCard(
                                            name: planet.name,
                                            imageName: planet.image,
                                            isSelected: false,
                                            size: 80
                                        )
                                        .onTapGesture {
                                            handlePlanetTap(planet)
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        .frame(height: 140)
                        
                        // Current array
                        VStack(alignment: .leading) {
                            Text("Your Solar System:")
                                .font(.title3)
                                .foregroundColor(.white)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15) {
                                    ForEach(Array(planets.enumerated()), id: \.element.id) { index, planet in
                                        PlanetCard(
                                            name: planet.name,
                                            imageName: planet.image,
                                            isSelected: selectedPlanetIndex == index,
                                            size: 80
                                        )
                                        .onTapGesture {
                                            handleSelectionTap(at: index)
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        .frame(height: 140)
                        
                        // Buttons
                        VStack(spacing: 10) {
                            if currentLevel > 1 {
                                HStack(spacing: 15) {
                                    Button("Remove Selected") {
                                        withAnimation {
                                            handleRemoveSelected()
                                        }
                                    }
                                    .buttonStyle(SpaceButtonStyle(color: .red, isDisabled: selectedPlanetIndex == nil))
                                    
                                    Button("Remove Last") {
                                        withAnimation {
                                            handleRemoveLast()
                                        }
                                    }
                                    .buttonStyle(SpaceButtonStyle(color: .orange, isDisabled: planets.isEmpty))
                                }
                            }
                            
                            Button("Check Level") {
                                checkLevelCompletion()
                            }
                            .buttonStyle(SpaceButtonStyle(color: .green, isDisabled: planets.isEmpty))
                            
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
                    }
                    .padding()
                }
                
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
                selectedAvailablePlanets.insert(planet.id)
            }
        }
        
        private func handleSelectionTap(at index: Int) -> Void {
            withAnimation {
                selectPlanet(at: index)
            }
        }
        
        private func addPlanetToSystem(_ planet: PlanetOption) -> Void {
            let newPlanet = PlanetOption(
                name: planet.name,
                image: planet.image,
                order: planet.order
            )
            planets.append(newPlanet)
        }
        
        private func selectPlanet(at index: Int) -> Void {
            if currentLevel > 1 {
                selectedPlanetIndex = (selectedPlanetIndex == index) ? nil : index
            }
        }
        
        private func changeLevel(decrease: Bool) {
            let newLevel = decrease ? currentLevel - 1 : currentLevel + 1
            if newLevel >= 1 && newLevel <= maxLevelReached {
                currentLevel = newLevel
                resetLevel()
            }
        }
        
        private func resetLevel() {
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
            planets = []
            selectedPlanetIndex = nil
            showSuccess = false
            showHint = false
            availablePlanets = getLevelPlanets(level: currentLevel, allPlanets: allPlanets)
            selectedAvailablePlanets.removeAll()
        }
        
        private func advanceToNextLevel() {
            currentLevel += 1
            maxLevelReached = max(maxLevelReached, currentLevel)
            resetLevel()
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
            } else {
                errorMessage = "That's not the correct arrangement for this level!"
                showError = true
            }
        }
        
        private func handleRemoveSelected() {
            if let index = selectedPlanetIndex {
                let removedPlanet = planets[index]
                planets.remove(at: index)
                selectedPlanetIndex = nil
                
                if !availablePlanets.contains(where: { $0.id == removedPlanet.id }) {
                    availablePlanets.append(removedPlanet)
                }
                selectedAvailablePlanets.remove(removedPlanet.id)
            }
        }
        
        private func handleRemoveLast() {
            if let removedPlanet = planets.last {
                planets.removeLast()
                
                if !availablePlanets.contains(where: { $0.id == removedPlanet.id }) {
                    availablePlanets.append(removedPlanet)
                }
                selectedAvailablePlanets.remove(removedPlanet.id)
            }
        }
    }

    struct PlanetCard: View {
        let name: String
        let imageName: String
        let isSelected: Bool
        let size: CGFloat
        
        var body: some View {
            VStack {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: size, height: size)
                    .overlay(
                        Circle()
                            .stroke(isSelected ? Color.orange : Color.clear, lineWidth: 3)
                    )
                
                Text(name)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
            }
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.black.opacity(0.3))
            )
        }
    } 