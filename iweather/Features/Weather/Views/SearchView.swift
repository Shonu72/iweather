import SwiftUI

/// Search modal sheet querying live Geocoding API with `@Binding` and `@Environment(\.dismiss)`.
struct SearchView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var searchText: String
    let searchResults: [WeatherLocation]
    let onSearchQueryChanged: (String) async -> Void
    let onSelectLocation: (WeatherLocation) async -> Void
    
    private let defaultCities = [
        WeatherLocation(city: "Bhopal", country: "India", latitude: 23.2599, longitude: 77.4126),
        WeatherLocation(city: "Mumbai", country: "India", latitude: 19.0760, longitude: 72.8777),
        WeatherLocation(city: "Delhi", country: "India", latitude: 28.7041, longitude: 77.1025),
        WeatherLocation(city: "Bengaluru", country: "India", latitude: 12.9716, longitude: 77.5946),
        WeatherLocation(city: "London", country: "United Kingdom", latitude: 51.5074, longitude: -0.1278),
        WeatherLocation(city: "Tokyo", country: "Japan", latitude: 35.6762, longitude: 139.6503)
    ]
    
    var body: some View {
        NavigationStack {
            List {
                if searchText.isEmpty {
                    Section("Popular Cities") {
                        ForEach(defaultCities, id: \.city) { location in
                            locationRow(location: location)
                        }
                    }
                } else if searchResults.isEmpty {
                    Section {
                        ContentUnavailableView.search(text: searchText)
                    }
                } else {
                    Section("Search Results") {
                        ForEach(searchResults, id: \.city) { location in
                            locationRow(location: location)
                        }
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search city name...")
            .onChange(of: searchText) { oldValue, newValue in
                Task {
                    await onSearchQueryChanged(newValue)
                }
            }
            .navigationTitle("Select Location")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }
    
    @ViewBuilder
    private func locationRow(location: WeatherLocation) -> some View {
        Button {
            Task {
                await onSelectLocation(location)
                dismiss()
            }
        } label: {
            HStack {
                Image(systemName: "mappin.and.ellipse")
                    .foregroundStyle(.blue)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(location.city)
                        .font(.body)
                        .foregroundStyle(.primary)
                    
                    if !location.country.isEmpty {
                        Text(location.country)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
        }
    }
}

#Preview {
    SearchView(
        searchText: .constant(""),
        searchResults: [],
        onSearchQueryChanged: { _ in },
        onSelectLocation: { _ in }
    )
}
