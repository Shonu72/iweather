import SwiftUI

/// Main Weather Screen pattern matching on WeatherState enum (.idle, .loading, .loaded, .error).
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
            
            // MARK: - State Machine View Dispatcher
            switch viewModel.state {
            case .idle, .loading:
                WeatherSkeletonView()
                    .padding(.horizontal, 20)
                    .transition(.opacity)
                
            case .loaded(let weather):
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        
                        // 1. Header + Unit Picker
                        HStack {
                            LocationHeaderView(
                                location: weather.location,
                                onSearchTapped: {
                                    viewModel.openSearchSheet()
                                },
                                onLocationTapped: {
                                    Task {
                                        await viewModel.fetchCurrentLocationWeather()
                                    }
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
}

#Preview {
    WeatherScreen()
}
