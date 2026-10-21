// Day 1 (struct = value type) + Day 2 (failable init returns an optional)

/// The part of a video the user wants to keep, in seconds.
/// It's a struct, so every copy is independent, like a photocopy.
public struct TrimRange: Equatable, Sendable {
    public private(set) var start: Double     // others can read it, but only we can change it
    public private(set) var end: Double
    public let duration: Double               // full length of the video
    public static let minimumLength = 0.5     // a trim can't be shorter than half a second

    /// Returns nil when the values make no sense (Day 2: optionals).
    public init?(start: Double, end: Double, duration: Double) {
        guard start >= 0,
              end <= duration,
              end - start >= Self.minimumLength else { return nil }
        self.start = start
        self.end = end
        self.duration = duration
    }

    /// The whole video, used as the starting trim.
    public static func full(duration: Double) -> TrimRange? {
        TrimRange(start: 0, end: duration, duration: duration)
    }

    public var length: Double { end - start }

    /// Move the left handle. `mutating` because a struct changes itself.
    public mutating func setStart(_ value: Double) {
        start = clamp(value, 0, end - Self.minimumLength)          // Day 4 generic helper
    }

    /// Move the right handle.
    public mutating func setEnd(_ value: Double) {
        end = clamp(value, start + Self.minimumLength, duration)
    }
}
