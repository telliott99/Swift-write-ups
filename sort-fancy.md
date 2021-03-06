## Sorting:  fancy

### Mergesort

In the real world, mergesort and quicksort are common.  The first one works by the following idea:  if two arrays are already sorted, then they can be merged quickly into one sorted array.  

We practice divide and conquer, at each stage we divide a larger list into two smaller ones that are themselves mergesort'ed.  Eventually we reach arrays of length 1, which are already "sorted".

```swift
func merge(_ array1: [Int], _ array2: [Int]) -> [Int] {
    // array1 and array2 are sorted already
    var ret: [Int] = Array<Int>()
    var a = array1
    var b = array2
    while a.count > 0 || b.count > 0 {
        if a.count == 0 {
            ret += b
            break
        }
        if b.count == 0 {
            ret += a
            break
        }
        if a[0] < b[0] {
            ret.append(a.removeFirst())
        }
        else {
            ret.append(b.removeFirst())
        }
    }
    return ret
}

func mergeSort(_ a: inout [Int]) -> [Int] {
    if a.count == 1 { return a }
    if a.count == 2 { return merge([a[0]],[a[1]]) }
    let i = a.count/2
    var sub1 = Array(a[0...i])
    var sub2 = Array(a[i+1...a.count-1])
    let a1 = mergeSort(&sub1)
    let a2 = mergeSort(&sub2)
    return merge(a1, a2)
}


let arr = [32,7,100,29,55,3,19,82,23]
var a = arr
a = mergeSort(&a)
a == arr.sorted()     // true
```

### Quicksort

The idea of quicksort is described

[here](https://en.wikipedia.org/wiki/Quicksort) and [here](http://www.algolist.net/Algorithms/Sorting/Quicksort)

The implementation I show is similar to the one above for mergesort in using a lot of memory by allocating new arrays at each stage.  In return we gain simplicity.  

Again, the divide-and-conquer strategy is employed.

At each stage, we pick a pivot (not necessarily a value contained in the array, but lying between the ``min`` and ``max`` elements).  Then, divide the array into two sub-arrays consisting of elements that are ``<=`` or ``>`` than the pivot.

Although some sources say the pivot can be chosen randomly (or, for example, as the mid element of the array), for certain arrays this strategy results in a process that never ends.

To fix this, we find the largest and smallest elements and pick a value that is halfway between them using ``minMax``.

```swift
func minMax(_ a: [Int]) -> (Int,Int) {
    var m = a[0]
    var n = a[0]
    for v in a {
        if v < m { m = v }
        if v > n { n = v }
    }
    return (m,n)
}

func qsort(_ a: [Int]) -> [Int] {
    print("\nqsort \(a)")
    let count = a.count
    if count == 0 { return [Int]() }
    if count == 1 { return a }
    let (m,n) = minMax(a)
    if m == n { return a }

    let p = (n-m)/2 + m
    print("p = \(p)")
    var a1: [Int] = []
    var a2: [Int] = []

    for v in a {
        if v <= p { 
            print("append \(v) to \(a1)")
            a1.append(v)
        }
        else { 
            print("append \(v) to \(a2)")
            a2.append(v) 
        }
    }
    return  qsort(a1) + qsort(a2)
}

var a = [4,37,1,2,15,6,3,7,9,13,6,1]
let r = qsort(a)
print(r)
```

```bash
> swift quicksort.swift 

qsort [4, 37, 1, 2, 15, 6, 3, 7, 9, 13, 6, 1]
p = 19
append 4 to []
append 37 to []
append 1 to [4]
append 2 to [4, 1]
append 15 to [4, 1, 2]
append 6 to [4, 1, 2, 15]
append 3 to [4, 1, 2, 15, 6]
append 7 to [4, 1, 2, 15, 6, 3]
append 9 to [4, 1, 2, 15, 6, 3, 7]
append 13 to [4, 1, 2, 15, 6, 3, 7, 9]
append 6 to [4, 1, 2, 15, 6, 3, 7, 9, 13]
append 1 to [4, 1, 2, 15, 6, 3, 7, 9, 13, 6]

qsort [4, 1, 2, 15, 6, 3, 7, 9, 13, 6, 1]
p = 8
append 4 to []
append 1 to [4]
append 2 to [4, 1]
append 15 to []
append 6 to [4, 1, 2]
append 3 to [4, 1, 2, 6]
append 7 to [4, 1, 2, 6, 3]
append 9 to [15]
append 13 to [15, 9]
append 6 to [4, 1, 2, 6, 3, 7]
append 1 to [4, 1, 2, 6, 3, 7, 6]

qsort [4, 1, 2, 6, 3, 7, 6, 1]
p = 4
append 4 to []
append 1 to [4]
append 2 to [4, 1]
append 6 to []
append 3 to [4, 1, 2]
append 7 to [6]
append 6 to [6, 7]
append 1 to [4, 1, 2, 3]

qsort [4, 1, 2, 3, 1]
p = 2
append 4 to []
append 1 to []
append 2 to [1]
append 3 to [4]
append 1 to [1, 2]

qsort [1, 2, 1]
p = 1
append 1 to []
append 2 to []
append 1 to [1]

qsort [1, 1]

qsort [2]

qsort [4, 3]
p = 3
append 4 to []
append 3 to []

qsort [3]

qsort [4]

qsort [6, 7, 6]
p = 6
append 6 to []
append 7 to []
append 6 to [6]

qsort [6, 6]

qsort [7]

qsort [15, 9, 13]
p = 12
append 15 to []
append 9 to []
append 13 to [15]

qsort [9]

qsort [15, 13]
p = 14
append 15 to []
append 13 to []

qsort [13]

qsort [15]

qsort [37]
[1, 1, 2, 3, 4, 6, 6, 7, 9, 13, 15, 37]
> 
```

I'm sure you can write better implementations than these.  We should try to do mergesort and quicksort without all this array allocation.