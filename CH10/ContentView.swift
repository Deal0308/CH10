import SwiftUI

struct ContentView: View {
    var body: some View {
        SpecialistView()
            .accessibilityIdentifier("contentRoot")
    }
}

#Preview {
    ContentView()
}
