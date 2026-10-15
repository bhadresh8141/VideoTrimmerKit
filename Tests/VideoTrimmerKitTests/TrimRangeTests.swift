import Testing
@testable import VideoTrimmerKit

@Suite("TrimRange")
struct TrimRangeTests {
    @Test func copiesAreIndependent() {
        let original = TrimRange(start: 2, end: 8, videoDuration: 10)
        var copy = original          // a full, separate copy
        copy.moveStart(to: 5)        // change only the copy
        #expect(original.start == 2) // original is untouched
        #expect(copy.start == 5)
    }

    @Test func valuesAreClampedInsideVideo() {
        let range = TrimRange(start: -3, end: 50, videoDuration: 10)
        #expect(range.start == 0)
        #expect(range.end == 10)
        #expect(range.duration == 10)
    }

    @Test func handlesCannotCross() {
        var range = TrimRange(start: 2, end: 6, videoDuration: 10)
        range.moveStart(to: 9)       // try to pass the end handle
        #expect(range.start == 6)
        range.moveEnd(to: 1)         // try to go before the start handle
        #expect(range.end == 6)
    }
}

@Suite("ThumbnailStrip copy-on-write")
struct ThumbnailStripTests {
    @Test func copySharesStorageUntilWrite() {
        let a = ThumbnailStrip(times: [0, 1, 2])
        var b = a
        #expect(b.sharesStorage(with: a))   // no copy yet (cheap)
        b.append(3)                         // first write -> real copy
        #expect(!b.sharesStorage(with: a))
        #expect(a.times == [0, 1, 2])
        #expect(b.times == [0, 1, 2, 3])
    }
}

@Test func validRangeIsCreated() throws {
    // #require: fail the test if nil, else give the unwrapped value
    let range = try #require(TrimRange(start: 1, end: 5, videoDuration: 10))
    #expect(range.duration == 4)
}

// One test, many bad inputs: each pair must give nil
@Test(arguments: [(-1.0, 5.0), (5.0, 5.0), (6.0, 2.0), (1.0, 11.0)])
func invalidRangeIsNil(start: Double, end: Double) {
    #expect(TrimRange(start: start, end: end, videoDuration: 10) == nil)
}

@Test func parsesTextFromUser() {
    #expect(TrimRange.from(startText: "2", endText: "8", videoDuration: 10) != nil)
    #expect(TrimRange.from(startText: "abc", endText: "8", videoDuration: 10) == nil)
}
