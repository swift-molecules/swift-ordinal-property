public import struct Cardinal.Cardinal
public import struct Ordinal.Ordinal
public import struct Property.Property

extension Ordinal {

    public enum Retreat {}

    @inlinable
    public var retreat: Property<Retreat, Self> {
        Property(self)
    }
}

extension Property where Tag == Ordinal.Retreat, Base == Ordinal {

    @inlinable
    public func exact(by count: Cardinal) throws(Base.Error) -> Base {
        if count.rawValue > base.rawValue {
            throw .underflow
        }
        return Base(base.rawValue - count.rawValue)
    }

    @inlinable
    public func clamped(by count: Cardinal, to bound: Base) -> Base {

        guard bound.rawValue < base.rawValue else {
            return bound
        }

        if count.rawValue > base.rawValue - bound.rawValue {
            return bound
        }
        return Base(base.rawValue - count.rawValue)
    }
}
