import Testing
import CoreGraphics
@testable import VideoTrimmerKit

struct FakeSource: ThumbnailSource {                 // no video needed in tests
    func image(at seconds: Double) async throws -> CGImage {
        let ctx = CGContext(data: nil, width: 1, height: 1, bitsPerComponent: 8,
                            bytesPerRow: 4, space: CGColorSpaceCreateDeviceRGB(),
                            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
        return ctx.makeImage()!                       // a tiny 1x1 picture
    }
}

@Suite("Day 5: some vs any")
struct ThumbnailStripTests {
    @Test func timesAreCentered() {
        #expect(ThumbnailStripBuilder(count: 2).times(duration: 10) == [2.5, 7.5])
    }

    @Test func zeroDurationGivesNoTimes() {
        #expect(ThumbnailStripBuilder(count: 5).times(duration: 0).isEmpty)
    }

    @Test func buildWorksWithAnyBox() async throws {
        let sources: [any ThumbnailSource] = [FakeSource()]   // `any` box
        let images = try await ThumbnailStripBuilder(count: 3)
            .build(from: sources[0], duration: 9)             // box is opened into `some`
        #expect(images.count == 3)
    }
}
