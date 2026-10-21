import Foundation
import Testing
@testable import VideoTrimmerKit

@Suite("Day 3: protocols")
struct ExportPresetTests {
    let clip = VideoClip(url: URL(fileURLWithPath: "/tmp/Holiday.mov"), duration: 10)

    @Test func defaultExtensionComesFromProtocolExtension() {
        #expect(SocialPreset().outputFileName(for: clip) == "Holiday-social.mp4")
    }

    @Test func presetCanOverrideDefault() {
        #expect(PreviewPreset().outputFileName(for: clip) == "Holiday-preview.mov")
    }

    @Test func originalKeepsSize() {
        #expect(OriginalPreset().maxDimension == nil)
    }
}
