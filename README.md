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

## 🏗️ Architecture Layers

```
┌─────────────────────────────────────────────────────────────┐
│                    Presentation Layer                       │
│              SwiftUI + MVVM + Design System                │
└─────────────────────────────────────────────────────────────┘
                                │
┌─────────────────────────────────────────────────────────────┐
│                      Feature Layer                          │
│           SectionsFeature + DetailFeature                   │
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

## 📋 Table of Contents

- [🧭 Why this architecture](#-why-this-architecture)
- [🧩 MVVM pattern (per feature)](#-mvvm-pattern-per-feature)
- [🧱 Modular architecture (SPM)](#-modular-architecture-spm)
- [🧪 Testing strategy](#-testing-strategy)
- [📈 Scalability and team workflow](#-scalability-and-team-workflow)
- [🧠 SOLID applied](#-solid-applied)
- [🗂️ Module index](#️-module-index)
- [🏗️ Architecture overview](#️-architecture-overview)
- [🚀 Continuous Integration (CI) with GitHub Actions](#-continuous-integration-ci-with-github-actions)
- [🧹 Linting with SwiftLint](#-linting-with-swiftlint)

---

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

### **Repository (DataKit)** 🗄️
- **Responsibility**: Implement domain contracts by orchestrating data sources.
- **What it does**: 
  - Combines remote (API) and local (cache) data sources
  - Maps DTOs to domain models and vice versa
  - Handles caching strategies (ETag, TTL, etc.)
  - Manages offline/online data synchronization
- **Benefits**: Abstract data access, testable with stubs, and flexible data strategies.

## 🧱 Modular architecture (SPM)

The application is structured as **independent Swift Package Manager (SPM) modules**, each with a specific responsibility and clear dependency boundaries:

### **DomainKit** 🏛️
- **Purpose**: Contains the core business logic and rules of the application.
- **Contains**: Entities (`Page`, `ContentSection`), contracts (`PageRepository`), use cases (`GetRootPage`), and domain errors.
- **Dependencies**: None (pure domain logic).
- **Benefits**: Framework-agnostic, highly testable, and stable core that rarely changes.

### **DataKit** 📊
- **Purpose**: Orchestrates data access by implementing domain contracts.
- **Contains**: Repository implementations, DTO mappers, and data coordination logic.
- **Dependencies**: `DomainKit` + `NetworkingKit` + `StorageKit`.
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

### **Features** (SectionsFeature, DetailFeature) 🚀
- **Purpose**: Implements complete user-facing features with MVVM pattern.
- **Contains**: SwiftUI views, ViewModels, and feature-specific logic.
- **Dependencies**: `DomainKit` + `DSKit` (optional).
- **Benefits**: Independent features, clear boundaries, and easy testing.

### **Data Flow** 🔄
```
View → ViewModel → UseCase → Repository → HTTP/Cache → Domain → ViewModel → View
```

This unidirectional flow ensures predictable data movement and makes debugging easier.

## 🧪 Testing strategy

Our testing approach ensures **comprehensive coverage** across all modules while maintaining **fast, reliable tests**:

### **DomainKit** 🏛️
- **Strategy**: Unit tests for use cases with **fake repositories**.
- **What we test**: Business logic, use case execution, and domain rules.
- **Tools**: XCTest with simple mock objects.
- **Benefits**: Fast execution, no external dependencies, and pure business logic validation.

### **DataKit** 📊
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
2. **Define domain contracts**: Add new use cases and repository interfaces in DomainKit.
3. **Implement data layer**: DataKit provides concrete implementations of domain contracts.
4. **Wire dependencies**: Inject implementations in the app's composition root.
5. **Add tests**: Each layer gets its own test suite following our testing strategy.

### **Infrastructure changes** 🔧
- **Swap HTTP client**: Change NetworkingKit implementation without touching domain or features.
- **Storage backend**: Replace StorageKit implementation (disk → database) without affecting business logic.
- **API changes**: Update DataKit mappers and DTOs while keeping domain models stable.

### **Team collaboration** 👥
- **Parallel development**: Multiple developers can work on different features simultaneously.
- **Clear ownership**: Each team can own specific modules (e.g., UI team owns DSKit, backend team owns DataKit).
- **Independent releases**: Features can be developed and tested independently.

### **CI/CD pipeline** ⚙️
- **Automated validation**: CI caches SPM/DerivedData, runs SwiftLint, and executes unit tests.
- **Quality gates**: PRs from `feature/*` and `fix/*` branches are automatically validated.
- **Fast feedback**: Only changed modules are rebuilt, reducing CI execution time.

## 🧠 SOLID applied

Our architecture strictly follows **SOLID principles** to ensure maintainable and extensible code:

### **S - Single Responsibility Principle** 🎯
- **Each module has one reason to change**: DomainKit handles business logic, NetworkingKit handles HTTP, StorageKit handles persistence.
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
- **Infrastructure depends on domain**: DataKit implements domain contracts, not the other way around.
- **Benefits**: Flexible architecture and easy testing with mocks.

## 🗂️ Module index

- DomainKit → [Packages/DomainKit/README.md](Packages/DomainKit/README.md)
- DataKit → [Packages/DataKit/README.md](Packages/DataKit/README.md)
- NetworkingKit → [Packages/NetworkingKit/README.md](Packages/NetworkingKit/README.md)
- StorageKit → [Packages/StorageKit/README.md](Packages/StorageKit/README.md)
- DSKit → [Packages/DSKit/README.md](Packages/DSKit/README.md)
- SectionsFeature → [Packages/SectionsFeature/README.md](Packages/SectionsFeature/README.md)
- DetailFeature → [Packages/DetailFeature/README.md](Packages/DetailFeature/README.md)

## 🏗️ Architecture overview

- **Clean Architecture + MVVM** in modular SPM packages.
- **Flow**: `View (SwiftUI) → ViewModel → UseCase (Domain) → Repository (DataKit) → Data Sources (NetworkingKit + StorageKit)`.
- **Offline-first** con ETag/304: cuando el servidor indica Not Modified devolvemos el **cache**.
- **DSKit** es solo UI; las features traducen modelos de dominio a modelos de vista.

### Why this design (rationale per layer)

- **DomainKit (Why?)**: mantener el corazón de negocio estable, portable y fácil de testear. No depende de Apple frameworks.
  - Define entidades (`Page`, `ContentSection`), contratos (`PageRepository`) y casos de uso (`GetRootPage`).
- **DataKit (Why?)**: orquestar políticas (ETag, mapeos, expiración futura) separadas del dominio. Cambios de API o caché no impactan en UI ni casos de uso.
  - Implementa `PageRepository` combinando remoto y local; mapea DTO ↔ dominio.
- **NetworkingKit (Why?)**: abstraer HTTP para poder stubear/testear y sustituir cliente o estrategia sin tocar repos/uso de casos.
  - Provee `HTTPClient` y helpers de endpoints.
- **StorageKit (Why?)**: encapsular persistencia (JSON/KeyValue) y permitir cambiar de disco a base de datos sin afectar a DataKit.
  - `JSONDiskCache`, `KeyValueStore` (ETag/Last-Modified).
- **DSKit (Why?)**: UI reusable independiente; facilita consistencia visual y evita acoplar UI a tipos de dominio.
  - Componentes SwiftUI que reciben modelos simples.
- **Features (Why?)**: mover la lógica de presentación (MVVM) fuera de la app raíz y permitir evolucionar pantallas sin tocar infra.
  - View + ViewModel dependientes del dominio; inyección de dependencias en el composition root.

### Online/Offline flow

1) View solicita datos vía ViewModel → UseCase (`GetRootPage`).
2) Repository (`DataKit`) prepara cabeceras condicionales (`If-None-Match` con ETag almacenado en `StorageKit`).
3) `NetworkingKit` hace el GET:
   - **200 OK (online, contenido nuevo)**: DataKit decodifica JSON → mapea a dominio → guarda ETag y JSON en `StorageKit` → devuelve al ViewModel.
   - **304 Not Modified (offline lógico / sin cambios)**: DataKit lee el JSON cacheado desde `StorageKit` y lo devuelve.
   - **Error de red (offline real)**: DataKit intenta fallback al JSON cacheado; si existe, lo devuelve, si no, propaga error.
4) ViewModel adapta a modelos de vista (para DSKit) y actualiza la UI.


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
