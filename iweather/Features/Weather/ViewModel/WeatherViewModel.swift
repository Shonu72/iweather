import Foundation
import Observation

/// ViewModel for managing screen UI state transitions using explicit WeatherState enum.
/// `@MainActor` guarantees that state updates happen safely on the Main thread.
@MainActor
@Observable
final class WeatherViewModel {
    // MARK: - Explicit State Machine
    var state: WeatherState = .idle
    var selectedUnit: TemperatureUnit = .celsius
    
    // MARK: - Search Modal State
    var isSearchSheetPresented: Bool = false
    var searchQuery: String = ""
    var searchResults: [WeatherLocation] = []
    var isSearching: Bool = false
    
    private let weatherService: WeatherServiceProtocol
    private let locationManager: LocationManagerProtocol
    
    private var searchTask: Task<Void, Never>?
    
    /// Convenient accessor to extract loaded weather or mock fallback.
    var currentDisplayWeather: Weather {
        switch state {
        case .loaded(let weather):
            return weather
        default:
            return WeatherViewModel.mockData
        }
    }
    
    init(
        initialState: WeatherState = .idle,
        weatherService: WeatherServiceProtocol = AppContainer.shared.weatherService,
        locationManager: LocationManagerProtocol = AppContainer.shared.locationManager
    ) {
        self.state = initialState
        self.weatherService = weatherService
        self.locationManager = locationManager
    }
    
    // MARK: - User Intent Actions
    
    /// Triggered when the view appears on screen.
    func onAppear() async {
        await fetchWeather(for: "Bhopal")
    }
    
    /// Triggered when user requests weather for current GPS location.
    func fetchCurrentLocationWeather() async {
        state = .loading
        
        do {
            let currentLocation = try await locationManager.requestCurrentLocation()
            let liveWeather = try await weatherService.fetchWeather(for: currentLocation)
            self.state = .loaded(liveWeather)
        } catch {
            self.state = .error(error.localizedDescription)
        }
    }
    
    /// Triggered when user selects a location from search sheet.
    func selectLocation(_ location: WeatherLocation) async {
        isSearchSheetPresented = false
        searchQuery = ""
        searchResults = []
        await fetchWeather(for: location)
    }
    
    /// Triggered when user types in search query textfield. Uses Task cancellation + Task.sleep (350ms) debouncing.
    func updateSearchQuery(_ query: String) {
        self.searchQuery = query
        
        // 1. Cancel previous pending search task
        searchTask?.cancel()
        
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedQuery.isEmpty else {
            self.searchResults = []
            self.isSearching = false
            return
        }
        
        self.isSearching = true
        
        // 2. Schedule 350ms debounced task
        searchTask = Task { @MainActor in
            try? await Task.sleep(nanoseconds: 350_000_000)
            
            guard !Task.isCancelled else { return }
            
            do {
                let results = try await weatherService.searchLocations(query: trimmedQuery)
                if !Task.isCancelled {
                    self.searchResults = results
                    self.isSearching = false
                }
            } catch {
                if !Task.isCancelled {
                    self.searchResults = []
                    self.isSearching = false
                }
            }
        }
    }
    
    /// Triggered when user toggles °C / °F unit picker.
    func setTemperatureUnit(_ unit: TemperatureUnit) {
        self.selectedUnit = unit
    }
    
    /// Triggered when user taps Retry on error screen.
    func retryFetch() async {
        if case .loaded(let currentWeather) = state {
            await fetchWeather(for: currentWeather.location)
        } else {
            await fetchWeather(for: "Bhopal")
        }
    }
    
    /// Triggered when user opens search sheet.
    func openSearchSheet() {
        isSearchSheetPresented = true
    }
    
    /// Triggered when user closes search sheet.
    func closeSearchSheet() {
        searchTask?.cancel()
        isSearchSheetPresented = false
        searchQuery = ""
        searchResults = []
        isSearching = false
    }
    
    // MARK: - Private API Data Fetching
    
