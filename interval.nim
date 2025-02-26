type 
    Interval* = object
        min*, max*: float

# default interval is empty (represented by ]+inf, -inf[)
proc interval*(): Interval = Interval(min: high(float), max: -high(float))

proc interval*(min, max: float): Interval = Interval(min: min, max: max)

proc size*(self: Interval): float = self.max - self.min

proc contains*(self: Interval, x: float): bool = self.min <= x and x <= self.max

proc surrounds*(self: Interval, x: float): bool = self.min < x and x < self.max

proc clamp*(self: Interval, x: float): float =
    if x < self.min: return self.min
    if self.max < x: return self.max
    return x

const empty = interval()
const universe = interval(-high(float), high(float))

when isMainModule:
    let i1 = interval(1.0, 5.0)
    let i2 = interval(-2.0, 2.0)
    let i3 = interval(0.0, 0.0)
    let emptyInt = interval()
    let universeInt = universe

    assert i1.size() == 4.0
    assert i2.size() == 4.0
    assert i3.size() == 0.0
    assert emptyInt.size() < 0.0

    assert i1.contains(3.0)
    assert i1.contains(5.0)
    assert not i1.contains(6.0)
    assert i2.contains(0.0)
    assert i2.contains(-2.0)
    assert not i2.contains(3.0)
    assert not emptyInt.contains(0.0)
    assert universeInt.contains(1000.0)

    assert i1.surrounds(3.0)
    assert not i1.surrounds(1.0)
    assert not i1.surrounds(5.0)
    assert i2.surrounds(0.0)
    assert not i2.surrounds(-2.0)
    assert not i2.surrounds(2.0)
    assert not emptyInt.surrounds(0.0)
    assert universeInt.surrounds(0.0)

    assert i1.clamp(2.5) == 2.5
    assert i1.clamp(-1.0) == 1.0
    assert i1.clamp(5.001) == 5.0

    echo "All unit tests passed successfully!"
