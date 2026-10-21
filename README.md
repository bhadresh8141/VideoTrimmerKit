# VideoTrimmerKit

![CI](https://github.com/bhadresh8141/VideoTrimmerKit/actions/workflows/ci.yml/badge.svg)

A small Swift package for trimming videos on iOS: trim range, thumbnail strip,
async export (coming) and a SwiftUI trimming view (coming).

## What it shows
- Value types (`struct`) for safe, predictable state — `TrimRange`
- Copy-on-write done by hand with `isKnownUniquelyReferenced` — `ThumbnailStrip`
- Generics with constraints and conditional `Sendable` — `MemoryCache<Key, Value>`
- Swift 6 language mode, Swift Testing, GitHub Actions CI

## Architecture
```
VideoTrimmerKit
├── TrimRange        (struct: start/end, clamped, handles can't cross)
├── ThumbnailStrip   (struct + private class Storage = copy-on-write)
└── Cache/
    └── MemoryCache<Key, Value>  (generic LRU cache for thumbnails)
```

## How to run
```bash
swift test
```
Or open `Package.swift` in Xcode and press ⌘U.

## Screenshots
_Demo app GIF coming in week 4._

## What I learned
- **Day 1:** A struct copy is independent; a class copy is a shared reference.
  Copy-on-write gives value behaviour with cheap copies — the real copy
  happens only on the first write to a shared box.
- **Day 2:** Optionals: TrimRange uses a failable initializer, 
  so an invalid range can never exist. Tests use #require to unwrap safely.
- **Day 4:** Generics: `MemoryCache<Key, Value>` is one cache for any types.
  Constraints (`Key: Hashable`) say what the types must support, and
  conditional `Sendable` keeps it safe for Swift 6 concurrency.

## License
MIT
