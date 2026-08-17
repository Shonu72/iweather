import SwiftUI

/// Section displaying detailed weather metrics (Humidity, Wind, UV Index, Air Quality) in a 2x2 grid.
struct WeatherDetailsSection: View {
    let details: [WeatherDetailItem]
    
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
                ForEach(details) { detail in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 6) {
                            Image(systemName: detail.systemIconName)
                                .foregroundStyle(.secondary)
                                .font(.subheadline)
                            
                            Text(detail.title)
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundStyle(.secondary)
                        }
                        
                        Text(detail.value)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(.primary)
                        
                        Text(detail.description)
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
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        WeatherDetailsSection(details: WeatherViewModel.mockData(for: "Bhopal").details)
            .padding()
    }
}
