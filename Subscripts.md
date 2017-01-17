### Subscripts

Here is a slightly reworked example from the docs

```swift
struct TimesTable {
    let m: Int
    subscript(index: Int) -> Int {
        return m * index
    }
}

var n = 6
let t3 = TimesTable(m: 3)
print("\(n) times \(t3.m) is \(t3[n])")
```

This prints "6 times 3 is 18" with a newline.

<hr>

If you define

```swift
subscript(index: Int) -> Int { }
```

then you can use it by calling ``s[3]`` or whatever.

Behavior includes the ability to replace both "getters" and "setters" with subscripts, as if your class were a type of dictionary.

What's wild is that subscripts

* can take any number of input parameters of any type
* may return any type
* can take variable or variadic parameters
* may not use in-out or provide default parameters
* may be overloaded

We can use subscripts with either structs or classes.  

Here's a simple example of overloading with a struct.  The first subscript takes an Int and returns a String, the second returns an Int.  What is unusual is that we are overloaded on the *return* type.

```swift
struct S {
    var a: [String] = ["Tom", "Dick", "Harry"]
    var ia: [Int] = [72, 63, 69]  // height
    
    subscript(i: Int) -> String {
        return a[i]
    }
    
    subscript(i: Int) -> Int {
        get {
            return ia[i]
        }
        set {
            ia[i] = newValue
        }
    }
}

let s = S()
let result: String = s[0]     // "Tom"
let i: Int = s[0]             // 72
let a = s[1]   // error: Ambiguous use of subscript

```

The compiler must know the type of the variable to which we do the assignment, in order to know which version of the subscript to call.  

Only the latter version has a setter.  (I'm not sure this makes any sense).

We can define an enum to provide clarity:

```
enum E {
    case u,v
}

struct S {
    var m, n : Int
    var n: Int
    
    subscript(e: E) -> Int {
        get {
            switch e {
            case .u: return self.m
            case .v: return self.n
            }
        }
        set {
            
        }
    }
}

var s = S(m:1,n:10)
s[.u]
s[.u] = 2
print s       // "S(m: 1, n: 10)\n"
```

