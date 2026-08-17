import SwiftUI

/// Top location header displaying city name from WeatherLocation domain model and search action button.
struct LocationHeaderView: View {
    let location: WeatherLocation
    var onSearchTapped: (() -> Void)? = nil
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(location.city)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                
                Text(location.country)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Button {
                onSearchTapped?()
            } label: {
                Image(systemName: "magnifyingglass")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                    .padding(10)
                    .background(Color.white.opacity(0.12), in: Circle())
            }
        }
        .padding(.top, 8)
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        LocationHeaderView(
            location: WeatherLocation(city: "Bhopal", country: "India", latitude: 23.2599, longitude: 77.4126)
        )
        .padding()
    }
}
