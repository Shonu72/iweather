import Foundation
import SwiftData

/// SwiftData persistent model representing a saved city location.
@Model
final class SavedCity {
    @Attribute(.unique) var id: String
    var city: String
    var country: String
    var latitude: Double
    var longitude: Double
    var dateAdded: Date
    
    init(city: String, country: String, latitude: Double, longitude: Double, dateAdded: Date = Date()) {
        self.id = "\(city.lowercased())_\(country.lowercased())_\(latitude)_\(longitude)"
        self.city = city
        self.country = country
        self.latitude = latitude
        self.longitude = longitude
        self.dateAdded = dateAdded
    }
    
    /// Helper converting SavedCity to domain WeatherLocation.
    var asWeatherLocation: WeatherLocation {
        WeatherLocation(city: city, country: country, latitude: latitude, longitude: longitude)
    }
}
