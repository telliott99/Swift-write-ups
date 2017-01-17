### Hashable

The Hashable protocol extends Equatable, and requires in addition, that a class implement the variable ``hashValue``, which must give an Int.

```swift
import Cocoa

class X: CustomStringConvertible {
    var data = Int()
    init(data: Int) {
        self.data = data
    }
    var description: String {
        return String("X: \(data)")
    }
}

extension X: Hashable, Equatable {
    var hashValue: Int {
        return data
    }
}

func ==(lhs: X, rhs: X) -> Bool {
    return lhs.data == rhs.data
}
```
To be a Dictionary key, an object must conform to Hashable.  This code works

```swift
var d: [X:String] = [:]
d[X(data: 1)] = "one"
d[X(data: 10)] = "ten"
for (k,v) in d {
    print(k, v)
}
```

It will write to the Debugger in a Playground:

```bash
X: 1 one
X: 10 ten```

