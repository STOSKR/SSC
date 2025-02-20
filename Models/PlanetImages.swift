import SwiftUI

struct PlanetImages {
    static let sun = Image("sun")
    static let mercury = Image("mercury") 
    static let venus = Image("venus")
    static let earth = Image("earth")
    static let mars = Image("mars")
    static let jupiter = Image("jupiter")
    static let saturn = Image("saturn")
    static let uranus = Image("uranus")
    static let neptune = Image("neptune")
    
    // Placeholder image in case the actual image is not found
    static let placeholder = Image(systemName: "circle.fill")
} 