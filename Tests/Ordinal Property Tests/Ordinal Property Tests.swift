import struct Cardinal.Cardinal
import struct Ordinal.Ordinal
import Ordinal_Cardinal
import Ordinal_Property
import Testing

private struct Position: Ordinal.`Protocol`, Comparable {
    typealias Domain = Never
    typealias Count = Cardinal

    let ordinal: Ordinal

    init(_ ordinal: Ordinal) {
        self.ordinal = ordinal
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.ordinal.rawValue == rhs.ordinal.rawValue
    }

    static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.ordinal.rawValue < rhs.ordinal.rawValue
    }
}

@Suite
struct `Ordinal Property Tests` {
    @Test
    func `successor handles exact and saturating overflow`() throws(Ordinal.Error) {
        let successor = try Ordinal(3 as UInt).successor.exact()

        #expect(successor.rawValue == 4)
        #expect(Ordinal(UInt.max).successor.saturating().rawValue == UInt.max)
        #expect(throws: Ordinal.Error.overflow) {
            try Ordinal(UInt.max).successor.exact()
        }
    }

    @Test
    func `predecessor rejects zero`() throws(Ordinal.Error) {
        let predecessor = try Ordinal(3 as UInt).predecessor.exact()

        #expect(predecessor.rawValue == 2)
        #expect(throws: Ordinal.Error.underflow) {
            try Ordinal.zero.predecessor.exact()
        }
    }

    @Test
    func `advance supports exact saturating and clamped policies`() throws(Ordinal.Error) {
        let advanced = try Ordinal(3 as UInt).advance.exact(by: Cardinal(4 as UInt))
        let clamped = Ordinal(3 as UInt).advance.clamped(
            by: Cardinal(9 as UInt),
            to: Ordinal(8 as UInt)
        )

        #expect(advanced.rawValue == 7)
        #expect(clamped.rawValue == 8)
        #expect(
            Ordinal(UInt.max).advance.saturating(by: Cardinal(1 as UInt)).rawValue == UInt.max
        )
        #expect(throws: Ordinal.Error.overflow) {
            try Ordinal(UInt.max).advance.exact(by: Cardinal(1 as UInt))
        }
    }

    @Test
    func `retreat supports exact and clamped policies`() throws(Ordinal.Error) {
        let retreated = try Ordinal(7 as UInt).retreat.exact(by: Cardinal(4 as UInt))
        let clamped = Ordinal(7 as UInt).retreat.clamped(
            by: Cardinal(9 as UInt),
            to: Ordinal(2 as UInt)
        )

        #expect(retreated.rawValue == 3)
        #expect(clamped.rawValue == 2)
        #expect(throws: Ordinal.Error.underflow) {
            try Ordinal(2 as UInt).retreat.exact(by: Cardinal(3 as UInt))
        }
    }

    @Test
    func `distance is directional`() throws(Ordinal.Error) {
        let distance = try Ordinal(2 as UInt).distance.forward(to: Ordinal(7 as UInt))

        #expect(distance.rawValue == 5)
        #expect(throws: Ordinal.Error.notForward) {
            try Ordinal(7 as UInt).distance.forward(to: Ordinal(2 as UInt))
        }
    }

    @Test
    func `range composes ordinal start and cardinal count`() {
        let range = Range<Position>(
            start: Position(Ordinal(2 as UInt)),
            count: Cardinal(3 as UInt)
        )
        let empty = Range<Position>(
            start: Position(Ordinal(4 as UInt)),
            count: Cardinal(UInt.zero)
        )

        #expect(range.lowerBound.ordinal.rawValue == 2)
        #expect(range.upperBound.ordinal.rawValue == 5)
        #expect(range.count.rawValue == 3)
        #expect(!range.isEmpty)
        #expect(empty.isEmpty)
    }
}
