import SwiftUI

/// Compatibility component wrapping HourlyForecastSection.
struct HourlyForecastView: View {
    let forecasts: [HourlyForecastItem]
    var unit: TemperatureUnit = .celsius
    
    var body: some View {
        HourlyForecastSection(forecasts: forecasts, unit: unit)
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        HourlyForecastView(forecasts: WeatherViewModel.mockData(for: "Bhopal").hourly, unit: .celsius)
            .padding()
    }
}
