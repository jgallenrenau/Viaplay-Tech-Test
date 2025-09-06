import Sections
import SwiftUI

struct ContentView: View {
    var body: some View {
        SectionsListView(viewModel: SectionsFactory.makeSectionsViewModel())
    }
}

#Preview {
    ContentView()
}
