import SwiftUI

/// Segmented picker control using `@Binding` to modify temperature unit state owned by parent.
struct TemperatureUnitPicker: View {
    @Binding var selectedUnit: TemperatureUnit
    
    var body: some View {
        Picker("Temperature Unit", selection: $selectedUnit) {
            ForEach(TemperatureUnit.allCases) { unit in
                Text(unit.rawValue).tag(unit)
            }
        }
        .pickerStyle(.segmented)
        .frame(width: 100)
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        TemperatureUnitPicker(selectedUnit: .constant(.celsius))
            .padding()
    }
}
