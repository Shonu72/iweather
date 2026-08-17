import SwiftUI

/// Main Weather Screen adhering to pure MVVM architecture.
/// View responsibility: Declarative layout only. All UI state & user intent actions are owned by WeatherViewModel.
struct WeatherScreen: View {
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
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    
                    // MARK: - Error Banner State
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
                                    await viewModel.retryFetch()
                                }
                            }
                            .font(.caption)
                            .fontWeight(.bold)
                        }
                        .padding(12)
                        .background(Color.red.opacity(0.2), in: RoundedRectangle(cornerRadius: 12))
                    }
                    
                    // MARK: 1. Location Header + Temperature Unit Picker
                    HStack {
                        LocationHeaderView(
                            location: viewModel.weather.location,
                            onSearchTapped: {
                                viewModel.openSearchSheet()
                            }
                        )
                        
                        Spacer()
                        
                        // Binding TemperatureUnitPicker to viewModel state
                        TemperatureUnitPicker(
                            selectedUnit: Binding(
                                get: { viewModel.selectedUnit },
                                set: { viewModel.setTemperatureUnit($0) }
                            )
                        )
                    }
                    
                    // MARK: 2. Current Weather Card
                    CurrentWeatherCard(
                        current: viewModel.weather.current,
                        unit: viewModel.selectedUnit
                    )
                    
                    // MARK: 3. Hourly Forecast Section
                    HourlyForecastSection(
                        forecasts: viewModel.weather.hourly,
                        unit: viewModel.selectedUnit
                    )
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(Color.white.opacity(0.08))
                    )
                    
                    // MARK: 4. Daily Forecast Section
                    DailyForecastSection(
                        forecasts: viewModel.weather.daily,
                        unit: viewModel.selectedUnit
                    )
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(Color.white.opacity(0.08))
                    )
                    
                    // MARK: 5. Weather Details Section
                    WeatherDetailsSection(
                        current: viewModel.weather.current,
                        unit: viewModel.selectedUnit
                    )
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
            }
            
            // MARK: - Loading Progress Overlay State
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
        // MARK: - Async Initializer Intent Trigger
        .task {
            await viewModel.onAppear()
        }
        // MARK: - Sheet Presentation State Bound to ViewModel
        .sheet(isPresented: $viewModel.isSearchSheetPresented) {
            SearchView(viewModel: viewModel)
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    WeatherScreen()
}
