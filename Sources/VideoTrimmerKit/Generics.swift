// Day 4: generics. Write the code once and use it for many types.

/// Keep a value between a lower and an upper limit.
/// Works for Int, Double, Date... anything Comparable.
public func clamp<T: Comparable>(_ value: T, _ lower: T, _ upper: T) -> T {
    min(max(value, lower), upper)
}

/// A small in-memory cache, for example for thumbnails.
/// Generic: Key can be any Hashable type and Value can be anything.
/// When it is full, the oldest item is removed first.
public final class MemoryCache<Key: Hashable, Value> {
    private var store: [Key: Value] = [:]
    private var order: [Key] = []          // oldest key is at the front
    public let capacity: Int

    public init(capacity: Int) {
        self.capacity = max(1, capacity)   // at least 1 slot
    }

    public var count: Int { store.count }

    public subscript(key: Key) -> Value? {
        get { store[key] }
        set {
            guard let newValue else {               // setting nil means remove
                store[key] = nil
                order.removeAll { $0 == key }
                return
            }
            if store[key] == nil { order.append(key) }  // new key goes to the back
            store[key] = newValue
            if order.count > capacity {             // too many items?
                let oldest = order.removeFirst()
                store[oldest] = nil                 // drop the oldest one
            }
        }
    }
}
