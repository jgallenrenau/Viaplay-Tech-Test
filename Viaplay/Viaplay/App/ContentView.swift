import Sections
import SwiftUI
import DSKit

struct ContentView: View {
    @State private var showSplash = true
    
    var body: some View {
        Group {
            if showSplash {
                DesignSystem.Components.splashView {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        showSplash = false
                    }
                }
            } else {
                SectionsListView(viewModel: SectionsFactory.makeSectionsViewModel())
            }
        }
    }
}

#Preview {
    ContentView()
}
