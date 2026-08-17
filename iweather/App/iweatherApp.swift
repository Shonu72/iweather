import SwiftUI
import SwiftData

@main
struct iweatherApp: App {
    private let container = AppContainer.shared
    
    var body: some Scene {
        WindowGroup {
            WeatherScreen()
                .environment(\.appContainer, container)
        }
        .modelContainer(for: SavedCity.self)
    }
}
