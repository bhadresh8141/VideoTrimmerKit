import AVFoundation
import CoreGraphics

// Day 5: `some` vs `any`

/// Anything that can give us a picture at a time (in seconds).
public protocol ThumbnailSource: Sendable {
    func image(at seconds: Double) async throws -> CGImage
}

/// The real source: reads frames from a video file.
public struct AssetThumbnailSource: ThumbnailSource {
    let url: URL                                         // keep the URL; it's Sendable and safe
    public init(url: URL) { self.url = url }

    public func image(at seconds: Double) async throws -> CGImage {
        let generator = AVAssetImageGenerator(asset: AVURLAsset(url: url))
        generator.appliesPreferredTrackTransform = true  // keep portrait videos upright
        let time = CMTime(seconds: seconds, preferredTimescale: 600)
        return try await generator.image(at: time).image // async API (iOS 16+)
    }
}

/// Builds evenly spaced thumbnails for the trim strip.
public struct ThumbnailStripBuilder: Sendable {
    public let count: Int
    public init(count: Int) { self.count = max(1, count) }   // at least 1 thumbnail

    /// The middle of each slot, e.g. 10s with 2 slots gives [2.5, 7.5]
    public func times(duration: Double) -> [Double] {
        guard duration > 0 else { return [] }
        let step = duration / Double(count)
        return (0..<count).map { Double($0) * step + step / 2 }
    }

    /// `some`: one fixed source type, no box, so calls are fast
    public func build(from source: some ThumbnailSource,
                      duration: Double) async throws -> [CGImage] {
        var images: [CGImage] = []
        for t in times(duration: duration) {
            images.append(try await source.image(at: t))
        }
        return images
    }
}
