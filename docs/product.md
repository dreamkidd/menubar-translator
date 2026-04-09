# Product

## One-line definition

A native macOS local translator that stays in the menu bar and lets users translate with a shortcut, using selected text when possible and clipboard as fallback.

## Product shape

The product is built around three modes:

### B. Menu bar resident app
Used for:
- manual input
- quick retries
- language direction switch
- opening settings

### C. Global shortcut + floating panel
Used for:
- translating text from the current workflow
- showing results without switching apps
- keeping the interaction lightweight

### D. Clipboard-assisted fallback
Used for:
- compatibility across apps
- stable MVP behavior
- graceful degradation when selected text access is unavailable

## Core scenarios

### Scenario 1: understand foreign text
- user reads text in browser / notes / chat
- user triggers translation
- result appears in a floating panel

### Scenario 2: translate outgoing text
- user copies or selects text they wrote
- user triggers translation
- result appears and can be copied back immediately

### Scenario 3: quick manual query
- user opens the menu bar popover
- types a short phrase
- gets translation instantly

## V1 scope

### Must-have
- menu bar entry
- global shortcut
- clipboard translation
- floating result panel
- local translation engine abstraction
- native macOS stack

### Should-have
- selection-based translation if accessibility path is stable
- settings window
- basic engine/model status

### Not now
- voice-first UX
- OCR / screenshot translation
- terminology library
- auto clipboard monitoring
- heavy main window workspace

## UX principles

- low interruption
- one main shortcut
- minimal UI chrome
- fast result delivery
- clear fallback behavior

## Fallback order

1. selected text
2. clipboard text
3. manual input prompt / menu bar input
