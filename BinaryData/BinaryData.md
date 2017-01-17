### DataHelper

We begin with functions to convert data between different formats in  ``dataHelper.swift``.  The fundamental type for "data" in Swift is ``UInt8`` --- unsigned integers in the interval [0,255].

But we're used to working with binary data as hex digits --- each digit in the interval [0..9, a..f].  So we write a routine that takes a single UInt8 and returns a two character hex string:

```swift
public func byteToHex(_ input: UInt8) -> String {
    let s = String(input, radix: 16)
    if (s.characters.count == 1) {
        return "0" + s
    }
    return s
}
```
We write another function that calls this one and deals with an array of bytes:

```swift
public func byteArrayToHex(_: withSpaces: ) -> String
```

A variety of functions (that could be placed into a String extension) manipulate these hex Strings:  to remove a prefix "0x", to break a String into 2-character chunks, to add and remove whitespace.

We also have functions to go from Strings to bytes.  The one that takes a single hex 2-character String is

```swift
public func singleHexToByte(_ input: String) -> UInt8 {
    assert (input.characters.count == 2)
    assert (!(input.hasPrefix("0x")))
    return UInt8(input, radix: 16)!
}
```

Another function calls this one and so deals with a longer hex String.  Finally, we have a routine to generate four bytes, since ``arc4random`` returns a UInt32.

```swift
public func fourRandomBytes() -> [UInt8] {
    var ret = [UInt8]()
    var n = arc4random()
    for _ in 0..<4 {
        ret.append(UInt8(n % 255))
        n = n << 8
    }
    return ret
}
```

There is a function that calls this one, and returns as many random bytes as you require:

```swift
public func nRandomBytes(_: )
```

There is a test:  ``testDataHelper()``.

If we run ``dataHelper.swift`` from the command line we get:

```swift
> swift dataHelper.swift 
0a
0x0001ff4d60
0001ff4d60
32
["ab", "ra", "ca", "da", "br", "a"]
abcd
[170, 255, 13]
[170, 255, 13]
[170, 255, 13]
185cf1717c7a1ca46b52ca846baff41aaab3ab4e0a10ad6a
[24, 92, 241, 113, 124, 122, 28, 164, 107, 82, 202, 132]
[107, 175, 244, 26, 170, 179, 171, 78, 10, 16, 173, 106]
>
```

which, without going through the details, tests the functions in the module.  

Let's comment out he call to the test function before we continue.

Now, we want to be able to call this code from other Swift code.  We can start with the command line.  Put this code

```swift
testDataHelper()
``` 

into ``main.swift``.

No imports.  Just do

```bash
> swiftc dataHelper.swift main.swift -o prog && ./prog
0a
0x0001ff4d60
0001ff4d60
32
["ab", "ra", "ca", "da", "br", "a"]
abcd
[170, 255, 13]
[170, 255, 13]
[170, 255, 13]
702f74d48a0c08669846ae864ae339a6919f727c20034a1c
[112, 47, 116, 212, 138, 12, 8, 102, 152, 70, 174, 134]
[74, 227, 57, 166, 145, 159, 114, 124, 32, 3, 74, 28]
>
```

Looks like it works.  

Let's put it into a framework.  We follow the instructions in another write-up [here]().

For some reason we've changed the name of the Swift file, it has been capitalized:  DataHelper.swift.  The framework will be DataHelper.framework.  We build it and put it in ``~/Library/Frameworks``.

Modify the calling code as **test.swift**

```swift
import DataHelper

testDataHelper()
``` 

Use it by doing:

```bash
> xcrun swiftc test.swift -F ~/Library/Frameworks -sdk $(xcrun --show-sdk-path --sdk macosx) -target x86_64-apple-macosx10.12
> ./test
0a
0x0001ff4d60
0001ff4d60
32
["ab", "ra", "ca", "da", "br", "a"]
abcd
[170, 255, 13]
[170, 255, 13]
[170, 255, 13]
83513a1a54091aba1df64dc9c60fd1dce4c92a0a50ac9c06
[131, 81, 58, 26, 84, 9, 26, 186, 29, 246, 77, 201]
[198, 15, 209, 220, 228, 201, 42, 10, 80, 172, 156, 6]
>
```

The ``-target`` part is needed due to what seems to be a silly error, something about my Xcode (on 10.12) is not right, and tries to build for a target < 10.12.  This will fix it.

As you can see, the output is similar to what we had before

### BinaryData

We write a class ``BinaryData`` to explore further the **Collection** protocol in Swift.

#### minimal working example

**test.swift**

```swift
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