    private func fetchWeather(for cityName: String) async {
        state = .loading
        
        do {
            let locations = try await weatherService.searchLocations(query: cityName)
            guard let firstLocation = locations.first else {
                throw NetworkError.noResultsFound
            }
            
            let liveWeather = try await weatherService.fetchWeather(for: firstLocation)
            self.state = .loaded(liveWeather)
        } catch {
            // If searchLocations failed (e.g. offline), try fetching directly for city from disk cache!
            let fallbackLocation = WeatherLocation(city: cityName, country: "", latitude: 0, longitude: 0)
            do {
                let cachedWeather = try await weatherService.fetchWeather(for: fallbackLocation)
                self.state = .loaded(cachedWeather)
            } catch {
                self.state = .error(error.localizedDescription)
            }
        }
    }
    
    private func fetchWeather(for location: WeatherLocation) async {
        state = .loading
        
        do {
            let liveWeather = try await weatherService.fetchWeather(for: location)
            self.state = .loaded(liveWeather)
        } catch {
            self.state = .error(error.localizedDescription)
        }
    }
    
    // MARK: - Static Mock Data (Non-isolated)
    
    nonisolated static var mockData: Weather {
        mockData(for: "Bhopal")
    }
    
    nonisolated static func mockData(for city: String) -> Weather {
        let mockMap: [String: (country: String, lat: Double, lon: Double, temp: Int, feelsLike: Int, condition: WeatherCondition, high: Int, low: Int, humidity: Int, wind: Double, pressure: Int, uv: Int, vis: Double)] = [
            "Bhopal": ("India", 23.2599, 77.4126, 29, 31, .sunny, 32, 24, 68, 12.0, 1012, 6, 10.0),
            "Mumbai": ("India", 19.0760, 72.8777, 33, 38, .sunny, 35, 27, 82, 16.5, 1008, 8, 10.0),
            "Delhi": ("India", 28.7041, 77.1025, 36, 40, .haze, 39, 29, 55, 10.0, 1005, 9, 6.0),
            "Bengaluru": ("India", 12.9716, 77.5946, 24, 24, .partlyCloudy, 27, 19, 60, 14.2, 1015, 5, 10.0),
            "London": ("United Kingdom", 51.5074, -0.1278, 18, 17, .lightRain, 20, 14, 78, 22.0, 1018, 3, 9.0),
            "Tokyo": ("Japan", 35.6762, 139.6503, 26, 26, .clear, 28, 20, 50, 11.0, 1020, 7, 10.0)
        ]
        
        let data = mockMap[city] ?? ("India", 20.0, 78.0, 25, 26, .partlyCloudy, 28, 20, 60, 12.0, 1013, 5, 10.0)
        
        return Weather(
            location: WeatherLocation(city: city, country: data.country, latitude: data.lat, longitude: data.lon),
            current: CurrentWeather(temperature: data.temp, feelsLike: data.feelsLike, highTemperature: data.high, lowTemperature: data.low, condition: data.condition, humidity: data.humidity, windSpeed: data.wind, pressure: data.pressure, uvIndex: data.uv, visibility: data.vis),
            hourly: [
                HourlyForecastItem(time: "12 PM", temperature: data.temp, condition: data.condition),
                HourlyForecastItem(time: "1 PM", temperature: data.temp + 1, condition: data.condition),
                HourlyForecastItem(time: "2 PM", temperature: data.temp + 2, condition: .partlyCloudy),
                HourlyForecastItem(time: "3 PM", temperature: data.temp, condition: .lightRain),
                HourlyForecastItem(time: "4 PM", temperature: data.temp - 2, condition: .thunderstorm),
                HourlyForecastItem(time: "5 PM", temperature: data.temp - 1, condition: .partlyCloudy)
            ],
            daily: [
                DailyForecastItem(day: "Mon", highTemperature: data.high, lowTemperature: data.low, condition: data.condition),
                DailyForecastItem(day: "Tue", highTemperature: data.high + 1, lowTemperature: data.low + 1, condition: .partlyCloudy),
                DailyForecastItem(day: "Wed", highTemperature: data.high - 2, lowTemperature: data.low - 1, condition: .lightRain),
                DailyForecastItem(day: "Thu", highTemperature: data.high + 2, lowTemperature: data.low, condition: .sunny),
                DailyForecastItem(day: "Fri", highTemperature: data.high, lowTemperature: data.low - 2, condition: .partlyCloudy),
                DailyForecastItem(day: "Sat", highTemperature: data.high - 3, lowTemperature: data.low - 3, condition: .heavyRain),
                DailyForecastItem(day: "Sun", highTemperature: data.high - 1, lowTemperature: data.low - 2, condition: .sunny)
            ]
        )
    }
}
