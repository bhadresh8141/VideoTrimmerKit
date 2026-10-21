/// A small "keep the latest N items" cache (LRU = least recently used goes out first).
///
/// It is generic, so it works with any key and value:
/// `MemoryCache<TimeInterval, CGImage>` for thumbnails, `MemoryCache<URL, Data>` for files, and so on.
public struct MemoryCache<Key: Hashable, Value> {
    private var storage: [Key: Value] = [:]  // the actual items
    private var order: [Key] = []            // oldest first, newest last
    public let limit: Int                    // max items we keep

    public init(limit: Int) {
        precondition(limit > 0, "limit must be more than 0")
        self.limit = limit
    }

    /// How many items are stored right now.
    public var count: Int { storage.count }

    /// Read a value. Reading marks it as "recently used".
    public mutating func value(for key: Key) -> Value? {
        guard let value = storage[key] else { return nil }
        touch(key)
        return value
    }

    /// Save a value. If we go over the limit, drop the oldest one.
    public mutating func insert(_ value: Value, for key: Key) {
        storage[key] = value
        touch(key)
        if order.count > limit {
            let oldest = order.removeFirst()
            storage[oldest] = nil
        }
    }

    /// Move a key to the "newest" end of the order list.
    private mutating func touch(_ key: Key) {
        order.removeAll { $0 == key }  // works because Key is Hashable (so also Equatable)
        order.append(key)
    }
}

// Safe to share across threads ONLY if what's inside is also safe (Swift 6 rule).
extension MemoryCache: Sendable where Key: Sendable, Value: Sendable {}
