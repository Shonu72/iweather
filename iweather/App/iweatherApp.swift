import SwiftUI
import SwiftData

@main
struct iweatherApp: App {
    var body: some Scene {
        WindowGroup {
            WeatherScreen()
        }
        .modelContainer(for: SavedCity.self)
    }
}
