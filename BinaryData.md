## BinaryData

We explore further the **Collection** protocol in Swift, using **BinaryData** as an example.

#### minimal working example

```css
import DataHelper

public class BinaryData :  Collection, 
    CustomStringConvertible {
    public var data = Array<UInt8>()
    
    public init(_ data: [UInt8] = []) {
        self.data = data
    }
    public convenience init(_ input: String) {
        let bytes: [UInt8] = hexToBytes(input)
        self.init(bytes)
    }
    public var description: String {
        get { 
            return "0x" + byteArrayToHex(data) 
        }
    }
    public var startIndex: Int { 
        return 0 
    }
    public var endIndex: Int { 
        return data.count 
    }
    public func index(after i: Int) -> Int {
        return data.index(after: i)
    }
    public subscript(position: Int) -> UInt8 {
        get { 
            return data[position] 
        }
    }
    public subscript(bounds: Range<Int>) -> [UInt8] {
        get { 
            return Array(data[bounds]) 
        }
        set { 
            data[bounds] = ArraySlice(newValue) 
        }
    }
}

let b = BinaryData(nRandomBytes(10))
print(b)
let s = "\(b)"
print(s)
let b2 = BinaryData(s)
print(b2)
```

At the command line:

```css
> xcrun swiftc BinaryData.swift -o test -F ~/Library/Frameworks -sdk $(xcrun --show-sdk-path --sdk macosx) -target x86_64-apple-macosx10.12  && ./test
0x98671ffc2dc81ced1459
0x98671ffc2dc81ced1459
0x98671ffc2dc81ced1459
>
```

Sometimes I have gotten errors but I'm unclear on exactly what triggered them.  One way to spiff this up is to add a typealias for Index:

```css
import DataHelper

public class BinaryData :  Collection, 
    CustomStringConvertible {
    public var data = Array<UInt8>()
    public typealias Index = Int
    
    public init(_ data: [UInt8] = []) {
        self.data = data
    }
    public convenience init(_ input: String) {
        let bytes: [UInt8] = hexToBytes(input)
        self.init(bytes)
    }
    public var description: String {
        get { 
            return "0x" + byteArrayToHex(data) 
        }
    }
    public var startIndex: Index { 
        return 0 
    }
    public var endIndex: Index { 
        return data.count 
    }
    public func index(after i: Index) -> Index {
        return data.index(after: i)
    }
    public subscript(position: Index) -> UInt8 {
        get { 
            return data[position] 
        }
    }
    public subscript(bounds: Range<Int>) -> [UInt8] {
        get { 
            return Array(data[bounds]) 
        }
        set { 
            data[bounds] = ArraySlice(newValue) 
        }
    }
}

let b = BinaryData(nRandomBytes(10))
print(b)
let s = "\(b)"
print(s)
let b2 = BinaryData(s)
print(b2)
```

