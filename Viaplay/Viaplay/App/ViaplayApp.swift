import SwiftUI

@main
struct ViaplayApp: App {
    @StateObject private var diContainer = DIContainer.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.diContainer, diContainer)
        }
    }
}
