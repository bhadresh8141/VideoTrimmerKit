import Testing
@testable import VideoTrimmerKit

@Suite("Day 4: generics")
struct GenericsTests {
    @Test func clampWorksForManyTypes() {
        #expect(clamp(15, 0, 10) == 10)            // Int
        #expect(clamp(-2.5, 0.0, 1.0) == 0.0)      // Double
        #expect(clamp("m", "a", "f") == "f")       // String is Comparable too
    }

    @Test func cacheDropsOldestWhenFull() {
        let cache = MemoryCache<Int, String>(capacity: 2)
        cache[1] = "one"
        cache[2] = "two"
        cache[3] = "three"                         // pushes out key 1
        #expect(cache[1] == nil)
        #expect(cache[3] == "three")
        #expect(cache.count == 2)
    }

    @Test func settingNilRemoves() {
        let cache = MemoryCache<String, Int>(capacity: 3)
        cache["a"] = 1
        cache["a"] = nil
        #expect(cache.count == 0)
    }
}
