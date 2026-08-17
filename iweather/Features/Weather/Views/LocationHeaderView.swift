import SwiftUI

/// Top location header displaying city name and search action button.
struct LocationHeaderView: View {
    let cityName: String
    var onSearchTapped: (() -> Void)? = nil
    
    var body: some View {
        HStack {
            Text(cityName)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(.primary)
            
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
        LocationHeaderView(cityName: "Bhopal")
            .padding()
    }
}
