# Tech

## Current technical direction

### App stack
- **Native macOS app**
- **SwiftUI** for primary UI
- **AppKit bridge** where native macOS capability is needed

### Why native first
The product depends heavily on macOS-native interaction patterns:
- menu bar presence
- global shortcut handling
- floating panels
- accessibility-based selected text access
- low-friction system integration

A cross-platform shell is intentionally not the first choice for V1.

## Core modules

### 1. App Shell
Responsible for:
- app lifecycle
- menu bar app bootstrap
- settings window routing

### 2. Menu Bar Feature
Responsible for:
- status item
- popover
- manual input flow
- lightweight result display

### 3. Trigger Layer
Responsible for:
- global shortcut registration
- deciding translation source
- coordinating selection / clipboard / manual fallback

### 4. Text Source Layer
Responsible for:
- selected text retrieval
- clipboard reading
- input sanitization

### 5. Translation Layer
Responsible for:
- `TranslationRequest`
- `TranslationResult`
- `TranslationEngine` abstraction
- caching repeated requests

### 6. Presentation Layer
Responsible for:
- floating result panel
- copy / close actions
- non-intrusive display

### 7. Model / Inference Layer
Responsible for:
- local inference spike
- model presence / readiness checks
- future model management

## Suggested directory layout

```text
menubar-translator/
├── README.md
├── docs/
│   ├── product.md
│   ├── tech.md
│   └── roadmap.md
└── app/
    ├── Features/
    │   ├── MenuBar/
    │   └── FloatingPanel/
    └── Services/
        ├── Translation/
        ├── Hotkey/
        ├── TextSource/
        └── Model/
```

## Translation engine abstraction

The UI must depend on an abstraction, not on a concrete inference backend.

Suggested interface shape:

```swift
protocol TranslationEngine {
    func translate(_ request: TranslationRequest) async throws -> TranslationResult
}
```

## First implementation order

1. mock translation engine
2. local inference spike
3. local engine adapter

## First-week technical goal

Build a working path for:

- clipboard text
- shortcut trigger
- translation request
- result floating panel

Selection-based translation is important, but should not block the first usable MVP.
