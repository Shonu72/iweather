import SwiftUI

struct WeatherView: View {
    @State private var viewModel = WeatherViewModel()
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(white: 0.1), Color(white: 0.05)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    
                    // MARK: - Top Header Bar (City + Search Icon)
                    HStack {
                        Text(viewModel.weatherData.cityName)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(.primary)
                        
                        Spacer()
                        
                        Button {
                            // Search action placeholder
                        } label: {
                            Image(systemName: "magnifyingglass")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundStyle(.primary)
                                .padding(8)
                                .background(Color.white.opacity(0.1), in: Circle())
                        }
                    }
                    .padding(.top, 8)
                    
                    // MARK: - Hero Weather Summary
                    VStack(spacing: 8) {
                        Image(systemName: "sun.max.fill")
                            .symbolRenderingMode(.multicolor)
                            .font(.system(size: 72))
                            .padding(.vertical, 4)
                        
                        Text("\(viewModel.weatherData.currentTemperature)°")
                            .font(.system(size: 72, weight: .thin, design: .rounded))
                        
                        Text(viewModel.weatherData.condition)
                            .font(.title2)
                            .fontWeight(.medium)
                            .foregroundStyle(.secondary)
                        
                        Text("H: \(viewModel.weatherData.highTemperature)°   L: \(viewModel.weatherData.lowTemperature)°")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    
                    // MARK: - Hourly Forecast Section Card
                    HourlyForecastView(forecasts: viewModel.weatherData.hourlyForecasts)
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .fill(Color.white.opacity(0.08))
                        )
                    
                    // MARK: - 7 Day Forecast Section Card
                    DailyForecastView(forecasts: viewModel.weatherData.dailyForecasts)
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .fill(Color.white.opacity(0.08))
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
    WeatherView()
}
