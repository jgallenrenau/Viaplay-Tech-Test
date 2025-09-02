import SwiftUI
import SectionsFeature
import DomainKit
import DataKit
import NetworkingKit
import StorageKit

struct ContentView: View {
    var body: some View {
        NavigationStack {
            SectionsListView(viewModel: makeViewModel())
        }
    }
}

#Preview {
    ContentView()
}

@MainActor private func makeViewModel() -> SectionsViewModel {
    let http = URLSessionHTTPClient()
    let cache = FileJSONDiskCache()
    let etags = UserDefaultsStore()
    let repository = PageRepositoryImpl(http: http, cache: cache, etagStore: etags)
    let useCase = GetRootPage(repository: repository)
    return SectionsViewModel(getRootPage: useCase)
}
