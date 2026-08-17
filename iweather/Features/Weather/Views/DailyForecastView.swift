import SwiftUI

/// Compatibility component wrapping DailyForecastSection.
struct DailyForecastView: View {
    let forecasts: [DailyForecastItem]
    var unit: TemperatureUnit = .celsius
    
    var body: some View {
        DailyForecastSection(forecasts: forecasts, unit: unit)
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        DailyForecastView(forecasts: WeatherViewModel.mockData(for: "Bhopal").daily, unit: .celsius)
            .padding()
    }
}
