public import struct Cardinal.Cardinal
public import Carrier
public import struct Ordinal.Ordinal
public import Ordinal_Cardinal
public import struct Property.Property

extension Ordinal {

    public enum Distance {}
}

extension Ordinal.`Protocol` {

    @inlinable
    public var distance: Property<Ordinal.Distance, Self> {
        Property(self)
    }
}

extension Property where Tag == Ordinal.Distance, Base: Ordinal.`Protocol` {

    @inlinable
    public func forward(to other: Base) throws(Ordinal.Error) -> Base.Count {
        if other.ordinal.rawValue < base.ordinal.rawValue {
            throw .notForward
        }
        return Base.Count(Cardinal(other.ordinal.rawValue - base.ordinal.rawValue))
    }
}

extension Property where Tag == Ordinal.Distance, Base: Ordinal.`Protocol` {

    @inlinable
    public func unchecked(to other: Base) -> Base.Count {
        Base.Count(Cardinal(other.ordinal.rawValue - base.ordinal.rawValue))
    }
}
