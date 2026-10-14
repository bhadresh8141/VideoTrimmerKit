import Foundation

/// A list of thumbnail times shown under the trimmer.
/// It behaves like a value type, but uses copy-on-write (CoW):
/// copies share one storage box until someone changes their copy.
public struct ThumbnailStrip: Sendable {
    /// The shared box. A class, so many copies can point to the same one.
    final class Storage: @unchecked Sendable {
        // @unchecked is safe here: we only change `times` after
        // isKnownUniquelyReferenced says nobody else holds this box.
        var times: [TimeInterval]
        init(times: [TimeInterval]) { self.times = times }
    }

    private var storage: Storage

    public init(times: [TimeInterval] = []) {
        storage = Storage(times: times)
    }

    /// Reading never copies.
    public var times: [TimeInterval] { storage.times }

    /// Adds a thumbnail time. Copies the box first if it is shared.
    public mutating func append(_ time: TimeInterval) {
        makeUniqueIfNeeded()
        storage.times.append(time)
    }

    private mutating func makeUniqueIfNeeded() {
        if !isKnownUniquelyReferenced(&storage) {
            storage = Storage(times: storage.times)
        }
    }

    /// Only for tests: true when two strips share the same box.
    func sharesStorage(with other: ThumbnailStrip) -> Bool {
        storage === other.storage
    }
}
