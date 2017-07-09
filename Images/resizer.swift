import Cocoa

/*
Usage:
xcrun swift resizer.swift filename sz
xcrun swift resizer.swift x.png 256
*/

// let args = Process.arguments!
// ht: https://www.raywenderlich.com/128039
let args = CommandLine.arguments

// no error handling
let fn = args[1]
let sz = Int(args[2])!  // Optional
print(fn)

guard let img = NSImage(contentsOfFile: fn) 
    else { exit(0) }

print(img.size)

//----------------------------------------

// if img is not square we chop it

let w = Int(img.size.width)
let h = Int(img.size.height)

let n = min(w,h)

let imgRep = NSBitmapImageRep(
    bitmapDataPlanes: nil,
    pixelsWide: sz,
    pixelsHigh: sz,
    bitsPerSample: 8,
    samplesPerPixel: 4,
    hasAlpha: true,
    isPlanar: false,
    colorSpaceName: NSCalibratedRGBColorSpace,
    bytesPerRow: w * 4,
    bitsPerPixel: 32)

// another Optional

if imgRep == nil { exit(0) }
let ir = imgRep!

// now we need to draw the image
// do this using a graphics context

let ctx = NSGraphicsContext(bitmapImageRep: ir)
NSGraphicsContext.saveGraphicsState()
NSGraphicsContext.setCurrent(ctx)

let op = NSCompositingOperation.copy
let f = CGFloat(1.0)

// draw the image not the imageRep
let dst = CGRect(x: 0, y: 0, 
    width: CGFloat(sz), height: CGFloat(sz))
let src = CGRect(x: 0, y: 0, 
    width: CGFloat(n), height: CGFloat(n))

img.draw(
    in: dst,
    from: src,
    operation: op,
    fraction: f)

ctx?.flushGraphics()
NSGraphicsContext.restoreGraphicsState()

print(ir)

let data = ir.representation(
    using: NSBitmapImageFileType.PNG,
    properties: [:])

var a = fn.characters.split{$0 == "."}.map(String.init)
let sfx = a.removeLast()
let ofn = a.joined(separator: ".")

// must have:  "file://"
let home =  NSHomeDirectory()
let d = "file://" + home + "/Desktop/"
let full = d + ofn + "." + String(sz) + "." + sfx
let path = NSURL(string: full) as URL?

do { try data!.write(to: path!, options: .atomic) }
catch { print("Oops.  Error info: \(error)") }