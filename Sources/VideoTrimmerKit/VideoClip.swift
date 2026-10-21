import Foundation

// Day 2: optionals. A value that may or may not be there.

/// One video the user picked.
public struct VideoClip: Equatable, Sendable {
    public let url: URL
    public let duration: Double
    public var title: String?        // the user may not give a title
    public var trim: TrimRange?      // nil = not trimmed yet

    public init(url: URL, duration: Double, title: String? = nil, trim: TrimRange? = nil) {
        self.url = url
        self.duration = duration
        self.title = title
        self.trim = trim
    }

    /// `guard let` gives a fallback when the title is nil or empty.
    public var displayTitle: String {
        guard let title, !title.isEmpty else {       // short `if let` / `guard let` syntax
            return url.deletingPathExtension().lastPathComponent
        }
        return title
    }

    /// Optional chaining: if there's no trim, use the full duration.
    public var trimmedLength: Double {
        trim?.length ?? duration
    }
}
