import SwiftUI
import SwiftData

/// Main Weather Screen pattern matching on WeatherState enum (.idle, .loading, .loaded, .error).
struct WeatherScreen: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var savedCities: [SavedCity]
    @State private var viewModel = WeatherViewModel()
    
    var body: some View {
        ZStack {
            // Dark gradient background canvas
            LinearGradient(
                colors: [Color(white: 0.1), Color(white: 0.05)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // MARK: - State Machine View Dispatcher
            switch viewModel.state {
            case .idle, .loading:
                WeatherSkeletonView()
                    .padding(.horizontal, 20)
                    .transition(.opacity)
                
            case .loaded(let weather):
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        
                        // MARK: - Offline Mode Banner Indicator
                        if weather.isFromCache {
                            HStack(spacing: 8) {
                                Image(systemName: "wifi.slash")
                                    .foregroundStyle(.orange)
                                Text("Offline Mode — Showing Cached Weather")
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .foregroundStyle(.primary)
                                Spacer()
                            }
                            .padding(10)
                            .background(Color.orange.opacity(0.2), in: RoundedRectangle(cornerRadius: 10))
                        }
                        
                        // 1. Header + Bookmark Toggle + Unit Picker
                        HStack {
                            LocationHeaderView(
                                location: weather.location,
                                isBookmarked: isCitySaved(location: weather.location),
                                onSearchTapped: {
                                    viewModel.openSearchSheet()
                                },
                                onLocationTapped: {
                                    Task {
                                        await viewModel.fetchCurrentLocationWeather()
                                    }
                                },
                                onBookmarkTapped: {
                                    toggleBookmark(location: weather.location)
                                }
                            )
                            
                            Spacer()
                            
                            TemperatureUnitPicker(
                                selectedUnit: Binding(
                                    get: { viewModel.selectedUnit },
                                    set: { viewModel.setTemperatureUnit($0) }
                                )
                            )
                        }
                        
                        // 2. Current Weather Hero Card
                        CurrentWeatherCard(
                            current: weather.current,
                            unit: viewModel.selectedUnit
                        )
                        
                        // 3. Hourly Forecast Section
                        HourlyForecastSection(
                            forecasts: weather.hourly,
                            unit: viewModel.selectedUnit
                        )
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .fill(Color.white.opacity(0.08))
                        )
                        
                        // 4. Daily Forecast Section
                        DailyForecastSection(
                            forecasts: weather.daily,
                            unit: viewModel.selectedUnit
                        )
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .fill(Color.white.opacity(0.08))
                        )
                        
                        // 5. Weather Details Grid
                        WeatherDetailsSection(
                            current: weather.current,
                            unit: viewModel.selectedUnit
                        )
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 24)
                }
                .transition(.opacity)
                
            case .error(let errorMessage):
                WeatherErrorView(
                    message: errorMessage,
                    onRetry: {
                        Task {
                            await viewModel.retryFetch()
                        }
                    }
                )
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: viewModel.state)
        // MARK: - Task Trigger
        .task {
            await viewModel.onAppear()
        }
        // MARK: - Search Modal Sheet
        .sheet(isPresented: $viewModel.isSearchSheetPresented) {
            SearchView(viewModel: viewModel)
        }
        .preferredColorScheme(.dark)
    }
    
    // MARK: - SwiftData Helpers
    
    private func isCitySaved(location: WeatherLocation) -> Bool {
        savedCities.contains {
            $0.city.lowercased() == location.city.lowercased() &&
            $0.country.lowercased() == location.country.lowercased()
        }
    }
    
    private func toggleBookmark(location: WeatherLocation) {
        if let existing = savedCities.first(where: {
            $0.city.lowercased() == location.city.lowercased() &&
            $0.country.lowercased() == location.country.lowercased()
        }) {
            modelContext.delete(existing)
        } else {
            let newCity = SavedCity(
                city: location.city,
                country: location.country,
                latitude: location.latitude,
                longitude: location.longitude
            )
            modelContext.insert(newCity)
        }
    }
}

#Preview {
    WeatherScreen()
        .modelContainer(for: SavedCity.self, inMemory: true)
}
