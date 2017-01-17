## Protocols

This write-up is a simple introduction to *protocols* in Swift.  After this introduction, we will look at the IteratorProtocol and the Sequence protocol in the second installment. 

#### CustomStringConvertible:  your object printed here

Start by just trying to print a random object like a simple struct:

```swift
import Foundation

struct S {
    var name: String
    init(_ input: String) { name = input }
}
let s1 = S("Joe")
print("\(s1)", terminator: "")
// prints: "S(name: "Joe")"
```
When we called **print**, Swift constructed a String that describes something about the struct and its variables.  

To customize this, make the class conform to **CustomStringConvertible**

```swift
extension S: CustomStringConvertible {
    var description : String {
        return "S:  \(name)"
    }
}
let s2 = S("Jim")
print("\(s2))", terminator: "")
// prints:  "S:  Jim"
```

[Note](https://github.com/raywenderlich/swift-style-guide#use-of-self):  ``get`` is only needed when there is also a ``set``.  So don't use ``get`` above.

#### Custom protocol

A protocol declaration simply lists the functions, or the official name for **description** above (property), which a conforming type needs to implement:

```swift
protocol Incrementable { func addOne() }
class X: Incrementable {
    var i = 1
    func addOne() { 
        i += 1 
    }
}

let x = X()
print(x.i)  // prints: 1
x.addOne()
print(x.i)  // prints: 2
```
Note that the function **addOne** doesn't have to do *anything*.  It could be empty brackets ``{ }``.

### Equatable

The ``Equatable`` protocol requires implementing a comparison for equality, naturally enough.

```swift
struct Complex {
    let real: Double
    let imag: Double
}

extension Complex: Equatable {}

func ==(lhs: Complex, rhs: Complex) -> Bool {
    return lhs.real == rhs.real
        && lhs.imag == rhs.imag
}

let a = Complex(real: 1.0, imag: 2.0)
let b = Complex(real: 1.0, imag: 2.0)
a == b // true
a != b // false
``` 
The appearance of the special definition of the ``==`` operator outside any class or extension is standard Swift syntax.

Note:  the code I copied for the above example had generics in it.  I am not sure of the advantages, but I put that here for completeness.

```swift
struct Complex<T: SignedNumber> {
    let real: T
    let imag: T
}
extension Complex: Equatable {}

func ==<T>(lhs: Complex<T>, rhs: Complex<T>) -> Bool {
    return lhs.real == rhs.real
        && lhs.imag == rhs.imag
}

let a = Complex<Double>(real: 1.0, imag: 2.0)
let b = Complex<Double>(real: 1.0, imag: 2.0)

a == b // true
a != b // false
```

### Comparable

The ``Comparable`` protocol is used for types that have an inherent order, such as numbers and strings.

``Comparable`` "extends" ``Equatable``, which means that anything that conforms to the first also satisfies the second requirement.

To be ``Comparable`` we must implement the two operators: ``==`` and ``<``.  The standard library will then give us default implementations of everything else, like ``!=`` and ``>``.

Here is the example in the docs:

```swift
import Cocoa

struct Date {
    let year: Int
    let month: Int
    let day: Int
}

extension Date: Comparable {
    static func == (lhs: Date, rhs: Date) -> Bool {
        return lhs.year == rhs.year 
        && lhs.month == rhs.month 
        && lhs.day == rhs.day
    }
    
    static func < (lhs: Date, rhs: Date) -> Bool {
        if lhs.year != rhs.year {
            return lhs.year < rhs.year
        } else if lhs.month != rhs.month {
            return lhs.month < rhs.month
        } else {
            return lhs.day < rhs.day
        }
    }
}

let today =     Date(year: 2017, month: 1, day: 14)
let yesterday = Date(year: 2017, month: 1, day: 13)
today > yesterday   // true
```