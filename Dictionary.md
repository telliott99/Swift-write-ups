### Dictionary

Everything prints what you'd expect in a Playground.

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

var d: [X:String] = [:]
d[X(data: 1)] = "one"
d[X(data: 10)] = "ten"

func filter(key: X, value: String) -> Bool {
    if value == "one" { return true }
    return false
}
d.contains(where: filter)     // true

let x1 = X(data: 1)
let x10 = X(data: 10)

d.keys.contains(x1)
Array(d.values)
d.removeValue(forKey: x1)
d
d.updateValue("def", forKey: x10)
d.updateValue("abc", forKey: x1)
d

```
