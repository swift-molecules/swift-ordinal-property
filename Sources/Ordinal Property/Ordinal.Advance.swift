public import struct Cardinal.Cardinal
public import Carrier
public import struct Ordinal.Ordinal
public import Ordinal_Cardinal
public import struct Property.Property

extension Ordinal {

    public enum Advance {}
}

extension Ordinal.`Protocol` {

    @inlinable
    public var advance: Property<Ordinal.Advance, Self> {
        Property(self)
    }
}

extension Property where Tag == Ordinal.Advance, Base: Ordinal.`Protocol` {

    @inlinable
    public func saturating(by count: some Carrier.`Protocol`<Cardinal>) -> Base {
        let (result, overflow) = base.ordinal.rawValue.addingReportingOverflow(
            count.underlying.rawValue
        )
        if overflow {
            return Base(Ordinal(UInt.max))
        }
        return Base(Ordinal(result))
    }

    @inlinable
    public func exact(by count: some Carrier.`Protocol`<Cardinal>) throws(Ordinal.Error) -> Base {
        let (result, overflow) = base.ordinal.rawValue.addingReportingOverflow(
            count.underlying.rawValue
        )
        if overflow {
            throw .overflow
        }
        return Base(Ordinal(result))
    }

    @inlinable
    public func clamped(by count: some Carrier.`Protocol`<Cardinal>, to bound: Base) -> Base {
        let (result, overflow) = base.ordinal.rawValue.addingReportingOverflow(
            count.underlying.rawValue
        )
        if overflow || result > bound.ordinal.rawValue {
            return bound
        }
        return Base(Ordinal(result))
    }
}
