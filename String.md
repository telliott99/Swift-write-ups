### String

Swift Strings can be constructed from other strings by concatenation or by using the ``joined`` syntax, or even with ``reduce``.

Another very useful method is to interpolate the printable representation of a variable.

```swift
var s = "abc" + "def"
s = ["a", "b"].joined()
s = ["a", "b"].joined(separator: "\n")
s = ["a", "b"].reduce(", +)

let x = 5
s = "x equals \(x)"
```

String is perfectly at home with Unicode.

```swift
let smiley = "\u{263A}"  // "☺"
type(of: smiley)         // String
let smileydog = smiley + "Dog"  // "☺Dog"
```

#### CharacterView

The big thing is that much of what we do will use the underlying characters of the string

```swift
let s = "Dog"
s.count                 // error
s.characters            // String.CharacterView
s.characters.count      // 3
Array(s.characters)     // ["D", "o", "g"]
let cL: [Character] = ["C", "a", "t", "!"]
s = String(cL)          // "Cat!"
```

One can index a CharacterView with integers:

```swift
cL[1]                   // "a"
```

But for a String you gotta do this:

```swift
let s = "abcde"
var i = s.startIndex
var j = s.endIndex
let idx = s.index(j, offsetBy:-1)
s.substring(to: idx)     // "abcd"
s.substring(from: idx)   // "e"
let r = i..<idx
s.substring(with: r)     // "abcd"
```

#### CharacterSet

A String also has a UnicodeScalarView

```swift
let charset = CharacterSet("en".unicodeScalars)
let str = "Hello, world!"
// CharacterSet(charactersIn: "english")
let strChars = CharacterSet.init(str.unicodeScalars)

charset.isSubset(of: strChars)             // false
charset.isDisjoint(with: strChars)         // false
charset.intersection(strChars).isEmpty     // false
```

The first two of the methods, ``isSubset`` and ``isDisjoint``, clearly return Boolean values.  But ``intersection`` does the same, effectively, because there doesn't seem to be any way to list (or even count) the characters that it contains.  All we can do is test for ``isEmpty``.

I found it more useful to write a String extension:

```swift
extension String {
    func commonCharacters(_ s1: String) -> [String] {
        var ret: [String] = []
        for c1 in Array(Set(self.characters)) {
            for c2 in Array(Set(s1.characters)) {
                if c1 == c2 {
                    ret.append(String(c1))
                }
            }
        }
        return ret
    }
}

"Hello, world!".commonCharacters("enw")    // ["w", "e"]
```

```swift
let flowers = "Flowers 💐"
for v in flowers.utf8 {
    print(v)
}
// 70
// 108
// 111
// 119
// 101
// 114
// 115
// 32
// 240
// 159
// 146
// 144
```

```swift
let flowermoji = "💐"
for v in flowermoji.unicodeScalars {
    print(v, v.value)
}
// 💐 128144
 
for v in flowermoji.utf8 {
    print(v)
}
// 240
// 159
// 146
// 144
```

