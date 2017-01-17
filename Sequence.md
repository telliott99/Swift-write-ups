### Sequence

To actually do ``for n in array`` and turn the numbers into an array and so on, we need to be a Sequence.

```swift
class FibonacciSequence: Sequence {
    var endIndex: Int
    init(size: Int) { endIndex = size }
    func makeIterator() -> FibonacciIterator {
        return FibonacciIterator(size: endIndex)
    }
}

let a = Array(FibonacciSequence(size: 10))
a
for n in a { 
    print(n) 
}
```

As you can see, all the class needs to be a Sequence is to implement **makeIterator()**.  

Now, we can turn the sequence into an Array, or iterate over it using ``for n in a``.

The same thing can be achieved more compactly as follows:

```swift
import Foundation
class CompactFibonacciSequence : Sequence {
    var endIndex:Int
    init(end:Int){ 
        endIndex = end
    }
    
    func makeIterator() -> AnyIterator<Int> {
        var current = (1,1)
        var currentIndex = 0
        
        return AnyIterator{
            guard currentIndex < self.endIndex else {
                return nil
            }
            currentIndex += 1
            let ret = current.0
            current = (current.1,current.0+current.1)
            return ret
        }
    }
}

let seq = CompactFibonacciSequence(end: 10)
let a = Array(seq)  // [1, 1, 2, 3, 5, 8, 13, 21, 34, 55]
```

I don't know much about **AnyIterator**, but it does simplify the code a lot.

### Countdown

The Apple example for Sequence combines these two approaches.  We declare a class that conforms to both protocols, but all the class needs to implement is **next()**.

```swift
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

What the documentation says about Sequence [here](https://developer.apple.com/reference/swift/sequence) is a little bit wild.

There are actually 12 protocol "requirements", but nearly all of them are provided by default.  We don't need to implement them.

Now **contains**, **filter**, **map**, and several others are provided for us.

```swift
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

If you want to see more about this topic, I recommend  [this](https://www.uraimo.com/2015/11/12/experimenting-with-swift-2-sequencetype-generatortype/).

