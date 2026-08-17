import Foundation
import SwiftUI

/// Centralized Dependency Injection Container managing core services and factory instantiations.
@MainActor
final class AppContainer {
    static let shared = AppContainer()
    
    let networkClient: NetworkClientProtocol
    let cacheManager: WeatherCacheManagerProtocol
    let weatherService: WeatherServiceProtocol
    let locationManager: LocationManagerProtocol
    
    init(
        networkClient: NetworkClientProtocol = URLSessionNetworkClient(),
        cacheManager: WeatherCacheManagerProtocol = WeatherCacheManager(),
        weatherService: WeatherServiceProtocol? = nil,
        locationManager: LocationManagerProtocol = LocationManager()
    ) {
        self.networkClient = networkClient
        self.cacheManager = cacheManager
        self.weatherService = weatherService ?? WeatherService(client: networkClient, cacheManager: cacheManager)
        self.locationManager = locationManager
    }
    
    /// Factory method instantiating WeatherViewModel using container dependencies.
    func makeWeatherViewModel(initialState: WeatherState = .idle) -> WeatherViewModel {
        WeatherViewModel(
            initialState: initialState,
            weatherService: weatherService,
            locationManager: locationManager
        )
    }
}

// MARK: - SwiftUI Environment Key

private struct AppContainerKey: EnvironmentKey {
    static let defaultValue = AppContainer.shared
}

extension EnvironmentValues {
    var appContainer: AppContainer {
        get { self[AppContainerKey.self] }
        set { self[AppContainerKey.self] = newValue }
    }
}
