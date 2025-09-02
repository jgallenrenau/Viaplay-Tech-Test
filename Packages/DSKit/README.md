# DSKit

## Overview
Design system and reusable SwiftUI components.

## Responsibilities
- Provide consistent UI primitives (colors/typography to be added)
- Reusable components used across features (e.g., `SectionRowView`)

## Directory layout
- `Sources/DSKit/SectionRowView.swift`

## Usage
```swift
SectionRowView(section: Section(title: "…", description: "…", href: nil))
```

## Testing
Prefer snapshot tests; for now, construction tests ensure views build.
