<div align="center">
  <img src="DocResources/viaplay_image_header.jpeg" alt="Viaplay Tech Test" width="800"/>
</div>

<div align="center">

# Viaplay Tech Test

[![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)](https://swift.org)
[![Xcode](https://img.shields.io/badge/Xcode-15.0-blue.svg)](https://developer.apple.com/xcode/)
[![License](https://img.shields.io/badge/License-MIT-orange.svg)](LICENSE)
<!-- [![iOS](https://img.shields.io/badge/iOS-17.0+-lightgrey.svg)](https://developer.apple.com/ios/) -->
</div>

## 🎬 App Demonstration Videos

### iOS - Normal Usage (Online + Light Mode)
<p align="center">
  <img src="DocResources/with-network.gif" width="350" />
</p>
<p align="center">
  The app running with full network connectivity in light mode, showcasing smooth navigation between sections and detail views with modern card-based UI design.
</p>

### iOS - Offline Experience (No Network + Dark Mode)
<p align="center">
  <img src="DocResources/without-network-and-dark-mode.gif" width="350" />
</p>
<p align="center">
  Demonstrating the offline-first functionality with cached data and dark mode interface. The app continues to work seamlessly even without network connectivity.
</p>

### tvOS - Apple TV Experience
<p align="center">
  <img src="DocResources/tvOS.gif" width="800" height="560" />
</p>
<p align="center">
  <strong>The tvOS version optimized for Apple TV with focus-based navigation, larger UI elements, and smooth focus effects designed for remote control interaction.</strong>
</p>
<p align="center">
  Experience the seamless cross-platform functionality with beautiful focus animations, card-based design, and intuitive navigation optimized for the Apple TV remote. The app demonstrates how the same codebase delivers native experiences across both iOS and tvOS platforms.
</p>

---

## 📋 Table of Contents

1. [🎬 App Demonstration Videos](#-app-demonstration-videos)
2. [🚀 Getting Started](#-getting-started)
3. [Overview](#overview)
4. [📱 Device Compatibility & Features](#-device-compatibility--features)
5. [📺 tvOS Support & Cross-Platform Architecture](#-tvos-support--cross-platform-architecture)
6. [🏗️ Architecture overview](#-architecture-overview)
7. [🧱 Modular architecture (SPM)](#-modular-architecture-spm)
8. [🚀 App Features](#-app-features)
9. [🎨 Recent UI/UX Enhancements](#-recent-uiux-enhancements)
10. [⚡ Advanced Concurrency & Thread Safety](#-advanced-concurrency--thread-safety)
11. [🔄 DTO/Mapper Pattern Implementation](#-dtomapper-pattern-implementation)
12. [🧪 Testing strategy](#-testing-strategy)
13. [🛠️ Technical Stack](#-technical-stack)
14. [🛠️ Development Tools](#-development-tools)
15. [📈 Scalability and team workflow](#-scalability-and-team-workflow)
16. [🧠 SOLID applied](#-solid-applied)
17. [🗂️ Module index](#-module-index)
18. [🚀 Continuous Integration (CI) with GitHub Actions](#-continuous-integration-ci-with-github-actions)
19. [🧹 Linting with SwiftLint](#-linting-with-swiftlint)

## 🚀 Getting Started

### **Prerequisites**
- `Xcode 15.0+`
- `Swift 5.9+`
- `iOS 17.0+` / `tvOS 16.0+`
- `SwiftLint` (`brew install swiftlint`)

### **Installation**

**1. Clone the repository:**
```bash
git clone https://github.com/jordigallenrenau/Viaplay-Tech-Test.git
cd Viaplay-Tech-Test
```

**2. Open and build:**
```bash
open Viaplay/Viaplay.xcodeproj
```

**3. Run tests:**
```bash
# iOS tests
xcodebuild test \
  -project Viaplay/Viaplay.xcodeproj \
  -scheme Viaplay \
  -destination 'platform=iOS Simulator,name=iPhone 16 Pro,OS=latest'

# tvOS tests
xcodebuild test \
  -project Viaplay/Viaplay.xcodeproj \
  -scheme ViaplaytvOS \
  -destination 'platform=tvOS Simulator,name=Apple TV 4K (3rd generation),OS=latest'
```

**4. Run SwiftLint:**
```bash
swiftlint --strict
```

## Overview

The Viaplay Tech Test is a Swift-based cross-platform application that demonstrates modern iOS and tvOS development practices through a modular architecture built with Swift Package Manager (SPM). This project showcases a content browsing experience with sections and detailed views, leveraging Clean Architecture principles, MVVM pattern, and an offline-first strategy with ETag-based caching.

## 📱 Device Compatibility & Features

### **Supported Devices**
- **iPhone**: All iPhone models running iOS 17.0+
- **iPad**: All iPad models running iPadOS 17.0+
- **Apple TV**: All Apple TV models running tvOS 16.0+
- **Universal App**: Optimized for iPhone, iPad, and Apple TV with adaptive layouts
- **Orientation Support**: Full rotation support for both portrait and landscape modes (iOS/iPadOS)

### **User Experience Features**
- **🌙 Dark Mode**: Native dark mode support with automatic system theme detection
- **♿ Accessibility**: Comprehensive accessibility features including:
  - VoiceOver support for screen readers
  - Dynamic Type support for customizable text sizes
  - Semantic grouping for better navigation
  - High contrast support
  - Reduced motion support
- **📱 Adaptive Layout**: Responsive design that adapts to different screen sizes and orientations
- **🔄 Rotation Support**: Seamless rotation between portrait and landscape orientations
- **⚡ Performance**: Optimized for smooth 60fps scrolling and animations
- **🎨 DSKit Integration**: Consistent UI components with LoadingView, ErrorView, and SectionRowView
- **🎬 Lottie Animations**: Smooth loading animations for enhanced user experience
- **🔄 Cross-Platform UI**: Shared components that adapt to iOS and tvOS with platform-specific optimizations
- **🎯 Focus Management**: tvOS-optimized focus effects and navigation for Apple TV remote control
- **🌍 English Only**: Streamlined single-language experience for optimal performance

### **Visual Design**
- **Modern UI**: Built with SwiftUI and custom DSKit components
- **Consistent Theming**: Unified design system across all screens and platforms
- **Smooth Animations**: Fluid transitions and micro-interactions with Lottie support
- **Loading States**: Elegant loading indicators with animated feedback
- **Cross-Platform Adaptation**: Platform-specific UI optimizations for iOS and tvOS

## 📺 tvOS Support & Cross-Platform Architecture

### **Universal App Architecture** 🎯
The application now supports **both iOS and tvOS** with a sophisticated cross-platform architecture that maximizes code reuse while providing platform-specific optimizations:

### **Shared Codebase Strategy** 🔄
- **Single Source of Truth**: All business logic, data models, and core functionality are shared between iOS and tvOS
- **Platform-Specific UI**: Only the presentation layer adapts to each platform's unique interaction patterns
- **Conditional Compilation**: Strategic use of `#if os(tvOS)` for platform-specific adaptations
- **Unified Testing**: Same test suites validate functionality across both platforms

### **tvOS-Specific Features** 📺
- **Focus-Based Navigation**: Optimized for Apple TV remote control interaction
- **Enhanced Visual Design**: Larger fonts, increased touch targets, and TV-optimized layouts
- **Focus Effects**: Beautiful focus animations with scaling, shadows, and color transitions
- **Remote-Friendly UI**: Simplified navigation patterns optimized for directional pad control
- **TV-Optimized Colors**: Custom color schemes that work well on large TV displays

### **Cross-Platform Components** 🧩
- **DSKit Components**: All UI components automatically adapt to tvOS with platform-specific styling
- **Shared ViewModels**: Same business logic and state management across platforms
- **Unified Data Layer**: Identical data fetching, caching, and offline strategies
- **Consistent Localization**: Same multi-language support with platform-specific string files

### **Platform Adaptations** ⚙️
- **iOS**: Touch-optimized with navigation bars, tab bars, and standard iOS patterns
- **tvOS**: Focus-optimized with custom navigation, larger UI elements, and TV-specific interactions
- **Conditional UI**: Smart adaptations like removing icons on tvOS, adjusting font sizes, and optimizing layouts
- **Color System**: Platform-specific color schemes that work optimally on each device type

### **Architecture Benefits** 🏗️
- **Code Reuse**: ~90% code sharing between platforms, reducing maintenance overhead
- **Consistent UX**: Same features and functionality across all devices
- **Independent Evolution**: Each platform can evolve its UI independently while sharing core logic
- **Unified Testing**: Single test suite validates business logic for both platforms
- **Easy Maintenance**: Changes to business logic automatically benefit both platforms

### **Technical Implementation** 🔧
- **SwiftUI Conditional Compilation**: Platform-specific UI adaptations using `#if os(tvOS)`
- **Shared SPM Packages**: All modules support both iOS and tvOS targets
- **Platform-Specific Resources**: Separate localization files and assets when needed
- **Focus Management**: tvOS-specific focus handling and navigation patterns
- **Performance Optimization**: Platform-specific performance tuning for each device type

### **Development Workflow** 👨‍💻
- **Single Codebase**: Developers work on one codebase that serves both platforms
- **Platform Testing**: Easy switching between iOS and tvOS targets for testing
- **Unified CI/CD**: Same build pipeline validates both platforms
- **Feature Parity**: New features automatically work on both platforms with appropriate UI adaptations

---

## 🏗️ Architecture Layers

```
┌─────────────────────────────────────────────────────────────┐
│                    Presentation Layer                       │
│              SwiftUI + MVVM + Design System                 │
└─────────────────────────────────────────────────────────────┘
                                │
┌─────────────────────────────────────────────────────────────┐
│                      Feature Layer                          │
│                  Sections + DetailSection                   │
└─────────────────────────────────────────────────────────────┘
                                │
┌─────────────────────────────────────────────────────────────┐
│                       Data Layer                            │
│              Repositories + Use Cases                       │
└─────────────────────────────────────────────────────────────┘
                                │
┌─────────────────────────────────────────────────────────────┐
│                   Infrastructure Layer                      │
│            Networking + Storage + Caching                   │
└─────────────────────────────────────────────────────────────┘
```

## 🛠️ Technical Stack

### **Core Technologies**
- **Platform:** iOS 17.0+ / tvOS 16.0+
- **Language:** Swift 5.9+
- **UI Framework:** SwiftUI (Cross-platform)
- **Architecture:** Clean Architecture + MVVM
- **Modularity:** Swift Package Manager (SPM)
- **Concurrency:** Swift Concurrency (async/await)
- **Testing:** XCTest + URLProtocol stubbing
- **Caching:** ETag-based offline-first strategy
- **CI/CD:** GitHub Actions + SwiftLint + Codecov
- **Cross-Platform:** Conditional compilation for iOS/tvOS

## 🛠️ Development Tools

- **SwiftLint**: Code quality and consistency enforcement
- **Xcode 15.0+**: Latest development environment
- **Git**: Version control with conventional commits
- **GitHub Actions**: Automated CI/CD pipeline
- **Codecov**: Code coverage tracking and reporting

## 🚀 App Features

### **Core Functionality**
- **Content Sections Display**: Browse content sections with rich metadata and smooth scrolling using DSKit components
- **Section Details**: Comprehensive section information with detailed navigation and enhanced UI
- **Cross-Platform Support**: Native iOS and tvOS apps with platform-optimized UI and shared business logic
- **Offline-First**: Seamless experience with ETag-based caching and smart data synchronization
- **Description Caching**: Intelligent caching system that fetches and stores section descriptions from API endpoints
- **Error Handling**: Graceful error states with user-friendly retry mechanisms using DSKit ErrorView
- **Loading States**: Smooth loading indicators with Lottie animations for enhanced user experience

### **Technical Features**
- **Modular Architecture**: Independent SPM packages for maintainability and scalability
- **Clean Architecture**: Separation of concerns with clear dependency boundaries
- **MVVM Pattern**: Reactive UI updates with proper state management
- **Cross-Platform UI**: Shared SwiftUI components with platform-specific adaptations
- **DSKit Design System**: Reusable UI components with consistent theming and animations
- **Advanced Concurrency**: Thread-safe operations with Swift Concurrency and Actor model
- **DTO/Mapper Pattern**: Robust JSON parsing with type-safe data transformation
- **Description Caching System**: Real-time fetching and caching of section descriptions from Viaplay API
- **Comprehensive Testing**: Unit tests, integration tests, and snapshot tests
- **CI/CD Integration**: Automated testing and code quality checks

## 🎨 Recent UI/UX Enhancements

### **Modern Design System**
- **Card-based Layout**: Beautiful card designs with shadows, rounded corners, and smooth animations
- **Enhanced Detail Views**: Rich information display with hero sections, statistics, and metadata
- **Interactive Components**: Touch feedback, press animations, and smooth transitions
- **Focus-Based Navigation**: tvOS-optimized focus effects with scaling and color transitions
- **Thematic Icons**: Contextual icons and colors for different content types (iOS only)
- **Gradient Backgrounds**: Modern gradient designs for visual appeal
- **Reusable DSKit Components**: Consistent LoadingView, ErrorView, and SectionRowView across all features
- **Lottie Animations**: Smooth loading animations using Lottie for enhanced user experience

### **User Experience Improvements**
- **Smooth Animations**: Entrance animations, loading states, and micro-interactions
- **Enhanced Navigation**: Intuitive navigation with visual indicators and feedback
- **Cross-Platform UX**: Optimized experiences for both touch (iOS) and remote (tvOS) interactions
- **Comprehensive Information**: Detailed content display with statistics and metadata


## ⚡ Advanced Concurrency & Thread Safety

### **Actor-Based Architecture**
- **NetworkActor**: Thread-safe network requests with request deduplication
- **StorageActor**: Concurrent storage operations with write queue management
- **CacheActor**: Thread-safe caching with controlled access patterns
- **ConcurrencyManager**: Rate limiting and controlled concurrent execution

### **Swift Concurrency Features**
- **async/await**: Modern concurrency patterns throughout the codebase
- **TaskGroup**: Parallel operations for data prefetching and optimization
- **@MainActor**: UI updates guaranteed on main thread
- **Sendable**: Thread-safe data types and protocols

### **Performance Optimizations**
- **Parallel Data Loading**: Concurrent cache and network operations
- **Prefetching**: Background loading of related content
- **Rate Limiting**: Controlled concurrent execution to prevent resource exhaustion
- **Non-blocking Operations**: UI remains responsive during data operations

## 🔄 DTO/Mapper Pattern Implementation

### **Robust JSON Parsing**
- **PageDTO**: Type-safe representation of complex API responses
- **PageMapper**: Clean transformation from DTOs to domain models
- **Type Safety**: Compile-time validation of data structures
- **Maintainability**: Easy to update when API contracts change

### **Benefits**
- **Error Prevention**: Compile-time checks prevent runtime JSON parsing errors
- **Clear Separation**: API changes don't directly affect domain models
- **Testability**: DTOs and mappers can be tested independently
- **Flexibility**: Easy to handle different API versions or formats

## 🧭 Why this architecture

This project follows **Clean Architecture** principles with **modular SPM packages** to achieve enterprise-grade maintainability and scalability. Here's why we chose this approach:

### **Maintainability** 🔧
- **Strict separation of concerns**: Each layer (domain, data, infrastructure, UI) has a single responsibility, making changes predictable and contained.
- **Reduced coupling**: Changes in one module don't cascade to others, minimizing regression risks.
- **Clear boundaries**: Domain logic is isolated from external dependencies, making the codebase easier to understand and modify.

### **Testability** 🧪
- **Pure domain logic**: Use cases and entities are framework-agnostic and trivial to unit-test with simple mocks.
- **Testable infrastructure**: HTTP clients, storage, and repositories can be easily stubbed for isolated testing.
- **Comprehensive coverage**: Each module can be tested independently, ensuring reliability across the entire system.

### **Offline-first strategy** 📱
- **Dedicated storage layer**: Enables sophisticated caching strategies (ETag/304, TTL, content versioning).
- **Resilient user experience**: App works seamlessly even with poor connectivity.
- **Future-proof**: Easy to add advanced features like background sync, conflict resolution, or delta updates.

### **Team scalability** 👥
- **Parallel development**: Independent SPM modules allow multiple developers to work simultaneously without conflicts.
- **Faster build times**: Only changed modules need to be rebuilt, significantly reducing compilation time.
- **Clear ownership**: Each team can own specific modules, reducing coordination overhead.

## 🧩 MVVM pattern (per feature)

Each feature follows the **MVVM (Model-View-ViewModel)** pattern with **Clean Architecture** principles, ensuring clear separation of concerns and testability:

### **View (SwiftUI)** 🎨
- **Responsibility**: Pure presentation layer that renders UI state and forwards user interactions.
- **What it does**: Displays data from ViewModel, handles user gestures, and triggers ViewModel actions.
- **What it doesn't do**: No direct data access, business logic, or API calls.
- **Benefits**: Highly testable, reusable, and framework-agnostic UI components.

### **ViewModel** 🧠
- **Responsibility**: Orchestrates use cases and manages UI state for a specific screen.
- **What it does**: 
  - Calls domain use cases to fetch/update data
  - Transforms domain models into UI-friendly view models
  - Manages loading states, errors, and user interactions
  - Exposes immutable state and user intents
- **Thread safety**: Uses `@MainActor` to ensure UI updates happen on the main thread.
- **Benefits**: Testable business logic, clear data flow, and separation from UI concerns.

### **UseCases (Domain)** ⚙️
- **Responsibility**: Encapsulate specific business operations (e.g., `GetRootPage`, `GetPage`).
- **What they do**: Execute single-purpose business logic, coordinate with repositories.
- **Characteristics**: Pure functions with no side effects, easy to test with mocks.
- **Benefits**: Reusable business logic, clear contracts, and framework independence.

### **Repository (Data)** 🗄️
- **Responsibility**: Implement domain contracts by orchestrating data sources.
- **What it does**: 
  - Combines remote (API) and local (cache) data sources
  - Maps DTOs to domain models and vice versa
  - Handles caching strategies (ETag, TTL, etc.)
  - Manages offline/online data synchronization
- **Benefits**: Abstract data access, testable with stubs, and flexible data strategies.


## 🧱 Modular architecture (SPM)

The application is structured as **independent Swift Package Manager (SPM) modules**, each with a specific responsibility and clear dependency boundaries:

### **Domain** 🏛️
- **Purpose**: Contains the core business logic and rules of the application.
- **Contains**: Entities (`Page`, `ContentSection`), contracts (`PageRepository`), use cases (`GetRootPage`), domain errors, and concurrency actors.
- **Dependencies**: None (pure domain logic).
- **Benefits**: Framework-agnostic, highly testable, and stable core that rarely changes.

### **Data** 📊
- **Purpose**: Orchestrates data access by implementing domain contracts.
- **Contains**: Repository implementations, DTO mappers, data coordination logic, and thread-safe operations.
- **Dependencies**: `Domain` + `NetworkingKit` + `StorageKit`.
- **Benefits**: Centralized data policies, testable with stubs, and flexible data strategies.

### **NetworkingKit** 🌐
- **Purpose**: Handles all HTTP communication and network-related concerns.
- **Contains**: `HTTPClient` protocol/implementation, endpoint helpers, and network utilities.
- **Dependencies**: None (pure infrastructure).
- **Benefits**: Swappable HTTP clients, easy testing with URLProtocol, and network abstraction.

### **StorageKit** 💾
- **Purpose**: Manages local data persistence and caching.
- **Contains**: `JSONDiskCache`, `KeyValueStore` (for ETags), and storage utilities.
- **Dependencies**: None (pure infrastructure).
- **Benefits**: Flexible storage backends, testable with temp directories, and caching strategies.

### **DSKit** 🎨
- **Purpose**: Provides reusable UI components and design system elements.
- **Contains**: SwiftUI views, view models, styling utilities, and enhanced interactive components.
- **Key Components**: 
  - `SectionRowView`: Interactive card-based section display with animations and tvOS focus support
  - `LoadingView`: Reusable loading states with content and details variants
  - `ErrorView`: Consistent error display with retry functionality
  - `LottieView`: Animated loading states using Lottie animations
  - `Colors`: Platform-adaptive color system for iOS and tvOS
- **Dependencies**: `Lottie` (for animations), `swift-snapshot-testing` (for testing).
- **Benefits**: Consistent design, reusable components, UI/UX standardization, and modern interactions.

### **Features** (Sections, DetailSection) 🚀
- **Purpose**: Implements complete user-facing features with MVVM pattern.
- **Contains**: SwiftUI views, ViewModels, feature-specific logic, and enhanced UI components.
- **Key Features**:
  - **Sections**: Modern list view with card-based design, animations, and smooth navigation using DSKit components
  - **DetailSection**: Rich detail views with comprehensive information display using DSKit LoadingView and ErrorView
- **Dependencies**: `Domain` + `DSKit`.
- **Benefits**: Independent features, clear boundaries, easy testing, and modern user experience.

### **Data Flow** 🔄
```
View → ViewModel → UseCase → Repository → HTTP/Cache → Domain → ViewModel → View
```

This unidirectional flow ensures predictable data movement and makes debugging easier.

## 🧪 Testing strategy

Our testing approach ensures **comprehensive coverage** across all modules while maintaining **fast, reliable tests**:

### **Domain** 🏛️
- **Strategy**: Unit tests for use cases with **fake repositories**.
- **What we test**: Business logic, use case execution, and domain rules.
- **Tools**: XCTest with simple mock objects.
- **Benefits**: Fast execution, no external dependencies, and pure business logic validation.

### **Data** 📊
- **Strategy**: Repository tests with **stubbed `HTTPClient`** and **temporary `JSONDiskCache`/`KeyValueStore`**.
- **What we test**: Data mapping, caching logic, ETag handling, and offline scenarios.
- **Scenarios**: 200 OK responses, 304 Not Modified, network errors, and cache fallbacks.
- **Benefits**: Isolated data layer testing with realistic network conditions.

### **NetworkingKit** 🌐
- **Strategy**: HTTP client tests using **URLProtocol** for request/response stubbing.
- **What we test**: Request formatting, header handling, response parsing, and error scenarios.
- **Tools**: Custom URLProtocol implementations for different HTTP status codes.
- **Benefits**: Network layer validation without actual network calls.

### **StorageKit** 💾
- **Strategy**: **Roundtrip tests** for JSON serialization and key-value storage in temporary directories.
- **What we test**: Data persistence, retrieval, and storage utilities.
- **Tools**: XCTest with temporary file system operations.
- **Benefits**: Storage reliability validation with clean test isolation.

### **Features/DSKit** 🚀
- **Strategy**: ViewModel tests with **fake use cases** and optional **snapshot tests** for UI.
- **What we test**: State management, user interactions, UI rendering, and concurrency behavior.
- **New Test Areas**:
  - **Actor Testing**: Thread safety and concurrent operations
  - **DTO/Mapper Testing**: Data transformation accuracy
  - **UI Component Testing**: Interactive components and animations
  - **Concurrency Testing**: Parallel operations and rate limiting
- **Tools**: XCTest for ViewModels, SwiftUI testing for UI components, async testing for concurrency.
- **Benefits**: Feature behavior validation, UI regression prevention, and thread safety verification.

### **Test Plan** 📋
- **File**: `AllTests.xctestplan` groups all test bundles for local and CI execution.
- **Benefits**: Single command to run all tests, consistent test execution across environments.

## 📈 Scalability and team workflow

This architecture is designed to **scale with your team and product requirements**:

### **Adding new features** 🚀
1. **Create new Feature package**: Implement View/ViewModel following MVVM pattern.
2. **Define domain contracts**: Add new use cases and repository interfaces in Domain.
3. **Implement data layer**: Data provides concrete implementations of domain contracts.
4. **Wire dependencies**: Inject implementations in the app's composition root.
5. **Add tests**: Each layer gets its own test suite following our testing strategy.

### **Infrastructure changes** 🔧
- **Swap HTTP client**: Change NetworkingKit implementation without touching domain or features.
- **Storage backend**: Replace StorageKit implementation (disk → database) without affecting business logic.
- **API changes**: Update Data mappers and DTOs while keeping domain models stable.

### **Team collaboration** 👥
- **Parallel development**: Multiple developers can work on different features simultaneously.
- **Clear ownership**: Each team can own specific modules (e.g., UI team owns DSKit, backend team owns Data).
- **Independent releases**: Features can be developed and tested independently.

### **CI/CD pipeline** ⚙️
- **Automated validation**: CI caches SPM/DerivedData, runs SwiftLint, and executes unit tests.
- **Quality gates**: PRs from `feature/*` and `fix/*` branches are automatically validated.
- **Fast feedback**: Only changed modules are rebuilt, reducing CI execution time.


## 🗂️ Module index

### **Base Layer**
- Domain → [Packages/Base/Domain/README.md](Packages/Base/Domain/README.md)
- Data → [Packages/Base/Data/README.md](Packages/Base/Data/README.md)

### **Feature Layer**
- Sections → [Packages/Feature/Sections/README.md](Packages/Feature/Sections/README.md)
- DetailSection → [Packages/Feature/DetailSection/README.md](Packages/Feature/DetailSection/README.md)

### **Infrastructure Layer**
- NetworkingKit → [Packages/Infraestructure/NetworkingKit/README.md](Packages/Infraestructure/NetworkingKit/README.md)
- StorageKit → [Packages/Infraestructure/StorageKit/README.md](Packages/Infraestructure/StorageKit/README.md)
- DSKit → [Packages/Infraestructure/DSKit/README.md](Packages/Infraestructure/DSKit/README.md)



### 🚀 Continuous Integration (CI) with GitHub Actions

**Goal.** Automatically validate that the project builds and passes tests before merging PRs from `feature/*` or `fix/*` branches.

**When it runs.**
- `pull_request` ➜ target `develop` (when the PR is opened/updated).
- `workflow_dispatch` ➜ manual run from the UI.

**Path filters.** Triggers on changes under `Viaplay/**` or `.swiftlint.yml` (ignores `*.md`).

**Runner.** `macos-15` with Xcode `latest-stable`.

**Environment variables.**
- `SCHEME`: `Viaplay`
- `PROJECT`: `Viaplay/Viaplay.xcodeproj`
- `DESTINATION`: `platform=iOS Simulator,name=iPhone 16 Pro,OS=latest`

**What the workflow does.**
1. Checks out the repository.
2. Selects the latest stable Xcode.
3. Caches SPM/DerivedData to speed up builds.
4. Installs SwiftLint and runs it with `--strict` in `Viaplay`.
5. Builds and runs unit tests for both iOS and tvOS targets with code coverage and `-skipMacroValidation`.
6. Uploads the `.xcresult` as an artifact even on failure.

**File.** `.github/workflows/ci.yml`

**Badge (optional).** Add to the README:
```md
![iOS CI](https://github.com/<org>/<repo>/actions/workflows/ci.yml/badge.svg)
```

**Quick local run.**
```bash
# iOS
xcodebuild \
  -project Viaplay/Viaplay.xcodeproj \
  -scheme Viaplay \
  -destination 'platform=iOS Simulator,name=iPhone 16 Pro,OS=latest' \
  clean test

# tvOS
xcodebuild \
  -project Viaplay/Viaplay.xcodeproj \
  -scheme ViaplaytvOS \
  -destination 'platform=tvOS Simulator,name=Apple TV 4K (3rd generation),OS=latest' \
  clean test
```

—

### 🧹 Linting with SwiftLint

**Goal.** Align code with style and best practices; catch issues early and keep PRs clean.

**Local install.**
```bash
brew install swiftlint
swiftlint version
```

**File.** `.swiftlint.yml`

**Scope.**
- `included`: `Viaplay`
- `excluded`: `Carthage`, `Pods`, `DerivedData`, `ViaplayTests`, `*.generated.swift`, `*.pb.swift`

**Disabled rules.** `trailing_whitespace`, `todo`, `identifier_name`.

**Opt‑in rules (selection).** `sorted_imports`, `force_unwrapping`, `implicit_return`, `switch_case_on_newline`, `collection_alignment`, `modifier_order`, `vertical_whitespace_*`.

**Limits and metrics.**
- `line_length` 120/160 (ignores URLs/signatures/comments)
- `type_body_length` 300/400
- `function_body_length` 50/100
- `function_parameter_count` 5/8
- `cyclomatic_complexity` 10/20
- `nesting` type 3/6 · statements 5/10

**Conventions.**
- Names: tuned `identifier_name`; exceptions `id`, `URL`, `GlobalAPIKey`.
- Types: `type_name` min/max lengths.
- Header: enforced `file_header.required_pattern` for project `.swift` files.
- Reporter: `xcode` for readable output in local/CI.

**How to run.**
- Local: from the repo root
```bash
swiftlint --strict
```
- CI: dedicated step in the workflow (see CI section).

**Xcode integration (Run Script).** Add a phase before `Compile Sources`:
```bash
if which swiftlint >/dev/null; then
  swiftlint
else
  echo "warning: SwiftLint not installed. Run 'brew install swiftlint'"
fi
```

```
