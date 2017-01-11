## Sequence

This write-up is an elementary introduction to *protocols* in Swift, including the IteratorProtocol and the Sequence protocol. 

#### Your object printed here

Start by just trying to print a random object like a simple struct:

```css
import Foundation
struct S {
    var name: String
    init(_ input: String) { name = input }
}
let s1 = S("Joe")
print("\(s1)", terminator: "")
// prints: "S(name: "Joe")"
```
When we called ``print``, Swift constructed a string that describes something about the struct and the variables it contains.  

To customize this, simply make the class conform to **CustomStringConvertible**

```css
extension S: CustomStringConvertible {
    var description : String {
        get {
            return "S:  \(name)"
        }
    }
}
let s2 = S("Jim")
print("\(s2))", terminator: "")
// prints:  "S:  Jim"
```
#### Custom protocol

A protocol declaration simply lists the functions, or whatever the official name is for **description** is above (property?), which a conforming type needs to implement:

```css
protocol Incrementable { func addOne() }
class X: Incrementable {
    var i = 1
    func addOne() { i += 1 }
}
let x = X()
print(x.i)  // prints: 1
x.addOne()
print(x.i)  // prints: 2
```
Note that the function **addOne** doesn't have to do *anything*.  It could be empty brackets ``{ }``.

I am scrunching up the formatted code a bit to save space.

### Equatable

The Equatable protocol requires implementing a comparison for equality, naturally enough.

```css
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

```css
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

### IteratorProtocol

The IteratorProtocol requires that the conforming type implement **next()**.  We use the Fibonacci numbers as the example.

```css
class FibonacciIterator: IteratorProtocol {
    var current = (1,1)
    var endIndex: Int
    var currentIndex = 0
    init(size: Int) { endIndex = size }
    
    func next() -> Int? {
        guard currentIndex < endIndex else { return nil }
        currentIndex += 1
        let ret = current.0
        current = (current.1, current.0 + current.1)
        return ret
    }
}

let f = FibonacciIterator(size: 10)
while let fib = f.next() {
    print(fib)
}
```

In the Swift interpreter, this prints the familiar sequence:

```css
1
1
2
3
5
8
13
21
34
55
```

In the interpreter, we get some interesting information about ``f``

```
f: Fibonacci = {
  current = {
    0 = 89
    1 = 144
  }
  endIndex = 10
  currentIndex = 10
}
```
### Sequence

To actually do ``for n in array`` and turn the numbers into an array and so on, we need to be a Sequence.

```css
class FibonacciSequence: Sequence {
    var endIndex: Int
    init(size: Int) { endIndex = size }
    func makeIterator() -> FibonacciIterator {
        return FibonacciIterator(size: endIndex)
    }
}

let a = Array(FibonacciSequence(size: 10))
a
for n in a { print(n) }
```

As you can see, all the class needs to be a Sequence is to implement **makeIterator()**.  

Now, we can turn the sequence into an Array, or iterate over it using ``for n in a``.

### Countdown

The Apple example for Sequence combines these two approaches.  We declare a class that conforms to both protocols, but all the class needs to implement is **next()**.

```css
struct Countdown:  Sequence, IteratorProtocol {
    var count: Int
    mutating func next() -> Int? {
        if count == 0 {
            return nil
        } else {
            defer { count -= 1 }
            return count
        }
    }
}

let threeToGo = Countdown(count: 3)
for i in threeToGo {
    print(i)
}
let a = Array(threeToGo)
a  // [3, 2, 1]
```

What is a little bit wild is to look at what the documentation says about Sequence:  [link](https://developer.apple.com/reference/swift/sequence)

There are actually 12 protocol "requirements", but nearly all of them are provided by default.  We don't need to implement them.

So, for example we can do this now:

```css
threeToGo.contains(3)  // true

func isOdd (input: Int) -> Bool {
    return input % 2 != 0
}

threeToGo.contains(where: isOdd)  // true
threeToGo.filter(isOdd)  // [3, 1]
threeToGo.max()  // 3

func plusOne(input: Int) -> Int {
    return input + 1
}
let a2 = threeToGo.map { plusOne(input: $0) }
a2 // [4, 3, 2]
```

It is certainly possible to get more sophisticated than these examples, but this is a good start on what a Sequence or Iterator is in Swift.

If you want to see more about this topic, I recommend  [link](https://www.uraimo.com/2015/11/12/experimenting-with-swift-2-sequencetype-generatortype/)

