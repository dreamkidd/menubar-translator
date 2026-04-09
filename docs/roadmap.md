# Roadmap

## Milestone

### MVP - macOS Native Local Translator

Goal:
Ship a usable local translator prototype with menu bar entry, shortcut trigger, clipboard fallback, and floating result display.

---

## Week 1

### Target outcome
A demoable MVP shell that can:
- live in the menu bar
- respond to a global shortcut
- read clipboard text
- run a translation flow
- show the result in a floating panel

### First-week issue set

1. Initialize macOS app skeleton and module layout
2. Define core models and translation engine abstraction
3. Build menu bar popover for manual translation
4. Implement global shortcut registration and trigger coordinator
5. Implement clipboard text reader and sanitization
6. Build floating result panel for quick translation output
7. Create local inference spike (or temporary real-engine bridge)
8. Integrate clipboard → translation engine → floating panel end-to-end flow

---

## Week 2

Focus:
- selected text retrieval research and implementation
- accessibility permission handling
- local inference integration hardening
- basic settings window

---

## Week 3+

Possible next steps:
- model lifecycle management
- recent history
- language direction presets
- voice input as an auxiliary feature
- OCR / screenshot translation

---

## Product constraints

Things intentionally deferred:
- heavy main window workflow
- chat-style UX
- automatic clipboard translation
- terminology management
- complex multi-step assistant behavior
