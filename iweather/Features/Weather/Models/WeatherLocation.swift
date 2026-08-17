import Foundation

/// Domain model representing a geographical weather location.
struct WeatherLocation: Codable, Equatable {
    let city: String
    let country: String
    let latitude: Double
    let longitude: Double
    
    /// Formatted display string (e.g. "Bhopal, India").
    var displayName: String {
        "\(city), \(country)"
    }
}
