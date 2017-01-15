## Sorting

### sort(by: )

A significant change in Swift 2 was the move to methods on a Type, rather than global functions.  We changed ``sort(array)`` to  ``array.sort()``.  

In Swift3 things are changed again:

```swift
let a = ["C.", "B..", "A"]
a.sorted()                      // ["A", "B..", "C."]
a.sorted(by: >)                 // ["C.", "B..", "A"]

func cmp(_ a: String, _ b: String) -> Bool {
    let m = a.characters.count
    let n = b.characters.count
    if m == n {
        return a < b
    }
    return m > n
}

a.sorted(by: cmp)              // ["B..", "C.", "A"]
a                               // ["C.", "B..", "A"]
let b = a.sorted { $0 < $1 }    // ["A", "B..", "C."]
```

### Bubble sort

Bubble sort, sometimes referred to as sinking sort, is a simple sorting algorithm that repeatedly steps through the list to be sorted, compares each pair of adjacent items and swaps them if they are in the wrong order.
    
It is too slow and impractical for most problems even when compared to insertion sort.

We start at the left end of the array, and compare the first two values, call them ``a[0]`` and ``a[1]``.  If ``a[1]`` is smaller than ``a[0]``, swap the two items.  

More generally, compare the value at index ``i`` with that at ``i+1``, starting from ``i=0`` and moving through the array until ``i+1`` is equal to ``a.count-1``.
    
If you watch the animation on wikipedia, you will see that the result of this process is to find the largest element in the array on the first pass and place it at the right end.

On the second pass, we need to go only until ``i+1`` is equal to ``a.count-2``.  This pass will find the second largest value, and so on. So after ``n`` rounds the right-most ``n`` values are in sorted order.

Rather than remember which value was the largest seen so far on any one pass, we swap repeatedly.

```swift
func bubbleSort(_ a: inout [Int]) {
    var n = a.count
    while n > 0 {
        for j in 0..<n-1 {
            if a[j] > a[j+1] {
                swap(&a[j],&a[j+1])
            }
        }
        n -= 1
    }
}

let arr = [32,7,100,29,55,3,19,82,23]
var a = arr
bubbleSort(&a)
a == arr.sorted()     // true
```

We can also do this sort of thing from the command line:  add a function to print the array "pretty", and print intermediate steps.  Then call it from ``main``:

**bubbleSort**:

```swift
func pp (_ a: [Int]) {
    for n in a { 
        print("\(n)", 
            terminator: " ") 
    }
    print("")
}

func bubbleSort(_ a: inout [Int]) {
    var n = a.count
    while n > 0 {
        for j in 0..<n-1 {
            if a[j] > a[j+1] {
                swap(&a[j],&a[j+1])
            }
        }
        n -= 1
        pp(a)
    }
    pp(a)
}
```

**main**:

```swift
func test(_ f: (inout [Int]) -> ()  ) {
    var a = [32,7,100,29,55,3,19,82,23]
    f(&a)
}

test(bubbleSort
```

```bash
> swiftc bubbleSort.swift main.swift && ./main
32 7 100 29 55 3 19 82 23 
7 32 29 55 3 19 82 23 100 
7 29 32 3 19 55 23 82 100 
7 29 3 19 32 23 55 82 100 
7 3 19 29 23 32 55 82 100 
3 7 19 23 29 32 55 82 100 
3 7 19 23 29 32 55 82 100 
3 7 19 23 29 32 55 82 100 
3 7 19 23 29 32 55 82 100 
3 7 19 23 29 32 55 82 100 
3 7 19 23 29 32 55 82 100 
> 
```

Actually, we are already sorted by round 5 but the algorithm doesn't take advantage of that.

You can see how the value ``100`` "bubbles" to the end of the array in the first part of the results.  

It is also clear that there are a lot of swaps, compared with the later examples.  For random data, on the average the first value requires n/2 swaps, the second (n-1)/2, and so on.

Bubblesort is a really inefficient algorithm.  We'll see better ones in the next sections.

### Selection sort

Selection sort and insertion sort can be viewed as smarter versions of bubble sort.  In selection sort, we **remember the index** of the largest value at each round.

[wikipedia](https://en.wikipedia.org/wiki/Selection_sort)

Divide the target array into two parts, a sorted portion on the left up to the value at an index, and an unsorted part beyond that.  The fact that the part up to the index is sorted is called an **invariant**.

We maintain the index at one past the sorted portion.  Think of it as keeping our finger on that position, while our eyes scan the remaining elements to the right.  We "select" the smallest such element.

The index moves from left to right, and it is where we will place the next value.  On each pass, we start at the index and then find the minimum value remaining in the unsorted part, and  then swap with the value at the index.

```swift
func selectionSort(_ a: inout [Int]) {
    let n = a.count
    var smallest: Int = 0
    for i in 0..<n-1 {
        smallest = i
        // now look for one even smaller
        for j in i+1..<n {
            if a[j] < a[smallest] {
                smallest = j
            }
        }
        if smallest > i {
            swap(&a[i], &a[smallest])
        }
    }
}

let arr = [32,7,100,29,55,3,19,82,23]
var a = arr
selectionSort(&a)
a == arr.sorted()     // true
```

In this screenshot of the animation in the wikipedia article, freezing a late stage in the sort, you can see the division into the sorted part on the left, and the unsorted part on the right, where all values in the unsorted part are larger than those in the sorted port.

![](selectionsort.png)

Note that in the initialization phase:

```swift
var smallest: Int = 0
```

we set our sentinel value to be the lowest possible value.  If the array were to contain values less than zero, we would need to pick a smaller sentinel, like ``Int.min``.

### Insertion sort

[wikipedia](https://en.wikipedia.org/wiki/Insertion_sort)

As before, the part of the array to the left of the current index is maintained in sorted order.  However, the values to the right of the index are not all larger than the ones to the left.

![](insertionsort.png)

In insertion sort, we move across the array from left to right and simply take the next value as it comes, no matter whether large or small.  For each new value, we determine the correct place to insert it.  

Elements must be moved over as necessary.  We make fewer comparisons and more swaps than in selection sort.

This one was hard to write.  For a first pass at a solution, I found it easier to construct a new array to place the value correctly.

```swift
func insertItem(_ a: [Int], _ n: Int) -> [Int] {
    var tmp: [Int] = []
    var foundIt = false
    for v in a {
        if v > n && !foundIt {
            tmp.append(n)
            foundIt = true
        }
        tmp.append(v)
    }
    if !foundIt {
        tmp.append(n)
    }
    return tmp
}

func insertionSort(_ a: inout Array<Int>) {
    for i in 1..<a.count {
        var tmp = Array(a[0..<i])
        tmp = insertItem(tmp, a[i])
        a = tmp + a[i+1..<a.count]
    }
}

let arr = [32,7,100,29,55,3,19,82,23]
var a = arr
insertionSort(&a)
a == arr.sorted()     // true
```

A more compact approach in terms of memory is to modify the array in place.  Here is an alternative version of insertItem which does just that.

```swift
func insertItem(_ a: inout [Int], _ p: Int) {
    // find the correct place to insert
    var i = 0
    while i < p {
        if a[i] > a[p] { break }
        i += 1
    }
    if i == p { return }
    // swap until we get there
    var j = p
    while true {
        swap(&a[j-1],&a[j])
        j -= 1
        if j == i { break }
    }
}

func insertionSort(_ a: inout Array<Int>) {
    for i in 1..<a.count {
        insertItem(&a,i)
    }
}

let arr = [32,7,100,29,55,3,19,82,23]
var a = arr
insertionSort(&a)
a == arr.sorted()     // true
```