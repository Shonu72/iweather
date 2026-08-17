import SwiftUI

/// Search modal sheet using `@Binding` for search text input and `@Environment(\.dismiss)` for dismissal.
struct SearchView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var searchText: String
    let availableCities: [String]
    let onSelectCity: (String) -> Void
    
    private var filteredCities: [String] {
        if searchText.isEmpty {
            return availableCities
        } else {
            return availableCities.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section("Search Cities") {
                    ForEach(filteredCities, id: \.self) { city in
                        Button {
                            onSelectCity(city)
                            dismiss()
                        } label: {
                            HStack {
                                Image(systemName: "mappin.and.ellipse")
                                    .foregroundStyle(.blue)
                                Text(city)
                                    .font(.body)
                                    .foregroundStyle(.primary)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundStyle(.tertiary)
                            }
                        }
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search city name...")
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
}

#Preview {
    SearchView(
        searchText: .constant(""),
        availableCities: ["Bhopal", "Mumbai", "Delhi", "London"],
        onSelectCity: { _ in }
    )
}
