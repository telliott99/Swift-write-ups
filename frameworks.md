## Multiple files with code --- frameworks

Even for small projects, it is nice to have the ability to split up your code into several files.

In Swift, we can do this in different ways.  Three that we discuss here are:  working from the command line, adding resources to a Playground, or making a Framework.

### Command line

**stringStuff.swift**:

```css
import Foundation

extension String {
    func stripCharacters(input: String) -> String {
        let badChars = input.characters
        let ret = self.characters.filter {
            !badChars.contains($0) }
        return String(ret)
    }
}
```

**main.swift**:

```css
var s = "a$b#c."
print(s.stripCharacters(input: "$#."))
```

This name for the main file is required.  On the command line:

```css
> swiftc stringStuff.swift main.swift -o prog && ./prog
abc
>
```

### Playground

I followed the instructions [here](http://help.apple.com/xcode/mac/8.0/#/devfa5bea3af) to copy the file **StringStuff.swift** to the Resources folder of a Playground project.

![](figs/playground_source.png)

Import of the code as a module happens automatically, there is no need for an import statment.  An important difference from the first method is that the symbols to be accessed must be marked ``public``.

### Framework

To build the framework, follow my instructions [here](http://telliott99.blogspot.com/2015/12/building-and-using-framework-in-swift.html).

In Xcode do:  

* OS X > New Project > Cocoa Framework > Swift

* name:  StringStuff.framwork

* Add the Swift file stringStuff.swift

* Build it

* Under Products, find StringStuff.framework

* Control-click to Show In Finder, drag to Desktop


Finally

```css
cp -r StringStuff.framework ~/Library/Frameworks
```

To use the new Framework

**x.swift**:

```css
import StringStuff
var s = "a$b#c"
print(s.stripCharacters(input: "$#"))
```

From the command line:

```css
xcrun swiftc x.swift -F ~/Library/Frameworks -sdk $(xcrun --show-sdk-path --sdk macosx)
```

This should work but fails with an error:

```css
x.swift:1:8: error: module file's minimum deployment target is OS X v10.12: /Users/telliott_admin/Library/Frameworks/StringStuff.framework/Modules/StringStuff.swiftmodule/x86_64.swiftmodule
import StringStuff
       ^
```

I will show how to fix this problem below.

Meanwhile, I made a new Xcode project.  I added the String Stuff Famework to "Linked Frameworks and Libraries" following the instructions [here](http://telliott99.blogspot.com/2015/12/building-and-using-framework-in-swift.html):

I put the three lines of code from above into the **AppDelegate**.  When built and run, it logs what we expect to the Debug area.

## Deployment target

Our current situation is that when **x.swift** is contained in an Xcode project it can find and use the StringStuff Framework from ``~/Library/Frameworks/StringStuff.framework``, but when we try from the command line it fails.

Some good advice, which I found [here](http://onebigfunction.com/tools/2015/02/03/xcrun-execute-xcode-tasks-from-command-line/), is to examine the commands Xcode issued to compile **x.swift**.  

![](figs/target.png)

One of the very first flags to the compiler is

```css
-target x86_64-apple-macosx10.12
```

Let's try it:

```css
> xcrun swiftc x.swift -F ~/Library/Frameworks -sdk $(xcrun --show-sdk-path --sdk macosx) -target x86_64-apple-macosx10.12
> ./x
abc
>
```

It works!
