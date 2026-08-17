import SwiftUI

/// Main Weather Screen demonstrating full API pipeline (API -> URLSession -> JSONDecoder -> Weather Model -> ViewModel -> SwiftUI).
struct WeatherScreen: View {
    // MARK: - Reactive UI State (@State)
    @State private var viewModel = WeatherViewModel()
    @State private var isSearchPresented = false
    @State private var searchText = ""
    @State private var selectedUnit: TemperatureUnit = .celsius
    
    var body: some View {
        ZStack {
            // Dark gradient background canvas
            LinearGradient(
                colors: [Color(white: 0.1), Color(white: 0.05)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    
                    // MARK: - Error Banner (if API fetch fails)
                    if let errorMessage = viewModel.errorMessage {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundStyle(.yellow)
                            Text(errorMessage)
                                .font(.caption)
                                .foregroundStyle(.primary)
                            Spacer()
                            Button("Retry") {
                                Task {
                                    await viewModel.fetchWeather(for: viewModel.weather.location.city)
                                }
                            }
                            .font(.caption)
                            .fontWeight(.bold)
                        }
                        .padding(12)
                        .background(Color.red.opacity(0.2), in: RoundedRectangle(cornerRadius: 12))
                    }
                    
                    // MARK: 1. Location Header + Unit Picker Toggle
                    HStack {
                        LocationHeaderView(
                            location: viewModel.weather.location,
                            onSearchTapped: {
                                isSearchPresented = true
                            }
                        )
                        
                        Spacer()
                        
                        // Segmented control modifying selectedUnit state via @Binding
                        TemperatureUnitPicker(selectedUnit: $selectedUnit)
                    }
                    
                    // MARK: 2. Current Weather Card
                    CurrentWeatherCard(
                        current: viewModel.weather.current,
                        unit: selectedUnit
                    )
                    
                    // MARK: 3. Hourly Forecast Section
                    HourlyForecastSection(
                        forecasts: viewModel.weather.hourly,
                        unit: selectedUnit
                    )
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(Color.white.opacity(0.08))
                    )
                    
                    // MARK: 4. Daily Forecast Section
                    DailyForecastSection(
                        forecasts: viewModel.weather.daily,
                        unit: selectedUnit
                    )
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(Color.white.opacity(0.08))
                    )
                    
                    // MARK: 5. Weather Details Section
                    WeatherDetailsSection(
                        current: viewModel.weather.current,
                        unit: selectedUnit
                    )
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
            }
            
            // MARK: - Loading Progress Overlay
            if viewModel.isLoading {
                ZStack {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                    
                    VStack(spacing: 12) {
                        ProgressView()
                            .scaleEffect(1.3)
                            .tint(.white)
                        Text("Fetching live weather...")
                            .font(.subheadline)
                            .foregroundStyle(.white)
                    }
                    .padding(24)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(white: 0.15))
                    )
                }
            }
        }
        // MARK: - Async Task Trigger on Screen Load
        .task {
            await viewModel.fetchWeather(for: "Bhopal")
        }
        // MARK: - Modal Search Sheet
        .sheet(isPresented: $isSearchPresented) {
            SearchView(
                searchText: $searchText,
                searchResults: viewModel.searchResults,
                onSearchQueryChanged: { query in
                    await viewModel.searchCities(query: query)
                },
                onSelectLocation: { selectedLocation in
                    await viewModel.fetchWeather(for: selectedLocation)
                }
            )
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    WeatherScreen()
}
