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
    @Binding var selectedStructure: DataStructure?
    @Binding var completedStructures: Set<DataStructure>
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
    @State private var hasUsedRemoveSelected = false
    @State private var hasUsedRemoveLast = false
    @State private var planetValidationStates: [UUID: Bool] = [:] // true = correcto, false = incorrecto
    @State private var showingValidation = false
    @State private var showResetAlert = false
    
    init(selectedStructure: Binding<DataStructure?>, completedStructures: Binding<Set<DataStructure>>) {
        self._selectedStructure = selectedStructure
        self._completedStructures = completedStructures
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
                        .frame(minHeight: 80)
                    
                    // Available planets
                    VStack(alignment: .leading) {
                        Text("Available Planets:")
                            .font(.title3)
                            .foregroundColor(.white)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(availablePlanets.filter { !selectedAvailablePlanets.contains($0.id) }) { planet in
                                    planetCard(planet: planet, isSelected: false)
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
                                    planetCard(
                                        planet: planet,
                                        isSelected: selectedPlanetIndex == index,
                                        validationState: planetValidationStates[planet.id]
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
                        
                        HStack(spacing: 15) {
                            Button("Check Level") {
                                checkLevelCompletion()
                            }
                            .buttonStyle(SpaceButtonStyle(color: .green, isDisabled: planets.isEmpty))
                            .disabled(planets.isEmpty)
                            .opacity(planets.isEmpty ? 0.6 : 1)
                            
                            Button("Reset Level") {
                                showResetAlert = true
                            }
                            .buttonStyle(SpaceButtonStyle(color: .purple, isDisabled: false))
                            .alert("Reset Level", isPresented: $showResetAlert) {
                                Button("Cancel", role: .cancel) { }
                                Button("Reset", role: .destructive) {
                                    withAnimation {
                                        resetLevel()
                                    }
                                }
                            } message: {
                                Text("Are you sure you want to reset this level? All progress will be lost.")
                            }
                        }
                        
                        Button {
                            withAnimation {
                                showHint.toggle()
                            }
                        } label: {
                            HStack {
                                Image(systemName: "questionmark.circle.fill")
                                Text(showHint ? "Hide Help" : "Need Help?")
                            }
                        }
                        .buttonStyle(SpaceButtonStyle(color: .blue, isDisabled: false))
                    }
                }
                .padding()
            }
            .allowsHitTesting(!showSuccess && !showError && !showResetAlert)
            
            if showSuccess {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                    .transition(.opacity)
                
                LevelMessageView(
                    title: currentLevel == 4 ? "Congratulations! 🚀" : "Great Job!",
                    message: currentLevel == 4 ? errorMessage : "You completed level \(currentLevel)",
                    buttonText: currentLevel == 4 ? "Back to Menu" : "Next Level",
                    buttonAction: {
                        if currentLevel == 4 {
                            selectedStructure = nil
                        } else {
                            advanceToNextLevel()
                        }
                    },
                    color: .green
                )
            }
            
            if showError {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                    .transition(.opacity)
                
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
            
            if showResetAlert {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                    .transition(.opacity)
            }
        }
    }
    
    private var levelInstructions: some View {
        VStack {
            Text(getCurrentLevelInstructions())
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding()
                .background(Color.blue.opacity(0.2))
                .cornerRadius(10)
                .frame(maxWidth: .infinity)
                .frame(minHeight: 80)
            
            if showHint {
                VStack {
                    Image("answer")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .frame(height: 250)
                        .padding()
                        .background(Color.black.opacity(0.3))
                        .cornerRadius(10)
                    
                    Text(getCurrentLevelHint())
                        .foregroundColor(.yellow)
                        .padding()
                }
                .background(Color.black.opacity(0.5))
                .cornerRadius(10)
                .padding(.vertical)
            }
        }
    }
    
    private func getCurrentLevelInstructions() -> String {
        switch currentLevel {
        case 1:
            return "Tap on the Sun to add it to your solar system!"
        case 2:
            return """
            Create a system with Sun, Mercury and Venus in that order. 
            Practice using both removal methods: 'Remove Selected' and 'Remove Last'
            """
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
            return "Remember the order: Sun, Mercury, Venus. Try both removal methods while practicing"
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
            // Desordenamos los planetas pero mantenemos el Sol primero
            return [allPlanets[0], allPlanets[2], allPlanets[1]] // Sun, Venus, Mercury
        case 3:
            // Desordenamos los planetas del sistema solar interior
            return [allPlanets[0], allPlanets[3], allPlanets[1], allPlanets[4], allPlanets[2]] // Sun, Earth, Mercury, Mars, Venus
        case 4:
            // Desordenamos todos los planetas pero mantenemos el Sol primero
            var planets = Array(allPlanets.dropFirst()).shuffled()
            return [allPlanets[0]] + planets
        default:
            return []
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
        hasUsedRemoveSelected = false
        hasUsedRemoveLast = false
        showingValidation = false
        planetValidationStates.removeAll()
    }
    
    private func advanceToNextLevel() {
        currentLevel += 1
        maxLevelReached = max(maxLevelReached, currentLevel)
        resetLevel()
    }
    
    private func checkLevelCompletion() {
        showingValidation = true
        planetValidationStates.removeAll()
        
        switch currentLevel {
        case 1:
            if planets.count == 1 {
                planetValidationStates[planets[0].id] = planets[0].name == "Sun"
            }
            let isCorrect = planets.count == 1 && planets[0].name == "Sun"
            handleLevelCompletion(isCorrect: isCorrect)
            
        case 2:
            let expectedOrder = ["Sun", "Mercury", "Venus"]
            for (index, planet) in planets.enumerated() {
                if index < expectedOrder.count {
                    planetValidationStates[planet.id] = planet.name == expectedOrder[index]
                } else {
                    planetValidationStates[planet.id] = false
                }
            }
            
            let correctOrder = planets.count == 3 && 
                planets[0].name == "Sun" && 
                planets[1].name == "Mercury" && 
                planets[2].name == "Venus"
            let usedBothButtons = hasUsedRemoveSelected && hasUsedRemoveLast
            
            if correctOrder && !usedBothButtons {
                errorMessage = "Great order! Now try using both removal buttons before completing the level"
                showError = true
                return
            }
            
            handleLevelCompletion(isCorrect: correctOrder && usedBothButtons)
            
        case 3:
            let expectedOrders = [0, 1, 2, 3, 4]
            for (index, planet) in planets.enumerated() {
                if index < expectedOrders.count {
                    planetValidationStates[planet.id] = planet.order == expectedOrders[index]
                } else {
                    planetValidationStates[planet.id] = false
                }
            }
            let currentOrders = planets.map { $0.order }
            handleLevelCompletion(isCorrect: planets.count == 5 && currentOrders == expectedOrders)
            
        default:
            let expectedOrders = Array(0...8)
            for (index, planet) in planets.enumerated() {
                if index < expectedOrders.count {
                    planetValidationStates[planet.id] = planet.order == expectedOrders[index]
                } else {
                    planetValidationStates[planet.id] = false
                }
            }
            let currentOrders = planets.map { $0.order }
            handleLevelCompletion(isCorrect: planets.count == 9 && currentOrders == expectedOrders)
        }
    }
    
    private func handleLevelCompletion(isCorrect: Bool) {
        if isCorrect {
            showSuccess = true
            if currentLevel == 4 {
                completedStructures.insert(.arrays)
                // Mensaje especial para el nivel final
                showSuccess = true
                errorMessage = """
                    You have mastered Arrays!
                    
                    You now understand that arrays:
                    • Store elements in order
                    • Allow adding and removing elements
                    • Keep track of positions
                    • Are perfect for ordered collections
                    
                    Just like organizing planets in our solar system,
                    arrays help us maintain items in a specific sequence.
                    
                    Ready to explore more data structures?
                    """
            }
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
            hasUsedRemoveSelected = true
        }
    }
    
    private func handleRemoveLast() {
        if let removedPlanet = planets.last {
            planets.removeLast()
            
            if !availablePlanets.contains(where: { $0.id == removedPlanet.id }) {
                availablePlanets.append(removedPlanet)
            }
            selectedAvailablePlanets.remove(removedPlanet.id)
            hasUsedRemoveLast = true
        }
    }
    
    private func planetCard(planet: PlanetOption, isSelected: Bool = false, validationState: Bool? = nil) -> some View {
        PlanetCard(
            name: planet.name,
            imageName: planet.image,
            isSelected: isSelected,
            size: 80,
            validationState: showingValidation ? validationState : nil
        )
    }
}

struct PlanetCard: View {
    let name: String
    let imageName: String
    let isSelected: Bool
    let size: CGFloat
    let validationState: Bool?
    
    var body: some View {
        HStack {
            // Flecha de selección a la izquierda
            if isSelected {
                Image(systemName: "chevron.right.circle.fill")
                    .foregroundColor(.orange)
                    .font(.system(size: 20, weight: .bold))
            }
            
            VStack {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: size, height: size)
                    .overlay(
                        Circle()
                            .stroke(validationColor, lineWidth: 3)
                    )
                
                Text(name)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
            }
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.black.opacity(0.3))
        )
    }
    
    private var validationColor: Color {
        if let validation = validationState {
            return validation ? .green : .red
        }
        return .clear
    }
}

struct SpaceButtonStyle: ButtonStyle {
    let color: Color
    let isDisabled: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(color.opacity(isDisabled ? 0.3 : 0.8))
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}  