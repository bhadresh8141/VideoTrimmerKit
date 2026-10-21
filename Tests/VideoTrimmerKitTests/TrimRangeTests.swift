import Testing
@testable import VideoTrimmerKit

@Suite("Day 1-2: TrimRange")
struct TrimRangeTests {
    @Test func validRangeIsCreated() throws {
        let range = try #require(TrimRange(start: 1, end: 5, duration: 10))  // unwrap or fail
        #expect(range.length == 4)
    }

    @Test(arguments: [(-1.0, 5.0), (2.0, 11.0), (3.0, 3.2)])
    func invalidRangeIsNil(start: Double, end: Double) {
        #expect(TrimRange(start: start, end: end, duration: 10) == nil)
    }

    @Test func structCopiesAreIndependent() throws {
        let original = try #require(TrimRange.full(duration: 10))
        var copy = original                  // a photocopy
        copy.setStart(4)                     // change only the copy
        #expect(original.start == 0)         // the original is safe
        #expect(copy.start == 4)
    }

    @Test func handlesAreClamped() throws {
        var range = try #require(TrimRange.full(duration: 10))
        range.setEnd(50)                     // too far right
        #expect(range.end == 10)
        range.setStart(9.9)                  // too close to the end
        #expect(range.start == 10 - TrimRange.minimumLength)
    }
}
