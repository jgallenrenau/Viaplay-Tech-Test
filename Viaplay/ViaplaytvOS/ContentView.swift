import SwiftUI
import Sections
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
                NavigationView {
                    SectionsListViewtvOS(viewModel: SectionsFactory.makeSectionsViewModel())
                }
                .navigationViewStyle(StackNavigationViewStyle())
            }
        }
    }
}

#Preview {
    ContentView()
}
