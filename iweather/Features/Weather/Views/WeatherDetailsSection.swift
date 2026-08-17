import SwiftUI

/// Section displaying detailed weather metrics from CurrentWeather domain model in a 2x2 grid.
struct WeatherDetailsSection: View {
    let current: CurrentWeather
    var unit: TemperatureUnit = .celsius
    
    private let columns = [
        GridItem(.flexible(), spacing: 14),
        GridItem(.flexible(), spacing: 14)
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Weather Details")
                .font(.headline)
                .foregroundStyle(.secondary)
            
            LazyVGrid(columns: columns, spacing: 14) {
                detailCard(
                    title: "FEELS LIKE",
                    value: unit.formatted(current.feelsLike),
                    iconName: "thermometer.medium",
                    description: "Similar to actual temperature"
                )
                
                detailCard(
                    title: "HUMIDITY",
                    value: "\(current.humidity)%",
                    iconName: "humidity",
                    description: "The dew point is active."
                )
                
                detailCard(
                    title: "WIND",
                    value: "\(Int(current.windSpeed)) km/h",
                    iconName: "wind",
                    description: "Moderate breezes"
                )
                
                detailCard(
                    title: "PRESSURE",
                    value: "\(current.pressure) hPa",
                    iconName: "gauge.with.dots.needle.bottom.50percent",
                    description: "Normal atmospheric level"
                )
                
                detailCard(
                    title: "UV INDEX",
                    value: "\(current.uvIndex)",
                    iconName: "sun.max",
                    description: "Moderate sun exposure"
                )
                
                detailCard(
                    title: "VISIBILITY",
                    value: "\(Int(current.visibility)) km",
                    iconName: "eye",
                    description: "Clear visibility"
                )
            }
        }
    }
    
    @ViewBuilder
    private func detailCard(title: String, value: String, iconName: String, description: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: iconName)
                    .foregroundStyle(.secondary)
                    .font(.subheadline)
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
            }
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.primary)
            
            Text(description)
                .font(.caption2)
                .foregroundStyle(.secondary)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.white.opacity(0.06))
        )
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        WeatherDetailsSection(
            current: CurrentWeather(
                temperature: 29,
                feelsLike: 31,
                highTemperature: 32,
                lowTemperature: 24,
                condition: .sunny,
                humidity: 68,
                windSpeed: 12.0,
                pressure: 1012,
                uvIndex: 6,
                visibility: 10.0
            ),
            unit: .celsius
        )
        .padding()
    }
}
