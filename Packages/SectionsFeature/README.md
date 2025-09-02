# SectionsFeature

## Overview
Feature module for the home/sections list following MVVM + UseCase.

## Architecture
```
SwiftUI View → ViewModel → UseCase (Domain) → Repository (DataKit)
                          ↑ publishes state
```

## Components
- View: `SectionsListView`
- ViewModel: `SectionsViewModel` (binds to `GetRootPageUseCase`)

## Example wiring (App)
```swift
let http = URLSessionHTTPClient()
let cache = FileJSONDiskCache()
let etags = UserDefaultsStore()
let repo = PageRepositoryImpl(http: http, cache: cache, etagStore: etags)
let useCase = GetRootPage(repository: repo)
let vm = SectionsViewModel(getRootPage: useCase)
SectionsListView(viewModel: vm)
```

## Testing
- Provide a fake `GetRootPageUseCase` that returns a `Page`
- Assert published `sections` and `title`
