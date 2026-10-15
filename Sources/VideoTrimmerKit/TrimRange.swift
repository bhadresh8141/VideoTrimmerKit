import Foundation

/// A part of a video to keep, in seconds. Always valid if it exists.
public struct TrimRange: Equatable, Sendable {
    public let start: Double            // where the cut begins
    public let end: Double              // where the cut ends

    /// Returns nil when the numbers don't make sense.
    public init?(start: Double, end: Double, videoDuration: Double) {
        guard start >= 0,               // can't start before the video
              end > start,              // end must be after start
              end <= videoDuration      // can't go past the video end
        else { return nil }             // bad input → empty box
        self.start = start
        self.end = end
    }

    /// Length of the kept part.
    public var duration: Double { end - start }

    /// Build from text fields. Any bad text → nil.
    public static func from(startText: String,
                            endText: String,
                            videoDuration: Double) -> TrimRange? {
        guard let start = Double(startText),   // "abc" → nil → stop
              let end = Double(endText)
        else { return nil }
        return TrimRange(start: start, end: end, videoDuration: videoDuration)
    }
}
