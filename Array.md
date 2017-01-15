## Arrays

### basic

Some of the Array methods are used for nearly every script.  Examples:

```swift
import Foundation
let a = [1, 2, 3]
a.count                  // 3
a.append(10)             // [1, 2, 3, 10]
a += [10]                // [1, 2, 3, 10, 10]
a[2]                     // 3
a.isEmpty                // false
a.contains(5)            // false
```

Some methods yield an Int? (an Optional Int)

```swift
a.first                  // 1
type(of: a.first)	       // Optional<Int>.Type
let n = a.first!	       // 1
if let m = a.first {
    m += 1
    print(m)             // 2
}
a.last                   // 10
```
Some methods give weird collections:

```swift
let a2 = a.reversed()
type(of: a2)
`` ReversedRandomAccessCollection<Array<Int>>.Type
```
No kidding!  If you want to do anything with it you will likely cast it to an array.


``index(of:)`` returns an optional because the value might not be present, in which case it returns ``nil``.

```swift
a = ["a","b","c"]
a.insert("spam", at: 1)
a[1..<3]                    // ["spam", b]
a.insert("eggs", at: 0)
let i = a.index(of: "spam") // 2
type(of: i)                 // Optional<Int>.Type
a.removeFirst()             // "eggs"
a.removeSubrange(1..<3)     // ["a", "c"]
[1, 2] += [3]
var arr = [1,2]
arr.append(contentsOf: [3,4])  // [1, 2, 3, 4]
```

### Map, filter and reduce

``swift
let a = Array(1..<5)
a.map { $0 + 1 }
let b = a.filter { $0 % 2 == 0 }    // [2, 4]
b
let n = Array(1..<8).reduce(1,*)    // 5040
```

More on arrays:

```swift
import Cocoa

let a1 = Array(1..<6)               // [1, 2, 3, 4, 5]
a1.dropFirst(3).count                    // 2
let a2 = Array(a1.prefix(through: 3))    // [1, 2, 3, 4]
a2 == [1,2,3,4]                     // true

func fakecmp<T>(t1: T, t2: T) -> Bool {
    return true
}

a2.elementsEqual([1,2,9,10], by: fakecmp)   // true
a2.elementsEqual([1,2], by: fakecmp)        // false!

func isEven(_ n: Int) -> Bool {
    return n % 2 == 0
}

a2.first(where: isEven)             // 2
a2.index(of: 4)                     // 3

func moreThan2(_ n: Int) -> Bool {
    return n > 2
}

a1.index(where: moreThan2 )         // 2


a1.starts(with: [1,2])              // true
a1.suffix(3)                        // [7, 8, 9]
a1.filter(isEven)                   // [2, 4, 6, 8]
```

```swift
// count the number of elements of any Equatable Type
extension Array {
    func elementCount<T: Equatable> (input: T) -> Int {
        var count = 0
        for el in self {
            if el as! T == input {
                count += 1
            }
        }
        return count
    }
}
```



