## Swift Ranges

There are four Range types in Swift 3: Closed or Open, Countable and not Countable.  A **ClosedRange** is constructed with the ``...`` operator:

```swift
let R = 1...3    // CountableClosedRange
let CR = ClosedRange(R)
```

* Any ``ClosedRange`` includes its last element.

* A ``ClosedRange`` does *not* conform to the ``Sequence`` protocol, while a ``CountableClosedRange`` does.

* You cannot iterate over the elements of a ``ClosedRange`` with a ``for`` loop.

* The default is a ``CountableClosedRange``

A ``CountableClosedRange`` is similar to a ``ClosedRange`` but it can be iterated over.

```swift
let R1 = 1...3
type(of: R1)    // CountableClosedRange<Int>.Type
var count = 0
for r in R1 { count += r }
count           // 6

let R2 = ClosedRange(R)
type(of: R2)
for r in R2 { count += r }  // error:
  Type 'ClosedRange<Int>' does not conform to protocol 'Sequence'
```

<hr>

In contrast a **Range** is a Half-Open Range, which does not include the last element.  Think of the last element as a sentinel that says "out-of-bounds".

The ``Range`` type is a half-open Range.  The default is a ``CountableRange``:

```swift
let R3 = 1..<4
type(of: R3)    // CountableRange<Int>.Type

let R4 = Range(R3)
type(of: R4)    // Range<Int>.Type
var count = 0
for r in R4 { count += r }  // error:
  Type 'Range<Int>' does not conform to protocol 'Sequence'
```

--------

You can use any one of these four ranges to do:

```swift
let a = ["a","b","c","d","e"]
a[R1]         // ["b","c","d"]
```

with the same result for each.

Don't be confused by this example:

```swift
let a2 = "abcde".characters
a2[R1]       // error
```

The error here is "Cannot subscript a value of type 'String.CharacterView' with an index of type 'CountableClosedRange<Int>' ".

It has nothing to do with indexes.

<hr>

The ``...`` and ``..<`` range operators are shorthand

```swift
let r = 1..<3
```

can also be done as

```swift
let t = (lower: 1, upper: 3)    // (.0 1, .1 3)
let r = CountableRange<Int>(uncheckedBounds: t)
r == 1..<3  // true
```

<hr>

Swift Strings are special, because they insist on not allowing subscripting by Int, due to the variable size (in bytes) of Unicode characters as encoded by UTF8.

The index type of a String is ``String.Index`` and it is calculated for a particular string depending on its content.

```swift
var s = "abcde"
var start = s.index(s.startIndex, offsetBy: 1)  // 1
var end = s.index(s.endIndex, offsetBy: -1)     // 4
let r = start..<end
s.substring(with: r)    // "bcd"

s = "a😀cde"
start = s.index(s.startIndex, offsetBy: 1)      // 1
end = s.index(s.endIndex, offsetBy: -1)         // 5
let r2 = start..<end
s.substring(with: r2)    // "😀cd"

s.substring(with: r)     // "😀c"
```

Note the unexpected result using ``r`` with ``"a😀cde"``.  Also, while the "values" of start and end are as given, they are not convertible to Int even by something like

```swift
end as Int!
```

<hr>

Although I usually think of the operators ``...`` and ``..<`` operating on Ints, they are not so restricted.  

For example:

```swift
let a = "a"..."z"
a.contains("p")           // true
a.isEmpty                 // false
a.lowerBound              // "a"
a.overlaps("c"..."k")     // "true"

type(of: a)		  // ClosedRange<String>
a as! CountableClosedRange<String>    // error:
    Type 'String' does not conform to protocol '_Strideable'
```

Expect these to change again in Swift4.  Discussion [here](https://oleb.net/blog/2016/09/swift-3-ranges/).

<hr>

Why so complicated?  [docs](https://github.com/apple/swift-evolution/blob/master/proposals/0065-collections-move-indices.md)

For technical reasons

"responsibility for index traversal is moved from the index to the collection itself. For example, instead of writing ``i.successor()``, one would write ``c.index(after: i)``.

As a result:

* A collection's ``Index`` can be any ``Comparable`` type.

* The distinction between intervals and ranges disappears, leaving only ranges.

* A closed range *can* include the maximal value of its ``Bound`` type

```swift
let arr = 1...Int.max
arr.upperBound
var x = UInt(2) << 62     // 2**63 = 9223372036854775807
x -= 1                    // 2**63 - 1
Int(x) == Int.max         // true
```
