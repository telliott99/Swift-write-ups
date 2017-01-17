import Foundation

// ---------------------------------
// Convert UInt8 bytes to hex
// ---------------------------------

// single byte to 2 hex digits
public func byteToHex(_ input: UInt8) -> String {
    let s = String(input, radix: 16)
    if (s.characters.count == 1) {
        return "0" + s
    }
    return s
}

// multiple bytes to:  0dd9bbc38db4dc or similar
public func byteArrayToHex(_ input: [UInt8], 
        withSpaces: Bool = false) -> String {
    let ret = input.map { byteToHex($0) }
    if withSpaces {
        return ret.joined(separator: " ")
    }
    return ret.joined()
}

// ---------------------------------
// String stuff
// ---------------------------------

public func removePrefix(_ input: String, sz: Int = 2) -> String {
    let idx = input.index(input.startIndex, offsetBy: sz)
    return input.substring(from: idx)
}

public func chunks <T> (_ input: [T], sz: Int = 2) -> [[T]] {
    var tmp = input
    var ret = [[T]]()
    var chunk = [T]()
    while (tmp.count != 0) {
        for _ in 0..<sz {
            if tmp.count != 0 {
                chunk.append(tmp.removeFirst())
            }
        }
        ret.append(chunk)
        chunk = [T]()
    }
    return ret
}

public func string_chunks (_ input: String, sz: Int = 2) -> [String] {
    let tmp = Array(input.characters).map {String($0)}
    let ret: [[String]] = chunks(tmp)
    return ret.map { $0.joined(separator: "") }
}


public func isValidByteString(_ input: String) -> Bool {
    let validChars = "0123456789abcdef".characters
    for c in input.characters {
        if !validChars.contains(c) {
            return false
        }
    }
    return true
}

public func removeWhitespace(_ input: String) -> String {
    let cL = input.characters
    let ret = cL.filter { $0 != " " }
    return String(ret)
}

// ---------------------------------
// String Extension
// ---------------------------------

public extension String {
    public func stripCharactersInList(_ cL: CharacterView) -> String {
       var a = [Character]()
       for c in self.characters {
           if cL.contains(c) {
               continue
           }
           a.append(c)
       }
       return a.map{String($0)}.joined()
    }
    
    public func splitOnStringCharacter(s: String) -> [String] {
        let c = Character(s)
        let a = self.characters.split { $0 == c }
        return a.map { String($0) }
    }

}

// ---------------------------------
// hex bytes to UInt8
// ---------------------------------

// must have removed "0x" prefix from hex
public func singleHexToByte(_ input: String) -> UInt8 {
    assert (input.characters.count == 2)
    assert (!(input.hasPrefix("0x")))
    return UInt8(input, radix: 16)!
}

public func hexToBytes(_ input: String) -> [UInt8] {
    var tmp = input
    if tmp.hasPrefix("0x") {
        tmp = removePrefix(input, sz: 2)
    }
    tmp = removeWhitespace(tmp)
    
    // var ret = Array<UInt8>()
    guard tmp.characters.count % 2 == 0 else { return [] }
    let hL = string_chunks(tmp, sz: 2)
    let ret = hL.map { UInt8($0, radix: 16)! }
    
    /*
    while hL.count > 0 {
        let h = hL.removeFirst()
        ret.append(UInt8(h, radix: 16)!)
    }
    */
    return ret
}

// ---------------------------------
// Random stuff
// ---------------------------------

/* 
   How to get random bytes?  
   Unfortunately..
   "'rand()' is unavailable in Swift: 
   Use arc4random instead."
   WTF
   
   arc4random is not seedable, by design, 
   which will be an issue for crypto demos
   
   arc4random() returns a UInt32 not UInt
   Don't waste the extra bytes
 
   [UInt8] subscripting is weird, see below
*/

public func fourRandomBytes() -> [UInt8] {
    var ret = [UInt8]()
    var n = arc4random()
    for _ in 0..<4 {
        ret.append(UInt8(n % 255))
        n = n << 8
    }
    // below should work but fails for type issues
    /*
    ret.append((n & 0xFF000000) >> UInt(24))
    // doesn't work with UInt either
    */
    return ret
}
  
/* 
   discussion of the return statement above:
   0..<count gives a CountableRange
   for ?? reasons:  
   you *cannot* index [UInt8] with that
   
   so we specifically construct a Range
   but the result of ret[Range(0..<count)] is a "slice"
   so we have to cast that to an Array
   
   and it works
*/

public func nRandomBytes(_ count: Int = 4) -> [UInt8] {
    var ret = [UInt8]()
    while ret.count < count {
        ret += fourRandomBytes()
    }
    let r = Range(0..<count)
    return Array(ret[r])
}

// ---------------------------------
// Test
// ---------------------------------

public func testDataHelper() {
    print(byteToHex(10))
    let byteString = "0x" + byteArrayToHex([0,1,255,77,96])
    print(byteString)
    print(removePrefix(byteString, sz: 2))
    print(singleHexToByte("20"))
    
    print(string_chunks("abracadabra"))
    print("ab cd".stripCharactersInList(" ".characters))
    
    print(hexToBytes("aaff0d"))
    print(hexToBytes("0xaaff0d"))
    print(hexToBytes("0x aa ff 0d"))
    let bL = nRandomBytes(24)
    let h = byteArrayToHex(bL)
    print(h)
    let bL2 = hexToBytes(h)
    let i = bL2.count/2
    print(bL2[0..<i])
    print(bL2[i..<bL2.count])
}
