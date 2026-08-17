import SwiftUI

/// Header component displaying city name, search launcher button, and current GPS location button.
struct LocationHeaderView: View {
    let location: WeatherLocation
    var onSearchTapped: () -> Void
    var onLocationTapped: (() -> Void)? = nil
    
    var body: some View {
        HStack(spacing: 10) {
            // City name & search launcher button
            Button {
                onSearchTapped()
            } label: {
                HStack(spacing: 6) {
                    Text(location.city)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)
                    
                    Image(systemName: "magnifyingglass")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            
            // GPS Location Button
            if let onLocationTapped {
                Button {
                    onLocationTapped()
                } label: {
                    Image(systemName: "location.fill")
                        .font(.subheadline)
                        .foregroundStyle(.blue)
                        .padding(8)
                        .background(Color.blue.opacity(0.15), in: Circle())
                }
            }
        }
    }
}

#Preview {
    LocationHeaderView(
        location: WeatherLocation(city: "Bhopal", country: "India", latitude: 23.2599, longitude: 77.4126),
        onSearchTapped: {},
        onLocationTapped: {}
    )
    .padding()
    .background(Color.black)
}
