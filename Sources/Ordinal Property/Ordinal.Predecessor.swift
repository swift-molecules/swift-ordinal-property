public import Ordinal
public import Property

extension Ordinal {

    public enum Predecessor {}

    @inlinable
    public var predecessor: Property<Predecessor, Self> {
        Property(self)
    }
}

extension Property where Tag == Ordinal.Predecessor, Base == Ordinal {

    @inlinable
    public func exact() throws(Base.Error) -> Base {
        if base.rawValue == 0 {
            throw .underflow
        }
        return Base(base.rawValue - 1)
    }
}
