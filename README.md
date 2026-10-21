# VideoTrimmerKit

![CI](https://github.com/bhadresh8141/VideoTrimmerKit/actions/workflows/ci.yml/badge.svg)
![Swift 6](https://img.shields.io/badge/Swift-6-orange) ![iOS 17+](https://img.shields.io/badge/iOS-17%2B-blue) ![License: MIT](https://img.shields.io/badge/license-MIT-green)

A small Swift package for **trimming videos**: trim ranges, thumbnail strips, export presets and caching.
It's built step by step to show clean, modern Swift 6 code.

> 🚧 Work in progress. Async export, an export actor, a SwiftUI trimming view and a demo app come next.

## Screenshots

| Trimming view | Thumbnail strip |
|---|---|
| _coming soon_ | _coming soon_ |

## What it shows

| Area | Where |
|---|---|
| Value types and copy-on-write | `TrimRange`, `ThumbnailStrip` |
| Optionals done safely | `TrimRange.init?`, `VideoClip` |
| Protocols with default behaviour | `ExportPreset` |
| Generics | `clamp(_:_:_:)`, `MemoryCache<Key, Value>`, `ThumbnailStrip<Frame>` |
| `some` vs `any` | `ThumbnailSource`, `ThumbnailStripBuilder` |
| Swift Testing | `Tests/VideoTrimmerKitTests` |
| CI without code signing | `.github/workflows/ci.yml` |

## Architecture

```text
VideoClip ──has──▶ TrimRange (struct, value type)
    │
    ▼
ExportPreset (protocol) ◀── OriginalPreset / SocialPreset / PreviewPreset

ThumbnailStripBuilder ──uses──▶ some ThumbnailSource ◀── AssetThumbnailSource (AVFoundation)
        │                                           ◀── FakeSource (tests)
        ▼
  [CGImage] ──▶ ThumbnailStrip<Frame> (copy-on-write)
                MemoryCache<Key, Value> (generic cache)
```

## How to run

```bash
git clone https://github.com/bhadresh8141/VideoTrimmerKit.git
cd VideoTrimmerKit
swift test            # or open Package.swift in Xcode and press Cmd+U
```

Requirements: Xcode 16 or later, iOS 17+ / macOS 14+. No paid Apple Developer account needed.

### Usage

```swift
import VideoTrimmerKit

var clip = VideoClip(url: videoURL, duration: 42)
clip.trim = TrimRange(start: 5, end: 20, duration: clip.duration)

let builder = ThumbnailStripBuilder(count: 8)
let images = try await builder.build(from: AssetThumbnailSource(url: videoURL),
                                     duration: clip.duration)

let fileName = SocialPreset().outputFileName(for: clip)   // "MyVideo-social.mp4"
```

## What I learned

- **Day 1 – struct vs class and copy-on-write:** `TrimRange` is a struct, so each copy is independent. `ThumbnailStrip` keeps its frames in a class and copies them only on the first write, using `isKnownUniquelyReferenced`.
- **Day 2 – optionals:** `TrimRange.init?` returns `nil` for bad input instead of crashing. `VideoClip` uses `guard let`, `??` and optional chaining (`trim?.length`).
- **Day 3 – protocols:** `ExportPreset` defines the rule, and a protocol extension gives a default `fileExtension` and `outputFileName(for:)`. `PreviewPreset` overrides the default.
- **Day 4 – generics:** `clamp` works for any `Comparable` type. `MemoryCache<Key, Value>` and `ThumbnailStrip<Frame>` are written once and work for any type.
- **Day 5 – some vs any:** `ThumbnailStripBuilder.build(from: some ThumbnailSource)` keeps one fixed type, so there's no box and calls are fast. Tests store sources as `any ThumbnailSource`, and Swift opens the box automatically when passing it to `some`.

## License

MIT. See [LICENSE](LICENSE).
