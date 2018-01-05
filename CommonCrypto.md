A while ago I ran into a blog [post](http://iosdeveloperzone.com/2014/10/03/using-commoncrypto-in-swift/) about a library (not a framework) called **CommonCrypto** on macOS.  I learned how to use it and wrote several posts of my own.  [Here](http://telliott99.blogspot.com/2015/12/commoncrypto.html) is the first one.

The CommonCrypto library is not available to Swift apps without taking special steps.  One way is to get a "bridging header" into your project.

Make a new Cocoa app in Swift, **MyApp**.  Add a new file to it --- an Objective-C file ``tmp``.  Say yes when Xcode asks if you want a bridging header.  When you're done, delete ``tmp``.  Build it just to be sure everything is fine.

In ``MyApp-Bridging-Header.h``, import what you need, in our case we do 

```objective-c
#import "CommonCrypto/CommonCrypto.h"
```

In ``AppDelegate.swift`` we do

```swift
let n = Int(CC_MD5_DIGEST_LENGTH)
print(n)
```
The Debugger prints:  

```bash
16
```

### Fake framework

A really great hack is the following method.  Make the following file:

**module.map**:

```css
module CommonCrypto [system] {
header "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.12.sdk/usr/include/CommonCrypto/CommonCrypto.h"
header "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.12.sdk/usr/include/CommonCrypto/CommonRandom.h"
export *
}
```

Find the path to the SDK your Xcode is set up to use:

```css
> xcrun --show-sdk-path --sdk macosx
/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.12.sdk
>
```

Navigate inside that to the **Frameworks** folder like this.

```css
cd $(xcrun --show-sdk-path --sdk macosx)
cd System/Library/Frameworks
```

Make a fake framework and then copy in the **module.map** file

```css
> sudo mkdir CommonCrypto.framework
Password:
> sudo cp ~/Desktop/module.map CommonCrypto.framework
> 
>
```

This code will now work in a Playground:

```css
import Foundation
import CommonCrypto

let s = "The quick brown fox jumps over the lazy dog."
let n = Int(CC_MD5_DIGEST_LENGTH)
let len = CC_LONG(s.utf8.count)

let ctx = UnsafeMutablePointer<CC_MD5_CTX>.allocate(capacity: 1)
var digest = Array<UInt8>(repeating: 0, count: n)

CC_MD5_Init(ctx)
CC_MD5_Update(ctx, s, len)
CC_MD5_Final(&digest, ctx)
ctx.deallocate(capacity: 1)

let sa = digest.map { NSString(format: "%x", $0) as String }
sa.joined(separator: "")
```
which evaluates as

```css
"e4d99c290d0fb1ca068ffa...
```

Alternatively, put it in **test.swift**, changing the last line to be a print statement.  Then from the command line:

```css
> swift test.swift
e4d99c290d0fb1ca068ffaddf22cbd0
> 
```

Playgrounds exercising different functions can be found in the folder **encryption** in this repo.

