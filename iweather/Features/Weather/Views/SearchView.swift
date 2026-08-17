import SwiftUI
import SwiftData

/// Search modal sheet consuming WeatherViewModel and SwiftData SavedCity model.
struct SearchView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Bindable var viewModel: WeatherViewModel
    
    @Query(sort: \SavedCity.dateAdded, order: .reverse) private var savedCities: [SavedCity]
    
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
                // MARK: 1. Quick GPS Current Location Button
                Section {
                    Button {
                        Task {
                            viewModel.closeSearchSheet()
                            dismiss()
                            await viewModel.fetchCurrentLocationWeather()
                        }
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: "location.fill")
                                .foregroundStyle(.blue)
                            Text("Use Current Location")
                                .font(.body)
                                .fontWeight(.medium)
                                .foregroundStyle(.blue)
                        }
                    }
                }
                
                // MARK: 2. Saved Cities Section (SwiftData @Query)
                if viewModel.searchQuery.isEmpty && !savedCities.isEmpty {
                    Section("Saved Cities (\(savedCities.count))") {
                        ForEach(savedCities) { savedItem in
                            locationRow(location: savedItem.asWeatherLocation)
                        }
                        .onDelete(perform: deleteSavedCities)
                    }
                }
                
                // MARK: 3. Search Results / Popular Cities / Empty States
                if viewModel.isSearching {
                    Section {
                        HStack(spacing: 12) {
                            ProgressView()
                                .tint(.blue)
                            Text("Searching cities...")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 8)
                    }
                } else if viewModel.searchQuery.isEmpty {
                    Section("Popular Cities") {
                        ForEach(defaultCities, id: \.city) { location in
                            locationRow(location: location)
                        }
                    }
                } else if viewModel.searchResults.isEmpty {
                    Section {
                        ContentUnavailableView.search(text: viewModel.searchQuery)
                    }
                } else {
                    Section("Search Results") {
                        ForEach(viewModel.searchResults, id: \.city) { location in
                            locationRow(location: location)
                        }
                    }
                }
            }
            .searchable(text: $viewModel.searchQuery, prompt: "Search city name...")
            .onChange(of: viewModel.searchQuery) { _, newQuery in
                viewModel.updateSearchQuery(newQuery)
            }
            .navigationTitle("Select Location")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        viewModel.closeSearchSheet()
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }
    
    private func deleteSavedCities(offsets: IndexSet) {
        for index in offsets {
            let itemToDelete = savedCities[index]
            modelContext.delete(itemToDelete)
        }
    }
    
    @ViewBuilder
    private func locationRow(location: WeatherLocation) -> some View {
        Button {
            Task {
                await viewModel.selectLocation(location)
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
    SearchView(viewModel: WeatherViewModel())
        .modelContainer(for: SavedCity.self, inMemory: true)
}
