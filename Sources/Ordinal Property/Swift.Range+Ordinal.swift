public import Ordinal_Cardinal

extension Swift.Range where Bound: Ordinal.`Protocol` {

    @inlinable
    public var isEmpty: Bool { lowerBound == upperBound }
}

extension Swift.Range where Bound: Ordinal.`Protocol` {

    @inlinable
    public var count: Bound.Count {
        lowerBound.distance.unchecked(to: upperBound)
    }
}

extension Swift.Range where Bound: Ordinal.`Protocol` {

    @inlinable
    public init(start: Bound, count: Bound.Count) {
        unsafe self.init(uncheckedBounds: (lower: start, upper: start + count))
    }
}
