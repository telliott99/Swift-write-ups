### Closures

#### Format

"Closures are self-contained chunks of code that can be passed around and used in your code."  [link](https://www.weheartswift.com/closures/)

Closures are closely related to functions, which are naturally more familiar.  We'll see in a bit how functions and closures differ, and the reason for the name "closure".  

But first, a few simple examples.  Define a function that appends "x" to an input String:

``` swift
let a1 = ["a", "b", "c"]
func f(s: String) -> String { 
    return s + "x" }
```

**map** is an array method that takes a supplied function that acts on array elements, applies it to each member of the array, and forms a new array to contain the resulting values.

``` swift
print(a1.map(f))      // ["ax", "bx", "cx"]
```

It isn't necessary to name the above block of code, we can instead make it anonymous by using a closure:

``` swift
let a2 = a1.map ({ (s: String) -> (String) 
    in return "\(s)u" })
print(a2)           // ["au", "bu", "cu"]
```

The closure is the part contained between curly braces.

``` swift
{ (s: String) -> (String) in return "\(s)u" }
```

The **in** keyword separates two elements:  the signature (input and output parameters), and the statements that prescribe what is to be done.

Input and output parameters are separated by `->`.

#### Compiler inference

Most of this information can be inferred by the compiler, and if that's so, it isn't required.  For example, the return type (`"\(s)u"`) is clearly a String, so we can drop that:

``` swift
let a2 = a1.map ({ (s: String)
    in return "\(s)u" })
```

There is a rule that if the closure is input as the last parameter to a function, then it can follow the call operator `()`, and if there are no other parameters, `()` can be dropped.  So this is fine:

``` swift
let a2 = a1.map { (s: String)
    in return "\(s)u" }
```

The type of the input can be inferred from the type of the elements of the array, so we can do:

``` swift
let a2 = a1.map { s in return "\(s)u" }
```

If there is only a single statement, then the resulting value is returned and there is no need for an explicit **return**.

``` swift
let a2 = a1.map { s in "\(s)u" }
print(a2)           // ["au", "bu", "cu"]
```

Swift provides shorthand parameter names.  The parameters are `$0`, `$1` and so on.  This allows us to drop both the parameter(s) and the **in**.  Finally:

``` swift
let a2 = a1.map { "\($0)u" }
```

This is not the very shortest closure.  That consists of a single character, as we'll see next.

#### Sorting

Sort has changed several times during the evolution of Swift.  

There are currently two methods on arrays that return a sorted copy:  `sorted` and `sorted(by:)`.

``` swift
let a = Array(1..<5)
let b = Array(a.reversed())
b.sorted(by: { x,y in return x < y } )      // [1, 2, 3, 4]
```

We can pass `<` (for example):

``` swift
b.sorted(by: <)      // [1, 2, 3, 4]
```

We can also pass what is admittedly a convoluted closure:

``` swift
b.sorted(by: { (x: Int, y: Int) -> (Bool) in
    if (x % 2 == 0) { return true }
    return false })
// [2, 4, 3, 1]
```

This has the effect of moving all the even values before the odd ones, however, the logic is incorrect for a proper sort.  If we want to fix that:

``` swift
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

A classic demonstration example of a closure is a function that increments an input integer by adding a constant value. 

``` swift
func f(_ n: Int) -> ((Int) -> (Int)) {
    return { (m: Int) -> (Int) in return m + n }
}

let g = f(10)
print(g(1))              // 11
```

This part 

``` swift
-> ((Int) -> (Int))
```

says we are returning a function that takes an `Int` and yields an `Int`.

Calling `f` with the input `n = 10` yields a function that when called with the input `m = 1` gives the result `11`.

We can streamline this a little bit by defining a typealias for the function signature:

``` swift
typealias itr = ((Int) -> (Int))
func f(_ n: Int) -> itr {
    return { $0 + n }
}

let g = f(10)
print(g(1))              // 11
```

Here's the thing:  the closure `{ $0 + n }` can capture values from the context where `f` was called:

``` swift
var x = 5

typealias itr = ((Int) -> (Int))
func f(_ n: Int) -> itr {
    return { return $0 + n + x }
}

let g = f(10)
print(g(1))              // 16
```

Furthermore, if we then modify 

``` swift
x += 100
print(g(1))              // 116
```

Even though `g` was constructed at a time when the value of `x` was `5`, the value it uses in the call `print(g(1))` is updated to the new one.

The value that is captured can be a local variable inside the factory function:

``` swift
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

Here's another example:

``` swift
var iL = [Int]()

// initialization required even though value is not used
var x: Int = 0

func f() -> (() -> Void )  {
    x = -1
    func g() {
        iL.append(x)
    }
    return g
}

let h = f()

for i in 1...3 {
    x = i
    h()
}

iL					// [1, 2, 3]
```



According to [this](https://www.weheartswift.com/closures/):

Functions are a special kind of closures. There are three kinds of closures:

* global functions – they have a name and cannot capture any values

* nested functions – they have a name and can capture values from their enclosing functions 

* closure expressions – they don’t have a name and can capture values from their context

#### Filter

``` swift
let a = [1, 2, 3, 4, 5, 6, 7, 8]`
var odd = a.filter { $0 % 2 == 1 } 

// odd = [1, 3, 5, 7]
```

#### Reduce


``` swift
let a = [1, 2, 3, 4, 5]
numbers.reduce(0) { $0 + $1 }    // 15
```

or just

``` swift
numbers.reduce(0, +)             // 15
```

#### File save

``` swift
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

Here, the call to the save panel to `begin` includes a callback (completionHandler) which is a closure.  

The save panel generates an Int result which is fed to the completionHandler.  If that Int corresponds to the 

``` swift
NSFileHandlingPanelOKButton
``` 

enum, then we try to write the file to that url.  If the save fails (a closure fed to `do`), we catch the exception and give it another closure that does `runAlert`. 

#### Exercises

[link](https://www.weheartswift.com/closures/)

* Write a function named `applyKTimes` that takes an integer K and a closure and calls the closure `K` times. The closure will not take any parameters and will not have a return value.

``` swift
func applyKTimes(_ k: Int, _ cls: (() -> ()) ) {
    for _ in 1...k { cls() } }

applyKTimes(2, { print("hi") } )

```

```
> swift x.swift 
hi
hi
>
```

* Use `filter` to create an array called `multiples` that contains all the multiples of 3 from numbers and then print it.

``` swift
func f(_ input: [Int]) -> () {
    let multiples = input.filter { $0 % 3 == 0 }
    print("\(multiples)")
}

f([1,3,5,7,9,11])               // [3, 9]
```

* Find the largest number from numbers and then print it. Use reduce to solve this exercise.

``` swift
var a = Array(1...100)
let greatest = a.reduce(Int.min) { 
    if $1 > $0 { return $1 };  return $0  }

print("\(greatest)")           // 100
```

* Join all the strings from strings into one using reduce . Add spaces in between strings. Print your result.

``` swift
let a = ["a", "b"]
let result = a.reduce("") { return $0 + " " + $1 }
print(result)
```

To remove the space at the beginning, capture a global variable:

``` swift
let a = ["a", "b"]
var first = true
let result = a.reduce("") { 
    if (first) { first = false;  return $1 } 
    else { return $0 + " " + $1 }
}
print(result)
```

* Sort numbers in ascending order by the number of divisors. If two numbers have the same number of divisors the order in which they appear in the sorted array does not matter.

* Find the sum of the squares of all the odd numbers from numbers and then print it. Use map , filter and reduce to solve this problem.

``` swift
let a = 1...100
print(a.filter { $0 % 2 == 1 }
    .map { $0 * $0 }.reduce(0,+))
```

* Implement a function forEach(array: [Int], _ closure: Int -> ()) that takes an array of integers and a closure and runs the closure for each element of the array.

``` swift
typealias typ = ((Int) -> ())

var cls: typ = { 
    for _ in 1...$0 { print("x", terminator:"") };  print("o") }

func forEach(_ a: [Int], _ closure: typ) {
    _ = a.map(closure)
}

forEach([1,2,3], cls)
```

```
> swift x.swift 
xo
xxo
xxxo
>
```

* Implement a function combineArrays that takes 2 arrays and a closure that combines 2 Ints into a single Int. The function combines the two arrays into a single array using the provided closure. Assume that the 2 arrays have equal length.

``` swift
let a = Array(1...4)      // length mismatch caught below
let b = Array(11...13)

typealias typ = ((Int,Int) -> (Int)) 
var cls: typ = { $0 + $1 }

func combineArrays(_ a: [Int], _ b: [Int], _ cls: typ) {
    let n = min(a.count,b.count) - 1
    for i in 0...n {
        print(cls(a[i],b[i]))
    }
}

combineArrays(a,b,cls)
```

Of course, we don't actually need to define the closure here.  We could use `+`, or even `*`.  Substitute this function definition:

``` swift
func combineArrays(_ a: [Int], _ b: [Int], _ cls: typ) {
    let n = min(a.count,b.count) - 1
    for i in 0...n {
        print(cls(a[i],b[i]))
    }
}

combineArrays(a,b,*)
```

```
> swift x.swift 
11
24
39
>
```

