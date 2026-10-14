import Foundation

/// The part of a video the user wants to keep, in seconds.
/// A struct (value type): every copy is independent, so one screen
/// can never change another screen's range by mistake.
public struct TrimRange: Equatable, Hashable, Sendable {
    /// Start of the kept part, in seconds.
    public private(set) var start: TimeInterval
    /// End of the kept part, in seconds.
    public private(set) var end: TimeInterval
    /// Full length of the video, in seconds.
    public let videoDuration: TimeInterval

    /// Creates a range. Values outside the video are pulled back inside.
    public init(start: TimeInterval, end: TimeInterval, videoDuration: TimeInterval) {
        self.videoDuration = max(0, videoDuration)
        let safeStart = min(max(0, start), self.videoDuration)
        self.start = safeStart
        self.end = min(max(safeStart, end), self.videoDuration)
    }

    /// How long the trimmed clip will be.
    public var duration: TimeInterval { end - start }

    /// Moves the start handle. It can never pass the end handle.
    public mutating func moveStart(to newStart: TimeInterval) {
        start = min(max(0, newStart), end)
    }

    /// Moves the end handle. It can never go before the start handle.
    public mutating func moveEnd(to newEnd: TimeInterval) {
        end = max(min(videoDuration, newEnd), start)
    }
}
