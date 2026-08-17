import SwiftUI

/// Main Weather Screen consuming strongly-typed Weather domain models.
struct WeatherScreen: View {
    // MARK: - Local UI State (@State)
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
        }
        // MARK: - Modal Sheet Presentation
        .sheet(isPresented: $isSearchPresented) {
            SearchView(
                searchText: $searchText,
                availableCities: viewModel.availableCities,
                onSelectCity: { selectedCity in
                    viewModel.selectCity(selectedCity)
                }
            )
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    WeatherScreen()
}
