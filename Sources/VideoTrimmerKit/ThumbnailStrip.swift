// Day 1: copy-on-write (COW) + Day 4: generic over the frame type

/// A list of thumbnail frames that copies its storage only when needed.
/// Like sharing one notebook with a friend: you only photocopy it
/// when one of you wants to write in it.
public struct ThumbnailStrip<Frame> {
    /// The real data lives in a class (shared by reference).
    final class Storage {
        var frames: [Frame]
        init(_ frames: [Frame]) { self.frames = frames }
    }

    private var storage: Storage

    public init(frames: [Frame] = []) {
        storage = Storage(frames)
    }

    public var frames: [Frame] { storage.frames }   // reading never copies
    public var count: Int { storage.frames.count }

    /// Writing: make a private copy first if someone else shares the storage.
    public mutating func append(_ frame: Frame) {
        if !isKnownUniquelyReferenced(&storage) {    // is anyone else holding it?
            storage = Storage(storage.frames)        // yes, so take our own copy
        }
        storage.frames.append(frame)
    }

    /// Only for tests: lets us check whether two strips share storage.
    var storageID: ObjectIdentifier { ObjectIdentifier(storage) }
}
