<div align="center">
  <img src="DocResources/viaplay_image_header.jpeg" alt="Viaplay Tech Test" width="800"/>
</div>

<div align="center">

# Viaplay Tech Test

[![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)](https://swift.org)
[![Xcode](https://img.shields.io/badge/Xcode-15.0-blue.svg)](https://developer.apple.com/xcode/)
[![License](https://img.shields.io/badge/License-MIT-orange.svg)](LICENSE)
[![iOS](https://img.shields.io/badge/iOS-17.0+-lightgrey.svg)](https://developer.apple.com/ios/)
[![codecov](https://codecov.io/gh/jordigallenrenau/Viaplay-Tech-Test/branch/main/graph/badge.svg)](https://codecov.io/gh/jordigallenrenau/Viaplay-Tech-Test)
</div>

## Overview

The Viaplay Tech Test is a Swift-based iOS application that demonstrates modern iOS development practices through a modular architecture built with Swift Package Manager (SPM). This project showcases a content browsing experience with sections and detailed views, leveraging Clean Architecture principles, MVVM pattern, and an offline-first strategy with ETag-based caching. The application is structured as independent SPM modules, each with specific responsibilities and clear dependency boundaries, ensuring maintainability, testability, and team scalability. This project serves as a technical assessment demonstrating enterprise-grade iOS development practices, including comprehensive testing strategies, CI/CD integration, and SOLID principles implementation.

## 📋 Table of Contents

- [🧭 Why this architecture](#-why-this-architecture)
- [🧩 MVVM pattern (per feature)](#-mvvm-pattern-per-feature)
- [📦 SPM Architecture Decision: Internal vs External Dependencies](#-spm-architecture-decision-internal-vs-external-dependencies)
- [🧱 Modular architecture (SPM)](#-modular-architecture-spm)
- [🧪 Testing strategy](#-testing-strategy)
- [📈 Scalability and team workflow](#-scalability-and-team-workflow)
- [🧠 SOLID applied](#-solid-applied)
- [🗂️ Module index](#️-module-index)
- [🏗️ Architecture overview](#️-architecture-overview)
- [🚀 Continuous Integration (CI) with GitHub Actions](#-continuous-integration-ci-with-github-actions)
- [🧹 Linting with SwiftLint](#-linting-with-swiftlint)

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
- **Platform:** iOS 17.0+
- **Language:** Swift 5.9+
- **UI Framework:** SwiftUI
- **Architecture:** Clean Architecture + MVVM
- **Modularity:** Swift Package Manager (SPM)
- **Concurrency:** Swift Concurrency (async/await)
- **Testing:** XCTest + URLProtocol stubbing
- **Caching:** ETag-based offline-first strategy
- **CI/CD:** GitHub Actions + SwiftLint + Codecov

## 🛠️ Development Tools

- **SwiftLint**: Code quality and consistency enforcement
- **Xcode 15.0+**: Latest development environment
- **Git**: Version control with conventional commits
- **GitHub Actions**: Automated CI/CD pipeline
- **Codecov**: Code coverage tracking and reporting

## 📱 Features

### **Core Functionality**
- **Content Sections Display**: Browse content sections with rich metadata
- **Section Details**: Comprehensive section information and navigation
- **Offline-First**: Seamless experience with ETag-based caching
- **Error Handling**: Graceful error states with retry mechanisms
- **Loading States**: Smooth loading indicators and state management

### **Advanced Features**
- **Accessibility**: VoiceOver support, Dynamic Type, and semantic grouping
- **Performance**: Efficient list rendering, optimized data fetching, and state management
- **Modern UI**: Custom design system built with SwiftUI and DSKit
- **Modular Architecture**: Independent SPM packages for maintainability
- **Comprehensive Testing**: Unit tests, integration tests, and test plans

## 🚀 Getting Started

### **Prerequisites**
- `Xcode 15.0+`
- `Swift 5.9+`
- `iOS 17.0+`
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
xcodebuild test \
  -project Viaplay/Viaplay.xcodeproj \
  -scheme Viaplay \
  -destination 'platform=iOS Simulator,name=iPhone 16 Pro,OS=latest'
```

**4. Run SwiftLint:**
```bash
swiftlint --strict
```

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

## 📦 SPM Architecture Decision: Internal vs External Dependencies

### **Decision: SPM as Internal Targets**

We chose to implement SPM modules as **internal targets** within the main Xcode project rather than external dependencies. Here's the rationale:

### **✅ Advantages of Internal SPM Targets**

**Development Experience:**
- **Test Plans**: All test targets appear automatically in Xcode Test Navigator
- **Debugging**: Seamless debugging across modules with breakpoints
- **IntelliSense**: Perfect autocompletion and navigation between modules
- **Build Performance**: Faster incremental builds and development cycles

**Tech Test Benefits:**
- **Demonstration**: Easy to show comprehensive testing strategies
- **Evaluation**: Evaluators can quickly run and review all tests
- **Maintainability**: Clear module separation without complexity overhead

### **❌ Trade-offs Considered**

**External SPM Dependencies would provide:**
- **True Modularity**: Complete independence between packages
- **Reusability**: Packages could be used in other projects
- **Versioning**: Independent versioning per module
- **Team Scalability**: Better for large distributed teams

**Why we chose Internal for this Tech Test:**
- **Scope**: Single-project demonstration of architectural principles
- **Time Constraints**: Faster development and testing cycles
- **Evaluation Focus**: Emphasis on code quality over distribution complexity
- **Learning**: Clear demonstration of Clean Architecture without tooling overhead

### **🏗️ Architecture Benefits Maintained**

Even with internal targets, we maintain:
- **Separation of Concerns**: Each module has single responsibility
- **Dependency Inversion**: Clear dependency flow (Features → Domain ← Data)
- **Testability**: Isolated testing with dependency injection
- **SOLID Principles**: All principles applied within modular structure

### **🔄 Future Migration Path**

If this project were to scale to a production environment with multiple teams, the migration path to external SPM dependencies would be straightforward:

1. **Extract Packages**: Move each internal target to separate `Package.swift` files
2. **Update Dependencies**: Modify project to reference local package dependencies
3. **CI/CD Updates**: Update build scripts to handle individual package testing
4. **Team Structure**: Assign ownership of packages to different teams

The current architecture makes this migration path clear and maintainable.

## 🧱 Modular architecture (SPM)

The application is structured as **independent Swift Package Manager (SPM) modules**, each with a specific responsibility and clear dependency boundaries:

### **Domain** 🏛️
- **Purpose**: Contains the core business logic and rules of the application.
- **Contains**: Entities (`Page`, `ContentSection`), contracts (`PageRepository`), use cases (`GetRootPage`), and domain errors.
- **Dependencies**: None (pure domain logic).
- **Benefits**: Framework-agnostic, highly testable, and stable core that rarely changes.

### **Data** 📊
- **Purpose**: Orchestrates data access by implementing domain contracts.
- **Contains**: Repository implementations, DTO mappers, and data coordination logic.
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
- **Contains**: SwiftUI views, view models, and styling utilities.
- **Dependencies**: None (pure UI components).
- **Benefits**: Consistent design, reusable components, and UI/UX standardization.

### **Features** (Sections, DetailSection) 🚀
- **Purpose**: Implements complete user-facing features with MVVM pattern.
- **Contains**: SwiftUI views, ViewModels, and feature-specific logic.
- **Dependencies**: `Domain` + `DSKit` (optional).
- **Benefits**: Independent features, clear boundaries, and easy testing.

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
- **What we test**: State management, user interactions, and UI rendering.
- **Tools**: XCTest for ViewModels, SwiftUI testing for UI components.
- **Benefits**: Feature behavior validation and UI regression prevention.

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

## 🧠 SOLID applied

Our architecture strictly follows **SOLID principles** to ensure maintainable and extensible code:

### **S - Single Responsibility Principle** 🎯
- **Each module has one reason to change**: Domain handles business logic, NetworkingKit handles HTTP, StorageKit handles persistence.
- **Each class has one responsibility**: `GetRootPageUseCase` only fetches root page, `HTTPClient` only makes HTTP requests.
- **Benefits**: Easier testing, debugging, and maintenance.

### **O - Open/Closed Principle** 🔓
- **Open for extension, closed for modification**: New features extend via new SPM packages without modifying existing code.
- **Protocol-based design**: New data sources implement existing protocols (`PageRepository`, `HTTPClient`).
- **Benefits**: Backward compatibility and easy feature additions.

### **L - Liskov Substitution Principle** 🔄
- **Subtypes are substitutable**: Fake repositories and stubs implement the same contracts as real implementations.
- **Test doubles work seamlessly**: Mock `HTTPClient` behaves exactly like real `HTTPClient`.
- **Benefits**: Reliable testing and flexible implementations.

### **I - Interface Segregation Principle** 🎭
- **Small, focused protocols**: `PageRepository`, `HTTPClient`, `JSONDiskCache` have minimal, specific interfaces.
- **No fat interfaces**: Clients only depend on methods they actually use.
- **Benefits**: Reduced coupling and easier implementation.

### **D - Dependency Inversion Principle** ⬆️
- **Depend on abstractions, not concretions**: Features depend on domain protocols, not concrete implementations.
- **Infrastructure depends on domain**: Data implements domain contracts, not the other way around.
- **Benefits**: Flexible architecture and easy testing with mocks.

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

## 🏗️ Architecture overview

- **Clean Architecture + MVVM** in modular SPM packages.
- **Flow**: `View (SwiftUI) → ViewModel → UseCase (Domain) → Repository (Data) → Data Sources (NetworkingKit + StorageKit)`.
- **Offline-first** with ETag/304: when the server indicates Not Modified we return the **cache**.
- **DSKit** is UI only; features translate domain models to view models.

### Why this design (rationale per layer)

- **Domain (Why?)**: Keep the business core stable, portable, and easy to test. No dependency on Apple frameworks.
  - Defines entities (`Page`, `ContentSection`), contracts (`PageRepository`), and use cases (`GetRootPage`).
- **Data (Why?)**: Orchestrate policies (ETag, mappings, future expiration) separated from domain. API or cache changes don't impact UI or use cases.
  - Implements `PageRepository` combining remote and local; maps DTO ↔ domain.
- **NetworkingKit (Why?)**: Abstract HTTP to enable stubbing/testing and replace client or strategy without touching repos/use cases.
  - Provides `HTTPClient` and endpoint helpers.
- **StorageKit (Why?)**: Encapsulate persistence (JSON/KeyValue) and allow switching from disk to database without affecting Data.
  - `JSONDiskCache`, `KeyValueStore` (ETag/Last-Modified).
- **DSKit (Why?)**: Independent reusable UI; facilitates visual consistency and avoids coupling UI to domain types.
  - SwiftUI components that receive simple models.
- **Features (Why?)**: Move presentation logic (MVVM) out of the root app and allow screen evolution without touching infrastructure.
  - View + ViewModel dependent on domain; dependency injection in the composition root.

### Online/Offline flow

1) View requests data via ViewModel → UseCase (`GetRootPage`).
2) Repository (`Data`) prepares conditional headers (`If-None-Match` with ETag stored in `StorageKit`).
3) `NetworkingKit` makes the GET:
   - **200 OK (online, new content)**: Data decodes JSON → maps to domain → saves ETag and JSON in `StorageKit` → returns to ViewModel.
   - **304 Not Modified (logical offline / no changes)**: Data reads cached JSON from `StorageKit` and returns it.
   - **Network error (real offline)**: Data attempts fallback to cached JSON; if it exists, returns it, if not, propagates error.
4) ViewModel adapts to view models (for DSKit) and updates the UI.


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
5. Builds and runs unit tests (only `ViaplayTests`) with code coverage and `-skipMacroValidation`.
6. Uploads the `.xcresult` as an artifact even on failure.

**File.** `.github/workflows/ci.yml`

**Badge (optional).** Add to the README:
```md
![iOS CI](https://github.com/<org>/<repo>/actions/workflows/ci.yml/badge.svg)
```

**Quick local run.**
```bash
xcodebuild \
  -project Viaplay/Viaplay.xcodeproj \
  -scheme Viaplay \
  -destination 'platform=iOS Simulator,name=iPhone 16 Pro,OS=latest' \
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
