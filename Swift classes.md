An example of a well-styled" class according to [Wenderlich](https://github.com/raywenderlich/swift-style-guide#use-of-self)

```swift
class Circle: Shape {
  var x: Int, y: Int
  var radius: Double
  var diameter: Double {
    get {
      return radius * 2
    }
    set {
      radius = newValue / 2
    }
  }

  init(x: Int, y: Int, radius: Double) {
    self.x = x
    self.y = y
    self.radius = radius
  }

  convenience init(x: Int, y: Int, diameter: Double) {
    self.init(x: x, y: y, radius: diameter / 2)
  }

  override func area() -> Double {
    return Double.pi * radius * radius
  }
}

extension Circle: CustomStringConvertible {
  var description: String {
    return "center = \(centerString) area = \(area())"
  }
  private var centerString: String {
    return "(\(x),\(y))"
  }
}
```

Although ``self.radius`` would work for use in the getter and setter for ``diameter``, or in the function ``area()``, this isn't necessary and should be avoided.  

It is necessary is in the ``init`` function, since the instance variables and the parameters to ``init`` have the same name.

If you have a function that constucts a new value of the class to be returned, its return type should be ``Self``.  ``Self`` is not the same as ``self``. 

An example would be ``advanced`` for ``Strideable``.

```swift
    func advanced(by n: Stride) -> Self {
        return type(of: self).init(value + n)
    }
```

The new value is constructed using ``type(of: self).init``, rather than ``Foo``.  To do the latter, the class must be marked ``final``.
