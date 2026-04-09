# menubar-translator

A native macOS local translator focused on speed and low-friction workflows.

## Product Direction

The first version is optimized for three interaction modes:

- **B. Menu bar resident app**
- **C. Global shortcut + floating result panel**
- **D. Clipboard-assisted fallback**

In one sentence:

> Select to translate, shortcut to trigger, clipboard as fallback.

## Why this shape

This is not intended to be a heavy window-based translator.
It is meant to feel like a lightweight macOS capability:

- always available
- low interruption
- fast access from any app
- local-first inference

## V1 Scope

### Core flows

1. Manual translation from menu bar popover
2. Global shortcut translation
3. Clipboard translation fallback
4. Floating panel result display

### Not in V1

- voice-first workflow
- OCR
- terminology management
- conversation mode
- automatic clipboard translation
- complex history system

## Bootstrap

This repository currently uses a lightweight native macOS skeleton plus an `XcodeGen` spec.

### Generate the Xcode project on macOS

```bash
brew install xcodegen
xcodegen generate
open MenubarTranslator.xcodeproj
```

### Current status

- native macOS skeleton initialized
- menu bar / floating panel / translation abstractions scaffolded
- week-1 MVP issues created in GitHub
- local inference is still a follow-up spike, not wired yet

## Docs

- [Product](docs/product.md)
- [Tech](docs/tech.md)
- [Roadmap](docs/roadmap.md)

## Initial Milestone

**MVP - macOS Native Local Translator**

Goal for the first week:

- menu bar app works
- global shortcut works
- clipboard text can be translated
- floating panel can show results
- local inference path has a working spike
