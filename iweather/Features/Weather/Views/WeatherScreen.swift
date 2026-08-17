import SwiftUI
import SwiftData

/// Main Weather Screen pattern matching on WeatherState enum (.idle, .loading, .loaded, .error) using AppTheme design system & fluid animations.
struct WeatherScreen: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var savedCities: [SavedCity]
    @State private var viewModel = WeatherViewModel()
    
    var body: some View {
        ZStack {
            // Dark gradient background canvas from AppTheme
            LinearGradient(
                colors: [AppTheme.Colors.backgroundGradientStart, AppTheme.Colors.backgroundGradientEnd],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // MARK: - State Machine View Dispatcher
            switch viewModel.state {
            case .idle, .loading:
                WeatherSkeletonView()
                    .padding(.horizontal, AppTheme.Spacing.large)
                    .transition(.opacity)
                
            case .loaded(let weather):
                ScrollView(showsIndicators: false) {
                    VStack(spacing: AppTheme.Spacing.xLarge) {
                        
                        // MARK: - Offline Mode Banner Indicator
                        if weather.isFromCache {
                            HStack(spacing: AppTheme.Spacing.xSmall) {
                                Image(systemName: "wifi.slash")
                                    .foregroundStyle(AppTheme.Colors.offlineOrange)
                                Text("Offline Mode — Showing Cached Weather")
                                    .font(AppTheme.Typography.captionSmall)
                                    .foregroundStyle(AppTheme.Colors.textPrimary)
                                Spacer()
                            }
                            .padding(AppTheme.Spacing.small)
                            .background(AppTheme.Colors.offlineOrange.opacity(0.2), in: RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium))
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
                        
                        // 3. Hourly Forecast Section Container
                        AppCardView {
                            HourlyForecastSection(
                                forecasts: weather.hourly,
                                unit: viewModel.selectedUnit
                            )
                        }
                        .scrollTransition { content, phase in
                            content
                                .opacity(phase.isIdentity ? 1.0 : 0.7)
                                .scaleEffect(phase.isIdentity ? 1.0 : 0.96)
                        }
                        
                        // 4. Daily Forecast Section Container
                        AppCardView {
                            DailyForecastSection(
                                forecasts: weather.daily,
                                unit: viewModel.selectedUnit
                            )
                        }
                        .scrollTransition { content, phase in
                            content
                                .opacity(phase.isIdentity ? 1.0 : 0.7)
                                .scaleEffect(phase.isIdentity ? 1.0 : 0.96)
                        }
                        
                        // 5. Weather Details Grid
                        WeatherDetailsSection(
                            current: weather.current,
                            unit: viewModel.selectedUnit
                        )
                        .scrollTransition { content, phase in
                            content
                                .opacity(phase.isIdentity ? 1.0 : 0.7)
                                .scaleEffect(phase.isIdentity ? 1.0 : 0.96)
                        }
                    }
                    .padding(.horizontal, AppTheme.Spacing.large)
                    .padding(.bottom, AppTheme.Spacing.xLarge)
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
        .animation(.easeInOut(duration: 0.35), value: viewModel.state)
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
