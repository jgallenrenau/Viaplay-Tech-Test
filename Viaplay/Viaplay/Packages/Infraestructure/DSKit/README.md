# DSKit

## Overview
Design System Kit providing reusable UI components and styling utilities for consistent user interface across the application. This module ensures visual consistency and provides a centralized design system.

## Responsibilities
- **UI Components**: Reusable SwiftUI components for consistent design
- **Styling**: Centralized colors, fonts, spacing, and visual styles
- **Design Tokens**: Standardized design values and themes
- **Accessibility**: Built-in accessibility support for all components
- **Cross-Platform Support**: iOS and tvOS optimized components
- **Animations**: Lottie animations and smooth transitions

## Architecture
```
DSKit
├── Components/
│   ├── SectionRowView.swift        # Unified section row component (iOS/tvOS)
│   ├── LoadingView.swift           # Loading states with Lottie animations
│   ├── ErrorView.swift             # Error states with retry functionality
│   ├── SplashView.swift            # App launch screen with Marvel-like animation
│   └── DesignSystem.swift          # Component factory and design system entry point
├── Foundations/
│   ├── DSPalette.swift             # Color system
│   ├── DSSpacing.swift             # Spacing system
│   └── DSTypography.swift          # Typography system
├── Resources/
│   ├── Colors.xcassets/            # Color assets
│   ├── Media.xcassets/             # Media assets
│   └── Animations/                 # Lottie animation files
└── Tests/
    └── DSKitTests/                 # Component and snapshot tests
```

## Dependencies
- **Lottie**: For smooth animations and loading states
- **SnapshotTesting**: For visual regression testing

## Key Components

### SectionRowView
Unified component for displaying content sections across iOS and tvOS:
```swift
public struct SectionRowView: View {
    public struct Model: Equatable, Hashable {
        public let title: String
        public let description: String?
    }
    
    private let model: Model
    private let onTap: (() -> Void)?
    
    public init(model: Model, onTap: (() -> Void)? = nil)
    
    public var body: some View {
        // Platform-adaptive design
        // iOS: Touch-optimized with icons
        // tvOS: Focus-optimized with focus ring
        // Accessibility support
        // Smooth animations
    }
}
```

### LoadingView
Elegant loading states with Lottie animations:
```swift
public struct LoadingView: View {
    public init()
    public var body: some View {
        // Lottie animation
        // Content loading variant
        // Smooth transitions
    }
}
```

### ErrorView
Consistent error states with retry functionality:
```swift
public struct ErrorView: View {
    public init(title: String, message: String, retryAction: @escaping () -> Void)
    public var body: some View {
        // Error display
        // Retry button
        // Consistent styling
    }
}
```

### SplashView
App launch screen with Marvel-like animation:
```swift
public struct SplashView: View {
    public init(onAnimationEnd: @escaping () -> Void)
    public var body: some View {
        // Marvel-like grow and pulse animation
        // App icon display
        // Smooth transitions
    }
}
```

## Design Principles
- **Consistency**: All components follow the same design language
- **Reusability**: Components are generic and configurable
- **Accessibility**: Built-in VoiceOver and Dynamic Type support
- **Performance**: Lightweight components with minimal overhead
- **Cross-Platform**: Single component codebase for iOS and tvOS
- **Modern UI**: SwiftUI-based with smooth animations and transitions

## Usage
Import DSKit in your feature modules:
```swift
import DSKit

struct MyView: View {
    var body: some View {
        VStack {
            // Using SectionRowView
            SectionRowView(
                model: SectionRowView.Model(
                    title: "My Section",
                    description: "Section description"
                ),
                onTap: { /* handle tap */ }
            )
            
            // Using LoadingView
            LoadingView()
            
            // Using ErrorView
            ErrorView(
                title: "Error",
                message: "Something went wrong",
                retryAction: { /* retry */ }
            )
            
            // Using SplashView
            SplashView(onAnimationEnd: { /* navigate */ })
        }
    }
}
```

## Testing
- **Component Tests**: Test UI rendering and user interactions
- **Accessibility Tests**: Verify VoiceOver and Dynamic Type support
- **Snapshot Tests**: Visual regression testing for design consistency

## Directory Layout
- `Sources/DSKit/Components/` - All UI components
- `Sources/DSKit/Foundations/` - Design system foundations
- `Sources/DSKit/Resources/` - Assets and resources
- `Tests/DSKitTests/` - Component and snapshot tests
