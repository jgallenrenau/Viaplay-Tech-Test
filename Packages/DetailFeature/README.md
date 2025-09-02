# DetailFeature

## Overview
Feature module for the detail screen (MVVM + UseCase). Mirrors the same separation used in other features.

## Architecture
```
SwiftUI View → ViewModel → UseCase (Domain) → Repository (DataKit)
```

## Components
- View: `DetailView`
- ViewModel (planned): binds to `GetPageUseCase`

## Example wiring (App)
```swift
let repo = PageRepositoryImpl(http: http, cache: cache, etagStore: etags)
let useCase = GetPage(repository: repo)
// later: DetailViewModel(useCase: useCase)
```

## Testing
- Provide a fake `GetPageUseCase` and validate state transitions in the ViewModel.
