# DSKit

## Overview
Design System Kit providing reusable UI components and styling utilities for consistent user interface across the application. This module ensures visual consistency and provides a centralized design system.

## Responsibilities
- **UI Components**: Reusable SwiftUI components for consistent design
- **Styling**: Centralized colors, fonts, spacing, and visual styles
- **Design Tokens**: Standardized design values and themes
- **Accessibility**: Built-in accessibility support for all components

## Architecture
```
DSKit
├── Components/
│   └── SectionRowView.swift        # Reusable section row component
├── Styles/
│   └── DesignTokens.swift          # Colors, fonts, spacing (planned)
└── Tests/
    └── SectionRowViewTests.swift   # Component tests
```

## Dependencies
None (pure UI components). This keeps the design system independent and reusable.

## Key Components

### SectionRowView
Reusable component for displaying content sections:
```swift
struct SectionRowView: View {
    let title: String
    let description: String?
    let onTap: () -> Void
    
    var body: some View {
        // Consistent section row design
        // Accessibility support
        // Touch interactions
    }
}
```

## Design Principles
- **Consistency**: All components follow the same design language
- **Reusability**: Components are generic and configurable
- **Accessibility**: Built-in VoiceOver and Dynamic Type support
- **Performance**: Lightweight components with minimal overhead

## Usage
Import DSKit in your feature modules:
```swift
import DSKit

struct MyView: View {
    var body: some View {
        SectionRowView(
            title: "My Section",
            description: "Section description",
            onTap: { /* handle tap */ }
        )
    }
}
```

## Testing
- **Component Tests**: Test UI rendering and user interactions
- **Accessibility Tests**: Verify VoiceOver and Dynamic Type support
- **Snapshot Tests**: Visual regression testing for design consistency

## Directory Layout
- `Sources/DSKit/SectionRowView.swift` - Main UI component
- `Tests/DSKitTests/SectionRowViewTests.swift` - Component tests
