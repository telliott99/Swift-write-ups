### Strideable

From [here](http://stackoverflow.com/questions/27024603) and updated by me for Swift3.

```swift
final class Foo {
    var value: Int = 0
    init(_ newValue: Int) { value = newValue }
}

extension Foo: Strideable {
    typealias Stride = Int
    func distance(to other: Foo) -> Stride {
        return other.value - value
    }
    func advanced(by n: Stride) -> Self {
        return type(of: self).init(value + n)
    }
}

func ==(x: Foo, y: Foo) -> Bool { return x.value == y.value }
func <(x: Foo, y: Foo) -> Bool { return x.value < y.value }

let a = Foo(10)
let b = Foo(20)

for c in stride(from: a, to: b, by: 1) {
    print(c.value)
}
```

The debug log prints the integers 10 through 19.

``Strideable`` extends ``Comparable``, providing the additional functions ``distanceTo`` and ``advancedBy``.

The class must be ``final`` (not sub-classable) for this to work.  The hints given when ``final`` is missing suggest substituting ``Self`` in ``advanced``.  But that works only for the return type.  After some fooling around, and the help of the compiler, I came up with this:

```swift
    func advanced(by n: Stride) -> Self {
        return type(of: self).init(value + n)
    }
```

and that allows me to remove the ``final``.