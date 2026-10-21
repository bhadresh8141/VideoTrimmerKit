// Day 3: protocols + protocol extensions (default behaviour)

/// A rule for how to save the trimmed video.
/// Like a menu card: every dish must have a name and a size.
public protocol ExportPreset: Sendable {
    var name: String { get }
    var maxDimension: Int? { get }       // nil = keep the original size
    var fileExtension: String { get }
}

/// Default behaviour every preset gets for free.
public extension ExportPreset {
    var fileExtension: String { "mp4" }  // most presets save as .mp4

    /// e.g. "Holiday-social.mp4"
    func outputFileName(for clip: VideoClip) -> String {
        "\(clip.displayTitle)-\(name).\(fileExtension)"
    }
}

/// Keep full quality.
public struct OriginalPreset: ExportPreset {
    public let name = "original"
    public let maxDimension: Int? = nil
    public init() {}
}

/// Smaller file for Instagram or WhatsApp.
public struct SocialPreset: ExportPreset {
    public let name = "social"
    public let maxDimension: Int? = 1080
    public init() {}
}

/// A tiny preview file. It overrides the default extension.
public struct PreviewPreset: ExportPreset {
    public let name = "preview"
    public let maxDimension: Int? = 480
    public let fileExtension = "mov"
    public init() {}
}
