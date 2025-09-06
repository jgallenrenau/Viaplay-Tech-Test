import Sections
import SwiftUI

struct ContentView: View {
    @Environment(\.diContainer) private var container
    
    var body: some View {
        SectionsListView(viewModel: container.makeSectionsViewModel())
    }
}

#Preview {
    ContentView()
        .environment(\.diContainer, DIContainer.shared)
}
