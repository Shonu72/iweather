import Foundation

/// Temperature scale units (°C vs °F).
enum TemperatureUnit: String, CaseIterable, Identifiable, Codable {
    case celsius = "°C"
    case fahrenheit = "°F"
    
    var id: String { rawValue }
    
    /// Converts a base Celsius temperature value into a display string for this unit.
    func formatted(_ celsiusTemp: Int) -> String {
        switch self {
        case .celsius:
            return "\(celsiusTemp)°"
        case .fahrenheit:
            let f = Int(Double(celsiusTemp) * 9.0 / 5.0 + 32.0)
            return "\(f)°"
        }
    }
}
