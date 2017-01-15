
Historically, enumerations or ``enum``'s are a way to pass around an integer as a code for something, in a type-safe way.  From the Objective-C docs:

```objc
enum {
    NSASCIIStringEncoding = 1,		 /* 0..127 only */
    NSNEXTSTEPStringEncoding = 2,
    NSJapaneseEUCStringEncoding = 3,
    NSUTF8StringEncoding = 4,
..
};
typedef NSUInteger NSStringEncoding;
```

In the actual call to a string method, what will be passed in an NSUInteger, but the compiler makes sure your code uses  ``NSUTF8StringEncoding`` rather than 4.

```swift
// one-liner variant
enum CoinFlip { case heads, tails }

var flip: CoinFlip.heads
flip = .tails
if flip == .tails { print("tails") }
\\ prints 'tails'
```

The shorthand ``.tails`` can be used because the compiler is able to deduce that the type of ``flip`` is ``CoinFlip`` from its declaration/definition ``var flip = CoinFlip.heads``.

Note:  prior to Swift3 the cases were capitalized, but not any more.

The default associated values or raw values are the same for all vars of that type

```swift
enum ASCIIControlCharacter: Character {
    case tab = "\t"
    case lineFeed = "\n"
    case carriageReturn = "\r"
}

let c = ASCIIControlCharacter.tab

switch c {
case .tab(let value):
    print("tab: \(value)")
default:
    print("not tab")
}
```

prints what you'd expect.

I've seen a suggestion that enums may be used to not "pollute the global namespace", as we would if we just defined ``pi`` outside the ``enum`` below:

```
enum Math: Double {
  case pi = 3.14159265
  case e  = 2.718281828
}

let pi = Math.pi.rawValue

let x = pi * 2 * 2
print("\(x)")
```

```bash
> swift test.swift
12.5663706
> 
```

```swift
enum Language: String {
    case Swift
    case ObjC = "Objective-C"
    case C
}

let lang = ProgrammingLanguage.Swift
print("My favorite is : \(lang)")  // Swift
```

Here is an example with more cases:

```swift
enum CompassPoint {
    case north
    case south
    case east
    case west
}

var directionToHead = CompassPoint.west
directionToHead = .south

switch directionToHead {
case .north:
    print("Lots of planets have a north")
case .south:
    print("Watch out for penguins")
case .east:
    print("Where the sun rises")
case .west:
    print("Where the skies are blue")
}
```

```bash
> swift test.swift 
    Watch out for penguins
>
```

An ``enum`` may conform to the ``CustomStringConvertible`` protocol and thus have a nicely printing form.

As the docs describe, enumerations in Swift are much more sophisticated than what you might be used to from other languages.

Here is an example based on the fact that bar-codes can be an array of 4 integers (UPCA) or a graphic that can be converted to a potentially very long String.

```swift
enum Barcode {
    case upca(Int, Int, Int, Int)
    case qrCode(String)
}

var productBarcode = Barcode.upca(8, 85909, 51226, 3)
productBarcode = .qrCode("ABCDEFGHIJKLMNOP")

switch productBarcode {
    case .upca(let numberSystem, let manufacturer, let product, let check):
        print("UPC-A: \(numberSystem), \(manufacturer), \(product), \(check).")
    case .qrCode(let productCode):
        print("QR code: \(productCode).")
}
```
    
```swift
 > swift test.swift 
QR code: ABCDEFGHIJKLMNOP.
>
```

The above example is really pretty amazing.  We have two different values for the Barcode enum, which are based on different underlying types of data.  Furthermore, each instance of a Barcode has its individual data.  In this code:

```swift
var productBarcode = Barcode.upca(8, 85909, 51226, 3)
productBarcode = .qrCode("ABCDEFGHIJKLMNOP")
```

in the second line we are re-assigning the variable to a different Barcode.  

Because the type of ``productBarcode`` is known to the compiler, we can leave it off and just use ``.qrCode``.

Also seen in this example is the additional flexibility of ``switch`` flow control in Swift.  Each case is allowed to have setup code in parentheses

```swift
case .qrCode(let productCode):
```

Here are some other `enum`` definitions from the docs that I haven't really made into full examples yet:

```swift
enum ASCIIControlCharacter: Character {
    case Tab = "\t"
    case LineFeed = "\n"
    case CarriageReturn = "\r"
}
```
```swift
enum Planet: Int {
    case Mercury = 1, Venus, Earth, Mars, 
             Jupiter, Saturn, Uranus, Neptune 
}
```

```swift
// enum with raw values that are of type String
enum ProgrammingLanguage: String {
    case Swift = "Swift"
    case ObjC = "Objective-C"
    case C = "C"
}

let lang = ProgrammingLanguage.Swift
print("My favorite is : \(lang.rawValue)")

// works with default values
enum Language: String {
    case Swift
    case ObjC = "Objective-C"
    case C
}

let lang2 = ProgrammingLanguage.Swift
print("My favorite is : \(lang2)")
```
