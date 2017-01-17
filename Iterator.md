### IteratorProtocol

The IteratorProtocol requires that the conforming type implement **next()**.  We use the Fibonacci numbers as the example.

```swift
class FibonacciIterator: IteratorProtocol {
    var current = (1,1)
    var endIndex: Int
    var currentIndex = 0
    init(size: Int) { 
        endIndex = size 
    }
    
    func next() -> Int? {
        guard currentIndex < endIndex else { 
            return nil 
        }
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

```bash
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

```swift
f: Fibonacci = {
  current = {
    0 = 89
    1 = 144
  }
  endIndex = 10
  currentIndex = 10
}
```