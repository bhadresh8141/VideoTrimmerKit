import Testing
@testable import VideoTrimmerKit

@Suite("MemoryCache")
struct MemoryCacheTests {

    @Test func storesAndReadsValue() {
        var cache = MemoryCache<Int, String>(limit: 2)
        cache.insert("zero", for: 0)
        #expect(cache.value(for: 0) == "zero")
    }

    @Test func dropsOldestWhenFull() {
        var cache = MemoryCache<Double, String>(limit: 2)
        cache.insert("a", for: 1)
        cache.insert("b", for: 2)
        cache.insert("c", for: 3)
        #expect(cache.value(for: 1) == nil)  // oldest was removed
        #expect(cache.count == 2)
    }

    @Test func readingKeepsItemFresh() {
        var cache = MemoryCache<Int, String>(limit: 2)
        cache.insert("a", for: 1)
        cache.insert("b", for: 2)
        _ = cache.value(for: 1)              // 1 is now "recent"
        cache.insert("c", for: 3)            // so 2 gets removed instead
        #expect(cache.value(for: 2) == nil)
        #expect(cache.value(for: 1) == "a")
    }

    @Test func insertingSameKeyReplacesValue() {
        var cache = MemoryCache<String, Int>(limit: 2)
        cache.insert(1, for: "x")
        cache.insert(2, for: "x")            // same key, new value
        #expect(cache.value(for: "x") == 2)
        #expect(cache.count == 1)            // still one item, not two
    }
}
