import Foundation

/// Explicit UI State discriminator enum for WeatherScreen (idle, loading, loaded, error).
enum WeatherState: Equatable {
    case idle
    case loading
    case loaded(Weather)
    case error(String)
}
