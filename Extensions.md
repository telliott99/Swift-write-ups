Arrays do not have randomChoice or randomShuffle

```swift
import Foundation

extension Array {
    func randomChoice()  -> Element? {
        let n = self.count
        if n == 0 { return nil }
        // takes and returns a UInt32
        let i = Int(arc4random_uniform(UInt32(n)))
        return self[i]
    }
}

let a = Array(0..<10)
a.randomChoice()      // prints one element
let b = ["a","b","c","d","e"]
b.randomChoice()
```

One thing that is no longer possible but would help is the ability to seed the PRNG for testing, so that we would always get the same result.

``rand()``, ``random`` and ``seed`` are all "unavailable in Swift".
