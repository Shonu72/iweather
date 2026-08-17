import SwiftUI

/// Main Weather Screen composing all modular weather view components.
struct WeatherScreen: View {
    @State private var viewModel = WeatherViewModel()
    
    var body: some View {
        ZStack {
            // Edge-to-edge dark gradient canvas
            LinearGradient(
                colors: [Color(white: 0.1), Color(white: 0.05)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    
                    // MARK: 1. Location Header
                    LocationHeaderView(
                        cityName: viewModel.weatherData.cityName,
                        onSearchTapped: {
                            // Search action trigger
                        }
                    )
                    
                    // MARK: 2. Current Weather Card (Composes TemperatureView + WeatherConditionView)
                    CurrentWeatherCard(
                        systemIconName: "sun.max.fill",
                        temperature: viewModel.weatherData.currentTemperature,
                        condition: viewModel.weatherData.condition,
                        highTemperature: viewModel.weatherData.highTemperature,
                        lowTemperature: viewModel.weatherData.lowTemperature
                    )
                    
                    // MARK: 3. Hourly Forecast Section (Composes HourlyWeatherCard items)
                    HourlyForecastSection(
                        forecasts: viewModel.weatherData.hourlyForecasts
                    )
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(Color.white.opacity(0.08))
                    )
                    
                    // MARK: 4. Daily Forecast Section (Composes DailyWeatherRow items)
                    DailyForecastSection(
                        forecasts: viewModel.weatherData.dailyForecasts
                    )
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(Color.white.opacity(0.08))
                    )
                    
                    // MARK: 5. Weather Details Section
                    WeatherDetailsSection(
                        details: viewModel.weatherData.details
                    )
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    WeatherScreen()
}
