import Testing
@testable import VideoTrimmerKit

@Suite("Day 1: copy-on-write")
struct ThumbnailStripCOWTests {
    @Test func copySharesStorageUntilWrite() {
        let a = ThumbnailStrip(frames: [1, 2, 3])
        var b = a
        #expect(a.storageID == b.storageID)  // same notebook, no copy yet

        b.append(4)                          // first write makes a copy
        #expect(a.storageID != b.storageID)
        #expect(a.count == 3)                // original unchanged
        #expect(b.count == 4)
    }

    @Test func uniqueOwnerDoesNotCopy() {
        var strip = ThumbnailStrip<Int>()
        let before = strip.storageID
        strip.append(1)                      // nobody else shares it, so no copy
        #expect(strip.storageID == before)
    }
}
