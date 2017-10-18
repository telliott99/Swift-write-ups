### Closures

#### Format

"Closures are self-contained chunks of code that can be passed around and used in your code."  [link](https://www.weheartswift.com/closures/)

Closures are closely related to functions, which are naturally more familiar.  We'll see in a bit how functions and closures differ, and the reason for the name "closure".  

But first, a few simple examples.  Define a function that appends "x" to an input String:

```
let a1 = ["a", "b", "c"]
func f(s: String) -> String { 
    return s + "x" }
```

**map** is an array method that takes a supplied function that acts on array elements, applies it to each member of the array, and forms a new array to contain the resulting values.

```
print(a1.map(f))      // ["ax", "bx", "cx"]
```

It isn't necessary to name the above block of code, we can instead make it anonymous by using a closure:

```
let a2 = a1.map ({ (s: String) -> (String) 
    in return "\(s)u" })
print(a2)           // ["au", "bu", "cu"]
```

The closure is the part contained between curly braces.

```
{ (s: String) -> (String) in return "\(s)u" }
```

The **in** keyword separates two elemens:  the signature (input and output parameters), and the statements that prescribe what is to be done.

Input and output parameters are separated by `->`.

#### Compiler inference

Most of this information can be inferred by the compiler, and if that's so, it isn't required.  For example, the return type (`"\(s)u"`) is clearly a String, so we can drop that:

```
let a2 = a1.map ({ (s: String)
    in return "\(s)u" })
```

There is a rule that if the closure is input as the last parameter to a function, then it can follow the call operator `()`, and if there are no other parameters, `()` can be dropped.  So this is fine:

```
let a2 = a1.map { (s: String)
    in return "\(s)u" }
```

The type of the input can be inferred from the type of the elements of the array, so we can do:

```
let a2 = a1.map { s in return "\(s)u" }
```

If there is only a single statement, then the resulting value is returned and there is no need for an explicit **return**.

```
let a2 = a1.map { (s: String) in "\(s)u" }
print(a2)           // ["au", "bu", "cu"]
```

Swift provides shorthand parameter names.  The parameters are `$0`, `$1` and so on.  This allows us to drop both the parameter(s) and the **in**.  Finally:

```
let a2 = a1.map { "\($0)u" }
```

This is not the very shortest closure.  That consists of a single character, as we'll see next.

#### Sorting

Sort has changed several times during the evolution of Swift.  

There are two methods on arrays that return a sorted copy:  `sorted` and `sorted(by:)`.

```
let a = Array(1..<5)
let b = Array(a.reversed())
b.sorted(by: { x,y in return x < y } )      // [1, 2, 3, 4]
```

We can pass `<` (for example):

```
b.sorted(by: <)      // [1, 2, 3, 4]
```

We can also pass what it is admittedly a convoluted closure:

```
b.sorted(by: { (x: Int, y: Int) -> (Bool) in
    if (x % 2 == 0) { return true }
    return false })
// [2, 4, 3, 1]
```

This has the effect of moving all the even values before the odd ones, however, the logic is incorrect for a proper sort.  If wee needed to fix that:

```
b.sorted(by: { (x: Int, y: Int) -> (Bool) in
    let ex = x % 2 == 0
    let ey = y % 2 == 0
    if ex && ey {
        return x < y }
    if ex { return true }
    if ey { return false }
    return x < y })
// [2, 4, 1, 3]
```

#### Capturing values (closure)

A classic example of a closure is a function that increments an input integer by adding a constant value. 

```
func f(_ n: Int) -> ((Int) -> (Int)) {
    return { (m: Int) -> (Int) in return m + n }
}

let g = f(10)
print(g(1))              // 11
```

This part 

```
-> ((Int) -> (Int))
```

says we are returning a function that takes an `Int` and yields an `Int`.

Calling `f` with the input `n = 10` yields a function that when called with the input `m = 1` gives the result `11`.

We can streamline this a little bit by defining a typealias for the function type:

```
typealias itr = ((Int) -> (Int))
func f(_ n: Int) -> itr {
    return { $0 + n }
}

let g = f(10)
print(g(1))              // 11
```

Here's the thing:  the closure `{ $0 + n }` can capture values from the context where `f` was called:

```
var x = 5

typealias itr = ((Int) -> (Int))
func f(_ n: Int) -> itr {
    return { return $0 + n + x }
}

let g = f(10)
print(g(1))              // 16
```

Furthermore, if we then modify 

```
x += 100
print(g(1))              // 116
```

Even though `g` was constructed at a time when the value of `x` was `5`, the value it uses in the call `print(g(1))` is updated to the new one.

The value that is captured can be a local variable inside the factory function:

```
func f(_ x: Int) -> () -> Int {
    var count = 0
    func incrementer() -> Int {
        count += x
        return count
    }
    return incrementer
}

let g = f(10)
print(g())              // 10
print(g())              // 20
```

According to [this](https://www.weheartswift.com/closures/) at the top:

Functions are a special kind of closures. There are three kinds of closures:

* global functions – they have a name and cannot capture any values

* nested functions – they have a name and can capture values from their enclosing functions 

* closure expressions – they don’t have a name and can capture values from their context

#### Filter

```
let a = [1, 2, 3, 4, 5, 6, 7, 8]`
var odd = a.filter { $0 % 2 == 1 } 

// odd = [1, 3, 5, 7]
```

#### Reduce


```
let a = [1, 2, 3, 4, 5]
numbers.reduce(0) { $0 + $1 }    // 15
```

or just

```
numbers.reduce(0, +)             // 15
```

#### File save

```
let sp = NSSavePanel()

sp.prompt = "Save File:"
sp.title = "A title"
sp.message = "A message"
// sp.worksWhenModal = true  // default

let home = NSHomeDirectory()
let d = home + "/Desktop/"
sp.directoryURL = NSURL(string: d) as URL?
sp.allowedFileTypes = ["txt"]

//sp.runModal()

sp.begin(completionHandler: { (result: Int) -> Void in
    // Swift.print(result)
    if result == NSFileHandlingPanelOKButton {
        let exportedFileURL = sp.url!
        do { try s.write(
            to: exportedFileURL, 
            atomically:true,
            encoding:String.Encoding.utf8) }
        catch { _ = runAlert("Unable to save!") }
    }
} )
```

Here, the call to the save panel to `begin` includes a callback (completionHandler).  The save panel generates an Int result which is fed to the completionHandler.  If that Int corresponds to the 

```
NSFileHandlingPanelOKButton
``` 

enum, then we try to write the file to that url.  If the save fails (a closure fed to `do`), we catch the exception and give it another closure that does `runAlert`. 