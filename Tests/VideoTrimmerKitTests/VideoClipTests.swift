import Foundation
import Testing
@testable import VideoTrimmerKit

@Suite("Day 2: optionals")
struct VideoClipTests {
    let url = URL(fileURLWithPath: "/tmp/Holiday.mov")

    @Test func titleFallsBackToFileName() {
        #expect(VideoClip(url: url, duration: 10).displayTitle == "Holiday")
        #expect(VideoClip(url: url, duration: 10, title: "").displayTitle == "Holiday")
        #expect(VideoClip(url: url, duration: 10, title: "Goa").displayTitle == "Goa")
    }

    @Test func trimmedLengthUsesOptionalChaining() {
        var clip = VideoClip(url: url, duration: 10)
        #expect(clip.trimmedLength == 10)                  // no trim yet
        clip.trim = TrimRange(start: 2, end: 6, duration: 10)
        #expect(clip.trimmedLength == 4)
    }
}
