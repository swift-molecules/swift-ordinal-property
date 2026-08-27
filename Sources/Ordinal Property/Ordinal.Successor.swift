public import struct Ordinal.Ordinal
public import struct Property.Property

extension Ordinal {

    public enum Successor {}

    @inlinable
    public var successor: Property<Successor, Self> {
        Property(self)
    }
}

extension Property where Tag == Ordinal.Successor, Base == Ordinal {

    @inlinable
    public func saturating() -> Base {
        if base.rawValue == .max {
            return base
        }
        return Base(base.rawValue + 1)
    }

    @inlinable
    public func exact() throws(Base.Error) -> Base {
        if base.rawValue == .max {
            throw .overflow
        }
        return Base(base.rawValue + 1)
    }
}
